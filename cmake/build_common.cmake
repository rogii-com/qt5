if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

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
    ""
)

if(DEFINED ENV{TAG})
    set(
        TAG
        "$ENV{TAG}"
    )
else()
    find_package(
        Git
    )

    if(Git_FOUND)
        execute_process(
            COMMAND
                ${GIT_EXECUTABLE} rev-parse --short HEAD
            OUTPUT_VARIABLE
                TAG
            OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        set(
            TAG
            "_${TAG}"
        )
    endif()
endif()

set(
    VERSION
    5.15.1
)

set(
    PACKAGE_NAME
    "qt-${VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    DEBUG_PATH
    "${CMAKE_CURRENT_LIST_DIR}/../build/debug"
)

file(
    MAKE_DIRECTORY
    "${DEBUG_PATH}"
)

set(
    NPM_ROOT
    "${ENV_INSTALL}"
)

if(WIN32)
    set(
        CMAKE_GENERATOR
        -G "NMake Makefiles"
    )
endif()

execute_process(
    COMMAND
       "${CMAKE_COMMAND}" ${CMAKE_GENERATOR} -DCMAKE_BUILD_TYPE=Debug -DCMAKE_INSTALL_PREFIX=${ROOT}/${PACKAGE_NAME} ../.. 
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY
        "${DEBUG_PATH}"
)

if(UNIX)
    #strip all shared not symlink libs
    file(GLOB files "${ROOT}/${PACKAGE_NAME}/lib/*.so*")
    foreach(file ${files})
        if(NOT IS_SYMLINK ${file})
            message(STATUS "strip ${file}")
            execute_process(
                COMMAND
                    bash ${CMAKE_CURRENT_LIST_DIR}/utils/split_debug_info.sh "${file}"
                WORKING_DIRECTORY
                    "${ROOT}/${PACKAGE_NAME}/lib/"
            )
        endif()
    endforeach()
endif()

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/../package.cmake
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}
)

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/../qt.conf
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}/bin
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND} -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        ${ROOT}
)

