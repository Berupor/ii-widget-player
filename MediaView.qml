import qs.modules.common
import qs.services
import QtQuick
import Quickshell.Services.Mpris
import "hero.js" as Hero

/** Popup body: picks the hero player and hands the view plain lists. */
Item {
    id: root
    property MprisPlayer picked: null
    property var slots: []
    readonly property var players: MprisController.players
    readonly property MprisPlayer hero: Hero.pick(root.picked, MprisController.activePlayer, root.players)
    readonly property var rest: Hero.rows(root.slots, root.hero, root.players)

    implicitWidth: Appearance.sizes.mediaControlsWidth
    implicitHeight: view.implicitHeight
    focus: true

    onHeroChanged: if (root.hero && !root.picked) root.picked = root.hero
    Component.onCompleted: if (root.hero) root.picked = root.hero

    function pick(player) {
        root.slots = Hero.swap(root.rest, player, root.hero)
        root.picked = player
        MprisController.trackedPlayer = player
    }

    Keys.onSpacePressed: if (root.hero?.canTogglePlaying) root.hero.togglePlaying()
    Keys.onLeftPressed: if (root.hero?.canGoPrevious) root.hero.previous()
    Keys.onRightPressed: if (root.hero?.canGoNext) root.hero.next()

    Timer {
        running: root.hero?.isPlaying ?? false
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: root.hero.positionChanged()
    }

    HeroView {
        id: view
        width: parent.width
        hero: root.hero
        rest: root.rest
        onPicked: player => root.pick(player)
    }
}
