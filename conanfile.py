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
            "QT_BUILD_BENCHMARKS=OFF",
            "QT_BUILD_EXAMPLES=OFF",
            "BUILD_SHARED_LIBS=ON",
            "QT_BUILD_TESTS=OFF",
            "FEATURE_dbus=OFF",
            "FEATURE_icu=OFF",
            "FEATURE_qt3d=OFF",
            "FEATURE_qtcanvas3d=OFF",
            "FEATURE_qtcharts=OFF",
            "FEATURE_qtcoap=OFF",
            "FEATURE_qtconnectivity=OFF",
            "FEATURE_qtdatavis3d=OFF",
            "FEATURE_qtfeedback=OFF",
            "FEATURE_qtgamepad=OFF",
            "FEATURE_qtgraphs=OFF",
            "FEATURE_qtgrpc=OFF",
            "FEATURE_qthttpserver=OFF",
            "FEATURE_qtlanguageserver=OFF",
            "FEATURE_qtlocation=OFF",
            "FEATURE_qtlottie=OFF",
            "FEATURE_qtmqtt=OFF",
            "FEATURE_qtmultimedia=OFF",
            "FEATURE_qtnetworkauth=OFF",
            "FEATURE_qtopcua=OFF",
            "FEATURE_qtpim=OFF",
            "FEATURE_qtpositioning=OFF",
            "FEATURE_qtqa=OFF",
            "FEATURE_qtquick3d=OFF",
            "FEATURE_qtquick3dphysics=OFF",
            "FEATURE_qtquickeffectmaker=OFF",
            "FEATURE_qtquicktimeline=OFF",
            "FEATURE_qtremoteobjects=OFF",
            "FEATURE_qtrepotools=OFF",
            "FEATURE_qtsensors=OFF",
            "FEATURE_qtserialbus=OFF",
            "FEATURE_qtserialport=OFF",
            "FEATURE_qtspeech=OFF",
            "FEATURE_qtsystems=OFF",
            "FEATURE_qtvirtualkeyboard=OFF",
            "FEATURE_qtwayland=OFF",
            "FEATURE_qtwebchannel=OFF",
            "FEATURE_qtwebengine=OFF",
            "FEATURE_qtwebglplugin=OFF",
            "FEATURE_qtwebview=OFF",
            "FEATURE_zlib=qt",
            "QT_LIBINFIX=Rogii"
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
