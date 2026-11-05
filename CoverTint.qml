import qs.modules.common
import qs.modules.common.models
import qs.modules.common.functions
import QtQuick
import Quickshell
import "hero.js" as Hero

/** Color scheme off a player's cover, mixed the way the shell's own player cards do it. */
Item {
    id: root
    property var player
    property color artColor: Hero.tintOf(root.player?.trackArtUrl, Appearance.m3colors.m3secondaryContainer)
    property bool tinted: Hero.hasTint(root.player?.trackArtUrl)
    readonly property QtObject scheme: root.tinted ? artTint : Appearance.colors

    Behavior on artColor {
        animation: Appearance.animation.elementMoveFast.colorAnimation.createObject(this)
    }

    CoverArt {
        id: cover
        player: root.player
    }
    ColorQuantizer {
        id: quantizer
        source: cover.source
        depth: 0
        rescaleSize: 1
    }
    Connections {
        target: quantizer
        function onColorsChanged() {
            if (cover.source && quantizer.colors.length > 0) {
                const mixed = ColorUtils.mix(quantizer.colors[0], Appearance.colors.colPrimaryContainer, 0.8)
                root.artColor = mixed
                root.tinted = true
                Hero.rememberTint(cover.url, mixed.toString())
            }
        }
    }
    Connections {
        target: cover
        function onUrlChanged() {
            if (!cover.url)
                root.tinted = false
        }
    }
    AdaptedMaterialScheme {
        id: artTint
        color: root.artColor
    }
}
