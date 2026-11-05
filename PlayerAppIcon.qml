import qs.services
import QtQuick
import Quickshell
import Quickshell.Widgets

/** Icon of the app behind a player. */
IconImage {
    property var player
    implicitSize: 16
    source: Quickshell.iconPath(AppSearch.guessIcon(player?.desktopEntry || player?.identity || ""), "audio-x-generic")
}
