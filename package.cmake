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
    5.15.1
)

set(
    COMPONENTS

    Core
    Concurrent
    Designer
    Gui
    Help
    Svg
    Widgets
    Sql
    PrintSupport
    Test
    Network
    OpenGL
    LinguistTools
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
    UiPlugin
    UiTools
    WebSockets
    Xml
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

    QuickControls2
    QuickParticles
    QuickShapes
    QuickTemplates2
    QuickTest
)

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
        TARGETS_TO_INSTALL

        Concurrent
        Svg
        Widgets
        Sql
        PrintSupport
        Qml
        QmlModels
        QmlWorkerScript
        Quick
        Core
        Gui
        Network
        WebSockets
        Gui_EGL
        Gui_GLESv2
        QuickWidgets
    )

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
                DESTINATION
                    .
                COMPONENT
                    ${COMPONENT_NAME}
                EXCLUDE_FROM_ALL
            )
        endforeach()
    endforeach()

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
elseif(UNIX)
    install(
        FILES
            $<TARGET_FILE:Qt5::Core>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Core${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Gui>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Gui${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Network>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Network${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::WebSockets>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5WebSockets${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Concurrent>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Concurrent${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Svg>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Svg${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Quick>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Quick${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Qml>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Qml${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::QmlModels>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5QmlModels${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::QmlWorkerScript>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5QmlWorkerScript${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::Widgets>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5Widgets${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::QuickWidgets>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5QuickWidgets${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
    install(
        FILES
            $<TARGET_FILE:Qt5::PrintSupport>
        DESTINATION
            .
        COMPONENT
            CNPM_RUNTIME
        RENAME
            libQt5PrintSupport${ROGII_SUFFIX}.so.5
        EXCLUDE_FROM_ALL
    )
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
    QT_VERSION
)

unset(
    Qt5_DIR
    CACHE
)

