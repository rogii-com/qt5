include(${CMAKE_CURRENT_LIST_DIR}/msvs_package.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/windowssdk_package.cmake)

CNPM_ADD_PACKAGE(
    NAME
        OpenSSL
    VERSION
        1.1.1.22
    BUILD_NUMBER
        7
    TAG
        "sdk20348_vsbt22"
)

CNPM_ADD_PACKAGE(
    NAME
        python
    VERSION
        3.7.13
    BUILD_NUMBER
        23
    TAG
        "sdk18362_vsbt19_fix"
)
