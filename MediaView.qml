import qs.modules.common
import qs.modules.widgets
import qs.services
import QtQuick
import Quickshell.Services.Mpris
import "hero.js" as Hero

/** Popup body: picks the hero player and hands the views plain lists. */
Item {
    id: root
    property MprisPlayer picked: null
    readonly property var players: MprisController.players
    readonly property MprisPlayer hero: Hero.pick(root.picked, MprisController.activePlayer, root.players)
    readonly property bool pager: WidgetCatalog.option("player", "pager") ?? false

    implicitWidth: Appearance.sizes.mediaControlsWidth
    implicitHeight: view.implicitHeight

    function pick(player) {
        root.picked = player
        MprisController.trackedPlayer = player
    }

    Timer {
        running: root.hero?.isPlaying ?? false
        interval: Config.options.resources.updateInterval
        repeat: true
        onTriggered: root.hero.positionChanged()
    }

    Loader {
        id: view
        width: parent.width
        sourceComponent: root.pager ? pagerView : heroView
    }
    Component {
        id: heroView
        HeroView {
            hero: root.hero
            rest: root.players.filter(p => p !== root.hero)
            onPicked: player => root.pick(player)
        }
    }
    Component {
        id: pagerView
        PagerView {
            hero: root.hero
            players: root.players
            onPicked: player => root.pick(player)
        }
    }
}
