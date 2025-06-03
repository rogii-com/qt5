if(
    NOT DEFINED ROOT
    OR NOT DEFINED ARCH
)
    message(
        FATAL_ERROR
        "Assert: ROOT = ${ROOT}; ARCH = ${ARCH}"
    )
endif()

# WORKAROUND: initialize only rogii submodules, because initialization of all submodules takes too much times and space

find_package(
    Git
    REQUIRED
)

set(
    ROGII_SUBMODULES_NAME
    rogii
)

execute_process(
    COMMAND
        ${GIT_EXECUTABLE} submodule update --init --recursive ${ROGII_SUBMODULES_NAME}
    RESULT_VARIABLE
        INIT_ROGII_SUBMODULES_RESULT
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)
if(NOT INIT_ROGII_SUBMODULES_RESULT EQUAL 0)
    message(
        FATAL_ERROR
        "Failed to initialize '${ROGII_SUBMODULES_NAME}' submodules."
    )
endif()

# WORKAROUND end

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

include(
    "${CMAKE_CURRENT_LIST_DIR}/version.cmake"
)

set(
    PACKAGE_NAME
    "qt-${ROGII_PKG_VERSION}-${ARCH}-${BUILD}${TAG}"
)

set(
    INIT_REPO_CMD
    "-f \
        --mirror https://github.com/qt/ \
        --no-resolve-deps \
        --no-optional-deps \
        -submodules qtdoc,qtactiveqt,qt5compat,qtbase,qtdeclarative,qtimageformats,qtshadertools,qtsvg,qttranslations,qtwebsockets,qttools,qtscxml "
)

if(UNIX)
    execute_process(
    COMMAND
        bash -c "./init-repository ${INIT_REPO_CMD}"
    RESULT_VARIABLE
        INIT_REPOSITORY_RESULT
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)
else()
    execute_process(
    COMMAND
        cmd /c "init-repository ${INIT_REPO_CMD}"
    RESULT_VARIABLE
        INIT_REPOSITORY_RESULT
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)
endif()

if(NOT INIT_REPOSITORY_RESULT EQUAL 0)
    message(
        FATAL_ERROR
        "Failed to initialize repository."
    )
endif()

set(
    QT_SUFFIX
    "Rogii"
)

set(
    CONFIGURE_CMD_ARGS
    "-shared \
-c++std c++20 \
-debug-and-release \
-force-debug-info \
-separate-debug-info \
-prefix ${ROOT}/${PACKAGE_NAME} \
-qtlibinfix ${QT_SUFFIX} \
-qt-zlib \
-nomake examples \
-nomake tests \
-nomake benchmarks \
-skip qt3d \
-skip qtcanvas3d \
-skip qtcharts \
-skip qtcoap \
-skip qtconnectivity \
-skip qtdatavis3d \
-skip qtfeedback \
-skip qtgamepad \
-skip qtgraphs \
-skip qtgrpc \
-skip qthttpserver \
-skip qtlanguageserver \
-skip qtlocation \
-skip qtlottie \
-skip qtmqtt \
-skip qtmultimedia \
-skip qtnetworkauth \
-skip qtopcua \
-skip qtpim \
-skip qtpositioning \
-skip qtqa \
-skip qtquick3d \
-skip qtquick3dphysics \
-skip qtquickeffectmaker \
-skip qtquicktimeline \
-skip qtremoteobjects \
-skip qtrepotools \
-skip qtsensors \
-skip qtserialbus \
-skip qtserialport \
-skip qtspeech \
-skip qtsystems \
-skip qtvirtualkeyboard \
-skip qtwayland \
-skip qtwebchannel \
-skip qtwebengine \
-skip qtwebglplugin \
-skip qtwebview \
-no-icu \
-no-dbus \
"
)

if(UNIX)
    execute_process(
    COMMAND
        bash -c "./configure \
        ${CONFIGURE_CMD_ARGS} \
        -platform linux-g++"
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)
else()
    execute_process(
    COMMAND
        cmd /c "configure.bat \
        ${CONFIGURE_CMD_ARGS} \
        -platform win32-msvc \
        -sql-odbc"
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)
endif()

execute_process(
    COMMAND
        "${CMAKE_COMMAND}" --build . --parallel
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
)

# Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/21475
execute_process(
    COMMAND
        ninja install
    WORKING_DIRECTORY
        "${CMAKE_CURRENT_LIST_DIR}/.."
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
        ${CMAKE_CURRENT_LIST_DIR}/package.cmake
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}
)

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/../config.summary
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}
)

file(
    COPY
        ${CMAKE_CURRENT_LIST_DIR}/qt.conf
    DESTINATION
        ${ROOT}/${PACKAGE_NAME}/bin
)

execute_process(
    COMMAND
        ${CMAKE_COMMAND} -E tar cf "${PACKAGE_NAME}.7z" --format=7zip -- "${PACKAGE_NAME}"
    WORKING_DIRECTORY
        ${ROOT}
)

