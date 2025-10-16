from conan import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain, CMakeDeps, cmake_layout
from conan.tools.files import collect_libs
from conan.tools.env import VirtualBuildEnv
import os


class QtRogiiConan(ConanFile):
    name = "qt"
    version = "6.8.3"
    
    settings = "os", "compiler", "build_type", "arch"
    package_type = "shared-library"
    no_copy_source = True

    def layout(self):
        cmake_layout(self)

    def generate(self):
        # https://github.com/qt/qtbase/blob/dev/cmake/configure-cmake-mapping.md
        qt_config = [
            "BUILD_SHARED_LIBS=ON",
            "QT_BUILD_BENCHMARKS=OFF",
            "QT_BUILD_EXAMPLES=OFF",
            "QT_BUILD_TESTS=OFF",
            "FEATURE_system_zlib=OFF",
            "QT_LIBINFIX=Rogii",
            "BUILD_qt3d=OFF",
            "BUILD_qtcanvas3d=OFF",
            "BUILD_qtcharts=OFF",
            "BUILD_qtcoap=OFF",
            "BUILD_qtconnectivity=OFF",
            "BUILD_qtdatavis3d=OFF",
            "BUILD_qtfeedback=OFF",
            "BUILD_qtgamepad=OFF",
            "BUILD_qtgraphs=OFF",
            "BUILD_qtgrpc=OFF",
            "BUILD_qthttpserver=OFF",
            "BUILD_qtlanguageserver=OFF",
            "BUILD_qtlocation=OFF",
            "BUILD_qtlottie=OFF",
            "BUILD_qtmqtt=OFF",
            "BUILD_qtmultimedia=OFF",
            "BUILD_qtnetworkauth=OFF",
            "BUILD_qtopcua=OFF",
            "BUILD_qtpim=OFF",
            "BUILD_qtpositioning=OFF",
            "BUILD_qtqa=OFF",
            "BUILD_qtquick3d=OFF",
            "BUILD_qtquick3dphysics=OFF",
            "BUILD_qtquickeffectmaker=OFF",
            "BUILD_qtquicktimeline=OFF",
            "BUILD_qtremoteobjects=OFF",
            "BUILD_qtrepotools=OFF",
            "BUILD_qtsensors=OFF",
            "BUILD_qtserialbus=OFF",
            "BUILD_qtserialport=OFF",
            "BUILD_qtspeech=OFF",
            "BUILD_qtsystems=OFF",
            "BUILD_qtvirtualkeyboard=OFF",
            "BUILD_qtwayland=OFF",
            "BUILD_qtwebchannel=OFF",
            "BUILD_qtwebengine=OFF",
            "BUILD_qtwebglplugin=OFF",
            "BUILD_qtwebview=OFF",
            "BUILD_icu=OFF",
            "BUILD_dbus=OFF",
        ]

        if self.settings.os == "Windows":
            qt_config.append("QT_QMAKE_TARGET_MKSPEC=win32-msvc")
            qt_config.append("FEATURE_sql_odbc=ON")
        else:
            qt_config.append("QT_QMAKE_TARGET_MKSPEC=linux-g++")

        tc = CMakeToolchain(self)

        for kv in qt_config:
            key, value = kv.split("=", 1)
            tc.variables[key] = value

        if self.settings.os == "Windows":
            tc.variables["CMAKE_OBJECT_PATH_MAX"] = 1024

        tc.absolute_paths = True

        tc.generate()

    def build(self):
        init_repo_args = (
            "-f "
            "--mirror https://github.com/qt/ "
            "--no-resolve-deps "
            "--no-optional-deps "
            "--module-subset qtbase,qtdoc,qtactiveqt,qt5compat,qtdeclarative,"
            "qtimageformats,qtshadertools,qtsvg,qttranslations,qtwebsockets,qttools,qtscxml"
        )

        if self.settings.os == "Windows":
            self.init_cmd = os.path.join(self.source_folder, f'init-repository.bat {init_repo_args}')
        else:
            self.init_cmd = os.path.join(self.source_folder, f'./init-repository {init_repo_args}')

        self.run(self.init_cmd, cwd=self.source_folder, env="conanbuild")

        cmake = CMake(self)
        cmake.configure()
        cmake.build()

    def package(self):
        cmake = CMake(self)
        cmake.install()

    def package_info(self):
        self.cpp_info.set_property("cmake_file_name", "Qt6")
        self.cpp_info.bindirs = ["bin"]
        self.cpp_info.libdirs = ["lib"]
        self.cpp_info.includedirs = ["include"]
        self.cpp_info.set_property("cmake_find_mode", "none")
        self.buildenv_info.define("Qt6_DIR", os.path.join(self.package_folder, "lib", "cmake", "Qt6"))
