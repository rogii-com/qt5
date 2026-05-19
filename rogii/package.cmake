set(
    ROGII_SUFFIX
    "Rogii"
)

set(
    CMAKE_PREFIX_PATH
    "${CMAKE_CURRENT_LIST_DIR}"
)

set(
    QT_VERSION
    6.11.1
)

set(
    COMPONENTS_TO_INSTALL

    Concurrent
    Core5Compat
    Core
    Gui
    Help
    Network
    OpenGL
    OpenGLWidgets
    PrintSupport
    QmlCore
    QmlLocalStorage
    QmlMeta
    QmlModels
    QmlNetwork
    Qml
    QmlWorkerScript
    QmlXmlListModel
    QuickControls2Basic
    QuickControls2BasicStyleImpl
    QuickControls2FluentWinUI3StyleImpl
    QuickControls2Fusion
    QuickControls2FusionStyleImpl
    QuickControls2Imagine
    QuickControls2ImagineStyleImpl
    QuickControls2Impl
    QuickControls2Material
    QuickControls2MaterialStyleImpl
    QuickControls2
    QuickControls2Universal
    QuickControls2UniversalStyleImpl
    QuickDialogs2QuickImpl
    QuickDialogs2
    QuickDialogs2Utils
    QuickEffects
    QuickLayouts
    QuickParticlesPrivate
    Quick
    QuickShapes
    QuickTemplates2
    QuickTest
    QuickVectorImageGeneratorPrivate
    QuickVectorImage
    QuickWidgets
    Sql
    Svg
    SvgWidgets
    Test
    WebSockets
    Widgets
    Xml
    StateMachine
    ShaderTools
)

if(WIN32)
list(APPEND COMPONENTS_TO_INSTALL QuickControls2WindowsStyleImpl)
endif()

set(
    COMPONENTS

    ${COMPONENTS_TO_INSTALL}
    Designer
    LinguistTools
    QmlCompiler
    UiPlugin
    UiTools
    WidgetsPrivate
)

find_package(
    Qt6
        ${QT_VERSION}
        EXACT
    REQUIRED
        ${COMPONENTS}
    CONFIG
)

set(
    TARGETS_TO_INSTALL
    ${COMPONENTS_TO_INSTALL}
)

foreach(COMPONENT ${TARGETS_TO_INSTALL})
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_${COMPONENT}
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt6::${COMPONENT}>
                $<$<PLATFORM_ID:Linux>:$<TARGET_SONAME_FILE:Qt6::${COMPONENT}>>
            DESTINATION
                .
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()
endforeach()

if(WIN32)
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_qml
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        # pattern to exclude debug dlls may fail, I mean it
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Qt6::Core>/../qml/
            DESTINATION
                "qml/${QT_VERSION}"
            CONFIGURATIONS
                MinSizeRel
                RelWithDebInfo
                Release
            EXCLUDE_FROM_ALL
            COMPONENT
                ${COMPONENT_NAME}
            PATTERN
                "*d.dll"
                EXCLUDE
            PATTERN
                "*.qml"
                EXCLUDE
            PATTERN
                "*.qmlc"
                EXCLUDE
            PATTERN
                "*.pdb"
                EXCLUDE
        )

        # it install also release dlls 'cause
        # it's not so trivial to exclude them just by analizing its name
        # at the moment )
        # In any case debug build mustn't be deployed so the approach
        # is good enough
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Qt6::Core>/../qml/
            DESTINATION
                "qml/${QT_VERSION}"
            CONFIGURATIONS
                Debug
            EXCLUDE_FROM_ALL
            COMPONENT
                ${COMPONENT_NAME}
            PATTERN
                "*.qml"
                EXCLUDE
            PATTERN
                "*.qmlc"
                EXCLUDE
            PATTERN
                "*.pdb"
                EXCLUDE
        )

        install(
            FILES
                "$<TARGET_FILE_DIR:Qt6::Core>/qt-install.conf"
            DESTINATION
                .
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
            RENAME
                 qt.conf
        )
    endforeach()
endif()


if(WIN32)
    set(
        TARGETS_TO_INSTALL

        QOffscreenIntegrationPlugin
        QMinimalIntegrationPlugin
        QWindowsIntegrationPlugin
        QWindowsDirect2DIntegrationPlugin
    )
elseif(LINUX)
    set(
        TARGETS_TO_INSTALL

        QOffscreenIntegrationPlugin
    )
endif()

foreach(plugin ${TARGETS_TO_INSTALL})
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_plugins_platforms_${plugin}
        CNPM_RUNTIME_Qt6_plugins_platforms
        CNPM_RUNTIME_Qt6_plugins
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt6::${plugin}>
            DESTINATION
                "./platforms"
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()
endforeach()

if(WIN32)
    set(
        IMAGEFORMATS_TO_INSTALL

        QWbmpPlugin
        QJpegPlugin
        QICOPlugin
        QTiffPlugin
        QSvgPlugin
        QGifPlugin
    )

    foreach(plugin ${IMAGEFORMATS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt6_plugins_imageformats_${plugin}
            CNPM_RUNTIME_Qt6_plugins_imageformats
            CNPM_RUNTIME_Qt6_plugins
            CNPM_RUNTIME_Qt6
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt6::${plugin}>
                DESTINATION
                    "./imageformats"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_plugins_iconengines_QSvgIconPlugin
        CNPM_RUNTIME_Qt6_plugins_iconengines
        CNPM_RUNTIME_Qt6_plugins
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt6::QSvgIconPlugin>
            DESTINATION
                "./iconengines"
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()

    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_plugins_networkinformation_QNLMNIPlugin
        CNPM_RUNTIME_Qt6_plugins_networkinformation
        CNPM_RUNTIME_Qt6_plugins
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt6::QNLMNIPlugin>
            DESTINATION
                "./networkinformation"
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()

    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt6_plugins_networkinformation_QSchannelBackendPlugin
        CNPM_RUNTIME_Qt6_plugins_networkinformation
        CNPM_RUNTIME_Qt6_plugins
        CNPM_RUNTIME_Qt6
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt6::QSchannelBackendPlugin>
            DESTINATION
                "./tls"
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()

    set(
        TARGETS_TO_INSTALL

        QODBCDriverPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt6_plugins_sqldrivers_${plugin}
            CNPM_RUNTIME_Qt6_plugins_sqldrivers
            CNPM_RUNTIME_Qt6_plugins
            CNPM_RUNTIME_Qt6
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt6::${plugin}>
                DESTINATION
                    "./sqldrivers"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

    set(
        TARGETS_TO_INSTALL

        QModernWindowsStylePlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt6_plugins_styles_${plugin}
            CNPM_RUNTIME_Qt6_plugins_styles
            CNPM_RUNTIME_Qt6_plugins
            CNPM_RUNTIME_Qt6
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt6::${plugin}>
                DESTINATION
                    "./styles"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()
endif()

unset(
    TARGETS_TO_INSTALL
)

unset(
    COMPONENT_NAMES
)

foreach(COMPONENT ${COMPONENTS})
    unset(
        Qt6${COMPONENT}_DIR
        CACHE
    )
endforeach()

unset(
    COMPONENTS
)

unset(
    COMPONENTS_TO_INSTALL
)

unset(
    QT_VERSION
)

unset(
    Qt6_DIR
    CACHE
)
