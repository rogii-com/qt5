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
    5.15.9
)

set(
    COMPONENTS_TO_INSTALL

    Concurrent
    Core
    Gui
    Help
    Network
    PrintSupport
    Qml
    QmlModels
    QmlWorkerScript
    Quick
    QuickControls2
    QuickParticles
    QuickShapes
    QuickTemplates2
    QuickTest
    QuickWidgets
    Sql
    Svg
    Test
    WebSockets
    Widgets
    Xml
    XmlPatterns
)

set(
    COMPONENTS

    ${COMPONENTS_TO_INSTALL}
    Designer
    LinguistTools
    OpenGL
    QuickCompiler
    UiPlugin
    UiTools
)

find_package(
    Qt5
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

if(WIN32)
    set(
        TARGETS_TO_INSTALL

        ${TARGETS_TO_INSTALL}
        Gui_EGL
        Gui_GLESv2
    )
endif()

foreach(COMPONENT ${TARGETS_TO_INSTALL})
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt5_${COMPONENT}
        CNPM_RUNTIME_Qt5
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt5::${COMPONENT}>
                $<$<PLATFORM_ID:Linux>:$<TARGET_SONAME_FILE:Qt5::${COMPONENT}>>
            DESTINATION
                .
            COMPONENT
                ${COMPONENT_NAME}
            EXCLUDE_FROM_ALL
        )
    endforeach()
endforeach()

if(WIN32)
    # TODO: remove copypaste
    set(
        COMPONENT_NAMES

        CNPM_RUNTIME_Qt5_qml
        CNPM_RUNTIME_Qt5
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        # pattern to exclude debug dlls may fail, I mean it
        install(
            DIRECTORY
                $<TARGET_FILE_DIR:Qt5::Core>/../qml
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
                $<TARGET_FILE_DIR:Qt5::Core>/../qml
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
    # TODO: remove copypaste
    set(
        TARGETS_TO_INSTALL

        QOffscreenIntegrationPlugin
        QMinimalIntegrationPlugin
        QWindowsIntegrationPlugin
        QWindowsDirect2DIntegrationPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_plugins_platforms_${plugin}
            CNPM_RUNTIME_Qt5_plugins_platforms
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
                DESTINATION
                    "./platforms"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

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

            CNPM_RUNTIME_Qt5_plugins_imageformats_${plugin}
            CNPM_RUNTIME_Qt5_plugins_imageformats
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
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

        CNPM_RUNTIME_Qt5_plugins_iconengines_QSvgIconPlugin
        CNPM_RUNTIME_Qt5_plugins_iconengines
        CNPM_RUNTIME_Qt5_plugins
        CNPM_RUNTIME_Qt5
        CNPM_RUNTIME
    )

    foreach(COMPONENT_NAME ${COMPONENT_NAMES})
        install(
            FILES
                $<TARGET_FILE:Qt5::QSvgIconPlugin>
            DESTINATION
                "./iconengines"
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

            CNPM_RUNTIME_Qt5_plugins_sqldrivers_${plugin}
            CNPM_RUNTIME_Qt5_plugins_sqldrivers
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
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

        QWindowsVistaStylePlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
            COMPONENT_NAMES

            CNPM_RUNTIME_Qt5_plugins_styles_${plugin}
            CNPM_RUNTIME_Qt5_plugins_styles
            CNPM_RUNTIME_Qt5_plugins
            CNPM_RUNTIME_Qt5
            CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                FILES
                    $<TARGET_FILE:Qt5::${plugin}>
                DESTINATION
                    "./styles"
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()
endif()

if(LINUX)
    set(
            TARGETS_TO_INSTALL

            QOffscreenIntegrationPlugin
    )

    foreach(plugin ${TARGETS_TO_INSTALL})
        set(
                COMPONENT_NAMES

                CNPM_RUNTIME_Qt5_plugins_platforms_${plugin}
                CNPM_RUNTIME_Qt5_plugins_platforms
                CNPM_RUNTIME_Qt5_plugins
                CNPM_RUNTIME_Qt5
                CNPM_RUNTIME
        )

        foreach(COMPONENT_NAME ${COMPONENT_NAMES})
            install(
                    FILES
                    $<TARGET_FILE:Qt5::${plugin}>
                    DESTINATION
                    "./platforms"
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
        Qt5${COMPONENT}_DIR
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
    Qt5_DIR
    CACHE
)

