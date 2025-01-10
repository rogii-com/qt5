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

CNPM_ADD_PACKAGE(
    NAME
        python
    VERSION
        3.12.7
    BUILD_NUMBER
        44
    TAG
        "vsbt22"
)