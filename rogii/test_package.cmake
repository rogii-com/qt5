# Checks the variant archives in ENV{ENV_INSTALL} the way a consumer meets them: makes the qt
# meta package, then for each variant configures a project that pins it, builds it, installs
# the Qt runtime with the package's install rules and runs it.

cmake_minimum_required(VERSION 3.20)

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
    META_BUILD_NUMBER
    0
)

set(
    ENV{BUILD_NUMBER}
    ${META_BUILD_NUMBER}
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND} -P "${CMAKE_CURRENT_LIST_DIR}/build_meta_package.cmake"
    COMMAND_ERROR_IS_FATAL
        ANY
)

set(
    VARIANTS
    default
)

file(
    GLOB
        ASSERTS_ARCHIVES
    "${ROOT}/qtasserts-*$ENV{TAG}.7z"
)

if(ASSERTS_ARCHIVES)
    list(
        APPEND
            VARIANTS
            asserts
    )
endif()

set(
    GENERATOR_ARGS
    -G Ninja
)

if(WIN32)
    list(
        APPEND
            GENERATOR_ARGS
            -DCMAKE_CXX_COMPILER=cl
    )
endif()

function(run_probe INSTALL_DIR EXPECT_ASSERT)
    execute_process(
        COMMAND
            ${CMAKE_COMMAND} -E env QT_FORCE_STDERR_LOGGING=1 "${INSTALL_DIR}/qt_package_test${CMAKE_EXECUTABLE_SUFFIX}"
        OUTPUT_VARIABLE
            RUN_OUTPUT
        ERROR_VARIABLE
            RUN_OUTPUT
        RESULT_VARIABLE
            RUN_RESULT
    )

    message(
        STATUS
        "exit code ${RUN_RESULT}: ${RUN_OUTPUT}"
    )

    if(EXPECT_ASSERT)
        if(RUN_RESULT EQUAL 0 OR NOT RUN_OUTPUT MATCHES "ASSERT failure in QCoreApplication")
            message(
                FATAL_ERROR
                "The probe in ${INSTALL_DIR} did not fail on the Q_ASSERT inside Qt."
            )
        endif()
    elseif(NOT RUN_RESULT EQUAL 0 OR NOT RUN_OUTPUT MATCHES "no assert fired")
        message(
            FATAL_ERROR
            "The probe in ${INSTALL_DIR} did not run to the end."
        )
    endif()
endfunction()

# The variants are configured one after another in the same build directory, as a consumer
# switching QT_FORCE_ASSERTS does.
set(
    BINARY_DIR
    "${ROOT}/test"
)

file(
    REMOVE_RECURSE
    "${BINARY_DIR}"
)

foreach(VARIANT ${VARIANTS})
    message(
        STATUS
        "Testing the ${VARIANT} variant"
    )

    set(
        FORCE_ASSERTS
        OFF
    )

    if(VARIANT STREQUAL "asserts")
        set(
            FORCE_ASSERTS
            ON
        )
    endif()

    execute_process(
        COMMAND
            ${CMAKE_COMMAND}
            -S "${CMAKE_CURRENT_LIST_DIR}/test"
            -B "${BINARY_DIR}/build"
            ${GENERATOR_ARGS}
            -DCMAKE_BUILD_TYPE=Release
            "-DCNPM_ROOT=${ROOT}"
            -DQT_META_BUILD_NUMBER=${META_BUILD_NUMBER}
            "-DQT_META_TAG=$ENV{TAG}"
            -DQT_FORCE_ASSERTS=${FORCE_ASSERTS}
        OUTPUT_VARIABLE
            CONFIGURE_OUTPUT
        ERROR_VARIABLE
            CONFIGURE_OUTPUT
        RESULT_VARIABLE
            CONFIGURE_RESULT
    )

    if(NOT CONFIGURE_RESULT EQUAL 0)
        message(
            FATAL_ERROR
            "${CONFIGURE_OUTPUT}\nConfiguring the ${VARIANT} test failed."
        )
    endif()

    if(NOT CONFIGURE_OUTPUT MATCHES "Qt package variant: qt${VARIANT}-")
        message(
            FATAL_ERROR
            "${CONFIGURE_OUTPUT}\nThe meta package did not select the ${VARIANT} variant."
        )
    endif()

    file(
        STRINGS
            "${BINARY_DIR}/build/CMakeCache.txt"
            QT_DIR_ENTRIES
        REGEX
            "^Qt6.*_DIR:PATH="
    )

    foreach(QT_DIR_ENTRY ${QT_DIR_ENTRIES})
        if(NOT QT_DIR_ENTRY MATCHES "/qt${VARIANT}-|-NOTFOUND$")
            message(
                FATAL_ERROR
                "The ${VARIANT} test build caches a Qt package directory of another package: ${QT_DIR_ENTRY}"
            )
        endif()
    endforeach()

    execute_process(
        COMMAND
            ${CMAKE_COMMAND} --build "${BINARY_DIR}/build"
        COMMAND_ERROR_IS_FATAL
            ANY
    )

    foreach(COMPONENT Unspecified CNPM_RUNTIME_Qt6_Core)
        execute_process(
            COMMAND
                ${CMAKE_COMMAND} --install "${BINARY_DIR}/build" --prefix "${BINARY_DIR}/install-${VARIANT}" --component ${COMPONENT}
            COMMAND_ERROR_IS_FATAL
                ANY
        )
    endforeach()

    run_probe("${BINARY_DIR}/install-${VARIANT}" ${FORCE_ASSERTS})
endforeach()

if(NOT "asserts" IN_LIST VARIANTS)
    return()
endif()

# A multi-configuration tree gets the asserts variant for every configuration, Debug included.
message(
    STATUS
    "Testing the Debug configuration of the asserts variant in a multi-configuration build"
)

list(
    TRANSFORM
        GENERATOR_ARGS
    REPLACE
        "^Ninja$"
        "Ninja Multi-Config"
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND}
        -S "${CMAKE_CURRENT_LIST_DIR}/test"
        -B "${BINARY_DIR}/multi"
        ${GENERATOR_ARGS}
        "-DCNPM_ROOT=${ROOT}"
        -DQT_META_BUILD_NUMBER=${META_BUILD_NUMBER}
        "-DQT_META_TAG=$ENV{TAG}"
        -DQT_FORCE_ASSERTS=ON
    COMMAND_ERROR_IS_FATAL
        ANY
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND} --build "${BINARY_DIR}/multi" --config Debug
    COMMAND_ERROR_IS_FATAL
        ANY
)

foreach(COMPONENT Unspecified CNPM_RUNTIME_Qt6_Core)
    execute_process(
        COMMAND
            ${CMAKE_COMMAND} --install "${BINARY_DIR}/multi" --config Debug --prefix "${BINARY_DIR}/install-multi-debug" --component ${COMPONENT}
        COMMAND_ERROR_IS_FATAL
            ANY
    )
endforeach()

if(WIN32 AND NOT EXISTS "${BINARY_DIR}/install-multi-debug/Qt6CoreRogiid.dll")
    message(
        FATAL_ERROR
        "The Debug configuration of the asserts variant did not install the Debug Qt library."
    )
endif()

run_probe("${BINARY_DIR}/install-multi-debug" ON)
