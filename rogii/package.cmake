set(
    MODULE_PATH_BACKUP33333399999
    "${CMAKE_MODULE_PATH}"
)

set(
    CMAKE_MODULE_PATH
    ""
)

set(
    ROGII_SUFFIX
    "Rogii"
)

set(
    PREFIX_PATH_BACKUP33333399999
    "${CMAKE_PREFIX_PATH}"
)

set(
    CMAKE_PREFIX_PATH
    "${CMAKE_CURRENT_LIST_DIR}"
)

set(
    QT_VERSION
    6.8.1
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
    QuickEffectsPrivate
    QuickLayouts
    QuickParticlesPrivate
    Quick
    QuickShapesPrivate
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
    CMAKE_MODULE_PATH
    "${MODULE_PATH_BACKUP33333399999}"
)

unset(
    MODULE_PATH_BACKUP33333399999
)

set(
    CMAKE_PREFIX_PATH
    "${PREFIX_PATH_BACKUP33333399999}"
)

unset(
    PREFIX_PATH_BACKUP33333399999
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
                $<TARGET_FILE_DIR:Qt6::Core>/../qml
            DESTINATION
                .
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
                $<TARGET_FILE_DIR:Qt6::Core>/../qml
            DESTINATION
                .
            CONFIGURATIONS
                Debug
            EXCLUDE_FROM_ALL
            COMPONENT
                ${COMPONENT_NAME}
            PATTERN
                "*.qmlc"
                EXCLUDE
            PATTERN
                "*.pdb"
                EXCLUDE
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
        TARGETS_TO_INSTALL

        QNLMNIPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt6_plugins_networkinformation_${plugin}
            CNPM_RUNTIME_Qt6_plugins_networkinformation
            CNPM_RUNTIME_Qt6_plugins
            CNPM_RUNTIME_Qt6
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt6::${plugin}>
                DESTINATION
                    "./networkinformation"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
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
elseif(LINUX)
    set(
        TARGETS_TO_INSTALL

        QNetworkManagerNetworkInformationPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt6_plugins_networkinformation_${plugin}
            CNPM_RUNTIME_Qt6_plugins_networkinformation
            CNPM_RUNTIME_Qt6_plugins
            CNPM_RUNTIME_Qt6
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt6::${plugin}>
                DESTINATION
                    "./networkinformation"
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
