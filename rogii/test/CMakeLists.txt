cmake_minimum_required(VERSION 3.21)

project(qt_package_test CXX)

set(CMAKE_CXX_STANDARD 20)

include(${CMAKE_CURRENT_LIST_DIR}/../cnpm/Include.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/../version.cmake)

CNPM_ADD_PACKAGE(
    NAME
        Qt
    VERSION
        ${ROGII_PKG_VERSION}
    BUILD_NUMBER
        ${QT_META_BUILD_NUMBER}
    TAG
        "${QT_META_TAG}"
)

CNPM_PREPARE_PACKAGES(DEFAULT_REPOSITORY_URLS "")

add_executable(qt_package_test main.cpp)

target_link_libraries(qt_package_test PRIVATE Qt6::Core Qt6::TaskTree)

set_target_properties(qt_package_test PROPERTIES INSTALL_RPATH "$ORIGIN")

install(TARGETS qt_package_test DESTINATION .)
