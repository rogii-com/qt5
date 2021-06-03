execute_process(
    COMMAND
        "${CMAKE_COMMAND}" -E time "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/rogii/build_amd64.cmake"
)
