if(NOT COMMAND apply_patches)
function(apply_patches PATCH_DIR)
    if(NOT PATCH_DIR)
        message(FATAL_ERROR "apply_patches: first argument PATCH_DIR is required")
    endif()

    # Ensure Git is available
    if(NOT GIT_EXECUTABLE)
        find_package(Git REQUIRED)
    endif()

    if(NOT EXISTS "${PATCH_DIR}")
        message(STATUS "apply_patches: patch directory not found: ${PATCH_DIR} — skipping")
        return()
    endif()

    # Detect repository root (top-level) using this script's location
    execute_process(
        COMMAND ${GIT_EXECUTABLE} -C "${CMAKE_CURRENT_LIST_DIR}" rev-parse --show-toplevel
        RESULT_VARIABLE _TOPLVL_RES
        OUTPUT_VARIABLE _REPO_ROOT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
    if(NOT _TOPLVL_RES EQUAL 0 OR NOT EXISTS "${_REPO_ROOT}")
        # Fallback for atypical layouts
        set(_REPO_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
        message(WARNING "apply_patches: failed to auto-detect repo root, falling back to: ${_REPO_ROOT}")
    endif()

    # Gather submodules (paths relative to repo root)
    execute_process(
        COMMAND ${GIT_EXECUTABLE} -C "${_REPO_ROOT}" submodule status --recursive
        RESULT_VARIABLE _SM_RES
        OUTPUT_VARIABLE _SM_OUT
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_QUIET
    )
    set(_SUBMODULES "")
    if(_SM_RES EQUAL 0 AND _SM_OUT)
        string(REPLACE "\n" ";" _SM_LINES "${_SM_OUT}")
        foreach(_L IN LISTS _SM_LINES)
            string(STRIP "${_L}" _LSTR)
            if(_LSTR STREQUAL "")
                continue()
            endif()
            # Format: "<status><sha> <path> (branch)"
            string(REGEX REPLACE "^[^ ]+ +([^ ]+).*$" "\\1" _SM_PATH "${_LSTR}")
            list(APPEND _SUBMODULES "${_SM_PATH}")
        endforeach()
    endif()

    # Collect patches: top-level and one subdir level (e.g., qtbase/*.patch)
    file(GLOB _PATCHES LIST_DIRECTORIES FALSE
        "${PATCH_DIR}/*.patch" "${PATCH_DIR}/*.diff"
        "${PATCH_DIR}/*/*.patch" "${PATCH_DIR}/*/*.diff"
    )
    list(SORT _PATCHES)
    if(NOT _PATCHES)
        message(STATUS "apply_patches: no patches found in ${PATCH_DIR}")
        return()
    endif()

    message(STATUS "apply_patches: applying patches from ${PATCH_DIR}")
    foreach(_P IN LISTS _PATCHES)
        # Default: apply at repo root with -p0
        set(_TARGET_DIR "${_REPO_ROOT}")
        set(_STRIP_P 0)
        set(_ROUTED_BY_DIR FALSE)

        # Heuristic 1: directory-based routing (PATCH_DIR/<submodule>/...)
        if(_SUBMODULES)
            file(RELATIVE_PATH _REL_UNDER_PATCHDIR "${PATCH_DIR}" "${_P}")
            string(REGEX MATCH "^[^/\\]+" _FIRST_COMP "${_REL_UNDER_PATCHDIR}")
            foreach(_SM IN LISTS _SUBMODULES)
                if(_FIRST_COMP STREQUAL "${_SM}")
                    set(_TARGET_DIR "${_REPO_ROOT}/${_SM}")
                    # Usually patch files placed under <submodule>/ are already relative to that submodule (no extra leading '<submodule>/'),
                    # so -p0 is typically correct. Leave _STRIP_P=0 here.
                    set(_ROUTED_BY_DIR TRUE)
                    break()
                endif()
            endforeach()
        endif()

        # Heuristic 2: parse patch header to detect submodule and decide strip
        if(NOT _ROUTED_BY_DIR AND _SUBMODULES)
            file(READ "${_P}" _PATCH_CONTENT LIMIT 8192) # header is small
            # Try to capture '+++ b/<top>/' (or '--- a/<top>/')
            set(_HDR_MATCH "")
            string(REGEX MATCH "^[+-]{3} [ab]/([^/\n\r]+)/" _HDR_MATCH "${_PATCH_CONTENT}")
            if(NOT _HDR_MATCH STREQUAL "")
                string(REGEX REPLACE "^[+-]{3} [ab]/([^/\n\r]+)/.*$" "\\1" _HDR_TOP "${_HDR_MATCH}")
                foreach(_SM IN LISTS _SUBMODULES)
                    if(_HDR_TOP STREQUAL "${_SM}")
                        set(_TARGET_DIR "${_REPO_ROOT}/${_SM}")
                        # Header path starts with '<submodule>/', so when applying *inside* the submodule,
                        # we need to drop that leading component -> use -p1.
                        set(_STRIP_P 1)
                        break()
                    endif()
                endforeach()
            endif()
        endif()

        message(STATUS "→ ${_P}  (target: ${_TARGET_DIR}, -p${_STRIP_P})")

        # Try two strip levels for robustness: primary then fallback
        set(_TRY_P_LIST "${_STRIP_P}")
        if(_STRIP_P EQUAL 0)
            list(APPEND _TRY_P_LIST 1)
        else()
            list(APPEND _TRY_P_LIST 0)
        endif()

        set(_APPLIED FALSE)
        foreach(_TRY_P IN LISTS _TRY_P_LIST)
            if(_TRY_P GREATER 0)
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} -C "${_TARGET_DIR}" apply -p${_TRY_P} --3way --whitespace=fix --ignore-space-change "${_P}"
                    RESULT_VARIABLE _APPLY_RES
                    OUTPUT_VARIABLE _APPLY_OUT
                    ERROR_VARIABLE  _APPLY_ERR
                )
            else()
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} -C "${_TARGET_DIR}" apply --3way --whitespace=fix --ignore-space-change "${_P}"
                    RESULT_VARIABLE _APPLY_RES
                    OUTPUT_VARIABLE _APPLY_OUT
                    ERROR_VARIABLE  _APPLY_ERR
                )
            endif()

            if(_APPLY_RES EQUAL 0)
                set(_APPLIED TRUE)
                message(STATUS "   applied with -p${_TRY_P}")
                break()
            endif()

            # Idempotency check: already applied?
            if(_TRY_P GREATER 0)
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} -C "${_TARGET_DIR}" apply -p${_TRY_P} --reverse --check "${_P}"
                    RESULT_VARIABLE _REV_OK
                    OUTPUT_QUIET ERROR_QUIET
                )
            else()
                execute_process(
                    COMMAND ${GIT_EXECUTABLE} -C "${_TARGET_DIR}" apply --reverse --check "${_P}"
                    RESULT_VARIABLE _REV_OK
                    OUTPUT_QUIET ERROR_QUIET
                )
            endif()

            if(_REV_OK EQUAL 0)
                set(_APPLIED TRUE)
                message(STATUS "   (already applied) skipping (detected with -p${_TRY_P})")
                break()
            endif()
        endforeach()

        if(NOT _APPLIED)
            message(FATAL_ERROR
                "apply_patches: failed to apply:\n  ${_P}\n${_APPLY_ERR}\n(target: ${_TARGET_DIR})")
        endif()
    endforeach()
endfunction()
endif()
