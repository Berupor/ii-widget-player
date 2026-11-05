import qs.modules.widgets
import qs.services

/** Media popup: one player up front, the rest a click away. */
WidgetManifest {
    widgetId: "player"
    name: Translation.tr("Player")
    description: Translation.tr("Media popup with the active player up front and the others a click away")
    icon: "music_note"
    version: "1.0"
    author: "Berupor"
    minShellVersion: "1.10"
    slots: ({
        "mediaView": "MediaView.qml"
    })
    options: [
        {
            "key": "pager",
            "type": "switch",
            "icon": "view_carousel",
            "label": Translation.tr("One player at a time, tinted by its cover"),
            "default": false
        }
    ]
}
