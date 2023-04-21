cmake_minimum_required(
    VERSION
    3.12.4
)

project(
    qt
)

include(ProcessorCount)
ProcessorCount(N)
message(STATUS "Processor count is ${N}")

set(
    ROGII_FOLDER_PATH
    "${CMAKE_CURRENT_LIST_DIR}/rogii"
)
include(${ROGII_FOLDER_PATH}/npm/Include.cmake)
include(${ROGII_FOLDER_PATH}/environment.cmake)

CNPM_PREPARE_PACKAGES(
    DEFAULT_REPOSITORY_URLS
    "$ENV{CNPM_URLS}"
)

execute_process(
    COMMAND
        perl
        -v
    RESULT_VARIABLE
        PERL_RESULT
    OUTPUT_VARIABLE
        PERL_ALL_OUTPUT
    ERROR_VARIABLE
        PERL_ALL_OUTPUT
)

message(
    STATUS
    "PERL_RESULT = ${PERL_RESULT}; "
    "PERL_ALL_OUTPUT = ${PERL_ALL_OUTPUT}"
)

if(NOT PERL_RESULT EQUAL 0)
    message(
        FATAL_ERROR
        "Perl is not in the PATH."
    )
endif()


get_target_property(
    PYTHON_BINARY_PATH
    Python::binary
    IMPORTED_LOCATION
)

execute_process(
    COMMAND
        ${PYTHON_BINARY_PATH}
        --version
    RESULT_VARIABLE
        PYTHON_RESULT
    OUTPUT_VARIABLE
        PYTHON_ALL_OUTPUT
    ERROR_VARIABLE
        PYTHON_ALL_OUTPUT
)

message(
    STATUS
    "PYTHON_RESULT = ${PYTHON_RESULT}; "
    "PYTHON_ALL_OUTPUT = ${PYTHON_ALL_OUTPUT}"
)

if((NOT PYTHON_RESULT EQUAL 0) OR (
    (NOT PYTHON_ALL_OUTPUT MATCHES "2\.7") AND 
    (NOT PYTHON_ALL_OUTPUT MATCHES "3\.6") AND 
    (NOT PYTHON_ALL_OUTPUT MATCHES "3\.7")
    ))
    message(
        FATAL_ERROR
        "Python 2.7.x or 3.6.x or 3.7.x is not in the PATH."
    )
endif()

if(MSVC)
    execute_process(
        COMMAND
            jom
            /version
        RESULT_VARIABLE
            JOM_RESULT
        OUTPUT_VARIABLE
            JOM_ALL_OUTPUT
        ERROR_VARIABLE
            JOM_ALL_OUTPUT
    )

    message(
        STATUS
        "JOM_RESULT = ${JOM_RESULT}; "
        "JOM_ALL_OUTPUT = ${JOM_ALL_OUTPUT}"
    )

    if(NOT JOM_RESULT EQUAL 0)
        message(
            FATAL_ERROR
            "Jom is not in the PATH."
        )
    endif()
endif()

# get directory of openssl libs
if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    get_property(
        CRYPTO_LIB_LOCATION
        TARGET
            OpenSSL::crypto
        PROPERTY
            IMPORTED_LOCATION
    )
    get_property(
        OPENSSL_LIB_LOCATION
        TARGET
            OpenSSL::ssl
        PROPERTY
            IMPORTED_LOCATION
    )
elseif(MSVC)
    get_property(
        CRYPTO_LIB_LOCATION
        TARGET
            OpenSSL::crypto
        PROPERTY
            IMPORTED_IMPLIB
    )
    get_property(
        OPENSSL_LIB_LOCATION
        TARGET
            OpenSSL::ssl
        PROPERTY
            IMPORTED_IMPLIB
    )
endif()

get_property(
    OPENSSL_INCLUDE_DIRECTROIES
    TARGET
        OpenSSL::ssl
    PROPERTY
        INTERFACE_INCLUDE_DIRECTORIES
)

get_filename_component(CRYPTO_FILENAME ${CRYPTO_LIB_LOCATION} NAME)
get_filename_component(OPENSSL_LIBDIR ${OPENSSL_LIB_LOCATION} DIRECTORY)
get_filename_component(OPENSSL_FILENAME ${OPENSSL_LIB_LOCATION} NAME)

set(
    QT_SUFFIX
    "Rogii"
)

execute_process(
    COMMAND
        perl
        init-repository
        -f
        --mirror https://github.com/qt/
        --module-subset=qtactiveqt,qtbase,qtdeclarative,qtdoc,qtgraphicaleffects,qtimageformats,qtquickcontrols,qtquickcontrols2,qtsvg,qttools,qttranslations,qtwebsockets,qtwinextras,qtxmlpatterns
    RESULT_VARIABLE
        INIT_REPOSITORY_RESULT
    WORKING_DIRECTORY
        ${PROJECT_SOURCE_DIR}
)

if(NOT INIT_REPOSITORY_RESULT EQUAL 0)
    message(
        FATAL_ERROR
        "Failed to initialize repository."
    )
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    add_custom_command(
        OUTPUT
            ${CMAKE_INSTALL_PREFIX}/bin/qmake
        COMMAND
            ./configure
            -silent
            -prefix ${CMAKE_INSTALL_PREFIX} 
            -translationdir ${CMAKE_INSTALL_PREFIX}/translations
            -platform linux-g++
            -shared
            -force-debug-info
            -opensource
            -confirm-license
            -nomake tests
            -nomake examples
            -no-compile-examples
            -opengl es2
            -skip qt3d
            -skip qtcanvas3d
            -skip qtcharts
            -skip qtconnectivity
            -skip qtdatavis3d
            -skip qtdocgallery
            -skip qtfeedback
            -skip qtgamepad
            -skip qtlocation
            -skip qtmultimedia
            -skip qtnetworkauth
            -skip qtpim
            -skip qtpurchasing
            -skip qtqa
            -skip qtquickcontrols2
            -skip qtremoteobjects
            -skip qtrepotools
            -skip qtscript
            -skip qtscxml
            -skip qtsensors
            -skip qtserialbus
            -skip qtserialport
            -skip qtspeech
            -skip qtsystems
            -skip qtvirtualkeyboard
            -skip qtwayland
            -skip qtwebchannel
            -skip qtwebengine
            -skip qtwebglplugin
            -skip qtwebview
            -no-dbus
            -qtlibinfix ${QT_SUFFIX}
            -no-icu
            -qt-libpng
            -qt-zlib
            -openssl-runtime
            OPENSSL_PREFIX="${OPENSSL_INCLUDE_DIRECTROIES}/../"
            OPENSSL_LIBS="-l:${OPENSSL_FILENAME};-l:${CRYPTO_FILENAME}"
        COMMAND
            make -j${N}
        COMMAND
            make install
        WORKING_DIRECTORY
            ${PROJECT_SOURCE_DIR}
    )
elseif(MSVC)
    add_custom_command(
        OUTPUT
            ${CMAKE_INSTALL_PREFIX}/bin/qmake
        COMMAND
            cmd /C configure
            -silent
            -prefix ${CMAKE_INSTALL_PREFIX}
            -translationdir ${CMAKE_INSTALL_PREFIX}/translations
            -platform win32-msvc
            -shared
            -debug-and-release
            -force-debug-info
            -opensource
            -confirm-license
            -plugin-sql-odbc
            -opengl dynamic
            -nomake tests
            -nomake examples
            -no-compile-examples
            -skip qt3d
            -skip qtcanvas3d
            -skip qtcharts
            -skip qtconnectivity
            -skip qtdatavis3d
            -skip qtdocgallery
            -skip qtfeedback
            -skip qtgamepad
            -skip qtlocation
            -skip qtmultimedia
            -skip qtnetworkauth
            -skip qtpim
            -skip qtpurchasing
            -skip qtqa
            -skip qtquickcontrols2
            -skip qtremoteobjects
            -skip qtrepotools
            -skip qtscript
            -skip qtscxml
            -skip qtsensors
            -skip qtserialbus
            -skip qtserialport
            -skip qtspeech
            -skip qtsystems
            -skip qtvirtualkeyboard
            -skip qtwayland
            -skip qtwebchannel
            -skip qtwebengine
            -skip qtwebglplugin
            -skip qtwebview
            -no-dbus
            -qtlibinfix ${QT_SUFFIX}
            -openssl-runtime
            -I ${OPENSSL_INCLUDE_DIRECTROIES} -L ${OPENSSL_LIBDIR}
        COMMAND
            jom /j${N}
        COMMAND
            nmake install
        WORKING_DIRECTORY
            ${PROJECT_SOURCE_DIR}
    )
endif()

add_custom_target(
    ${PROJECT_NAME}
    ALL
    DEPENDS
       ${CMAKE_INSTALL_PREFIX}/bin/qmake
)
