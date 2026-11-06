import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import Qt5Compat.GraphicalEffects

/** Card surface: the tint's layer over the blurred cover, like the shell's player cards. */
Rectangle {
    id: root
    property var player
    property QtObject tint
    property real veil: 0.3

    color: ColorUtils.applyAlpha(root.tint.colLayer0, 1)
    layer.enabled: true
    layer.effect: OpacityMask {
        maskSource: Rectangle {
            width: root.width
            height: root.height
            radius: root.radius
        }
    }

    CoverArt {
        id: cover
        player: root.player
    }
    StyledImage {
        id: blurred
        anchors.fill: parent
        source: cover.source
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        layer.enabled: true
        layer.effect: StyledBlurEffect {
            source: blurred
        }
    }
    Rectangle {
        anchors.fill: parent
        color: ColorUtils.transparentize(root.tint.colLayer0, 0.15)
    }
}
