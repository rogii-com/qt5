# Checks the variant archives in ENV{ENV_INSTALL} the way a consumer meets them: makes the qt
# meta package, then for each variant configures a project that pins it, builds it, installs
# the Qt runtime with the package's install rules and runs it.

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

foreach(VARIANT ${VARIANTS})
    message(
        STATUS
        "Testing the ${VARIANT} variant"
    )

    set(
        BINARY_DIR
        "${ROOT}/test-${VARIANT}"
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

    file(
        REMOVE_RECURSE
        "${BINARY_DIR}"
    )

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

    execute_process(
        COMMAND
            ${CMAKE_COMMAND} --build "${BINARY_DIR}/build"
        COMMAND_ERROR_IS_FATAL
            ANY
    )

    foreach(COMPONENT Unspecified CNPM_RUNTIME_Qt6_Core)
        execute_process(
            COMMAND
                ${CMAKE_COMMAND} --install "${BINARY_DIR}/build" --prefix "${BINARY_DIR}/install" --component ${COMPONENT}
            COMMAND_ERROR_IS_FATAL
                ANY
        )
    endforeach()

    execute_process(
        COMMAND
            ${CMAKE_COMMAND} -E env QT_FORCE_STDERR_LOGGING=1 "${BINARY_DIR}/install/qt_package_test${CMAKE_EXECUTABLE_SUFFIX}"
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

    if(VARIANT STREQUAL "asserts")
        if(RUN_RESULT EQUAL 0 OR NOT RUN_OUTPUT MATCHES "ASSERT failure in QCoreApplication")
            message(
                FATAL_ERROR
                "The asserts variant did not fail on the Q_ASSERT inside Qt."
            )
        endif()
    elseif(NOT RUN_RESULT EQUAL 0 OR NOT RUN_OUTPUT MATCHES "no assert fired")
        message(
            FATAL_ERROR
            "The default variant did not run to the end."
        )
    endif()
endforeach()
