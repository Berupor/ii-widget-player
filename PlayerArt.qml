import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Qt5Compat.GraphicalEffects

/** A player's cover clipped to `radius` or to `mask`, a note glyph without one. */
Rectangle {
    id: root
    property var player
    property real size: 48
    property Item mask: null
    property color colFallback: Appearance.colors.colSecondaryContainer
    property color colOnFallback: Appearance.colors.colOnSecondaryContainer
    readonly property string source: cover.source

    implicitWidth: root.size
    implicitHeight: root.size
    color: root.colFallback

    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: root.mask ?? roundMask
    }
    Rectangle {
        id: roundMask
        visible: false
        width: root.width
        height: root.height
        radius: root.radius
    }

    CoverArt {
        id: cover
        player: root.player
    }
    MaterialSymbol {
        anchors.centerIn: parent
        visible: image.status !== Image.Ready
        text: "music_note"
        iconSize: root.height * 0.45
        fill: 1
        color: root.colOnFallback
    }
    Image {
        id: image
        anchors.fill: parent
        source: cover.source
        fillMode: Image.PreserveAspectCrop
        sourceSize.width: 256
        sourceSize.height: 256
        asynchronous: true
        mipmap: true
    }
}
