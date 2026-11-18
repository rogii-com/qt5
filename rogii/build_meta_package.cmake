# Makes the qt meta package from the variant archives in ENV{ENV_INSTALL}:
# qtdefault is required, qtasserts is optional.

if(NOT DEFINED ENV{ENV_INSTALL})
    message(
        FATAL_ERROR
        "You have to specify the directory of the variant archives via `ENV{ENV_INSTALL}' variable."
    )
endif()

file(
    TO_CMAKE_PATH
    "$ENV{ENV_INSTALL}"
    ROOT
)

set(
    ARCH
    amd64
)

set(
    BUILD
    0
)

if(DEFINED ENV{BUILD_NUMBER})
    set(
        BUILD
        $ENV{BUILD_NUMBER}
    )
endif()

set(
    TAG
    "$ENV{TAG}"
)

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)

function(find_variant_package VARIANT RESULT_VARIABLE)
    file(
        GLOB
            ARCHIVES
        RELATIVE
            "${ROOT}"
        "${ROOT}/qt${VARIANT}-${ROGII_PKG_VERSION}-${ARCH}-*${TAG}.7z"
    )

    list(
        LENGTH
            ARCHIVES
            COUNT
    )

    if(COUNT GREATER 1)
        message(
            FATAL_ERROR
            "Several qt${VARIANT} archives in ${ROOT}: ${ARCHIVES}"
        )
    endif()

    string(
        REGEX REPLACE
            "\\.7z$"
            ""
            PACKAGE
            "${ARCHIVES}"
    )

    set(
        ${RESULT_VARIABLE}
        "${PACKAGE}"
        PARENT_SCOPE
    )
endfunction()

find_variant_package(default DEFAULT_PACKAGE)
find_variant_package(asserts ASSERTS_PACKAGE)

if(DEFAULT_PACKAGE STREQUAL "")
    message(
        FATAL_ERROR
        "No qtdefault-${ROGII_PKG_VERSION}-${ARCH}-*${TAG}.7z in ${ROOT}"
    )
endif()

set(
    PACKAGE_NAME
    "qt-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

message(
    STATUS
    "${PACKAGE_NAME}: default = ${DEFAULT_PACKAGE}; asserts = ${ASSERTS_PACKAGE}"
)

configure_file(
    "${CMAKE_CURRENT_LIST_DIR}/meta/package.cmake.in"
    "${ROOT}/${PACKAGE_NAME}/package.cmake"
    @ONLY
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND} -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        ${ROOT}
    COMMAND_ERROR_IS_FATAL
        ANY
)
