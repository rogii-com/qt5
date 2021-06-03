if(CMAKE_CXX_COMPILER_ID STREQUAL "MSVC")
    include(${CMAKE_CURRENT_LIST_DIR}/msvs_package.cmake)
    include(${CMAKE_CURRENT_LIST_DIR}/windowssdk_package.cmake)

    CNPM_ADD_PACKAGE(
        NAME
            OpenSSL
        VERSION
            1.1.1.7
        BUILD_NUMBER
            0
        TAG
            "sdk18362_vsbt19"
    )
elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    CNPM_ADD_PACKAGE(
        NAME
            gxx_runtime
        VERSION
            9.2.1
        BUILD_NUMBER
            0
    )
    CNPM_ADD_PACKAGE(
        NAME
            OpenSSL
        VERSION
            1.1.1.7
        BUILD_NUMBER
            0
    )
endif()
