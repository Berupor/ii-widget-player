import qs.modules.common
import QtQuick
import Quickshell.Io

/** Local file for a player's cover: remote art goes through the shell's cover cache. */
Item {
    id: root
    property var player
    readonly property string url: root.player?.trackArtUrl ?? ""
    readonly property bool remote: root.url.startsWith("http")
    property string fetchedUrl
    readonly property string source: !root.remote ? root.url
        : root.fetchedUrl === root.url ? `file://${Directories.coverArt}/${Qt.md5(root.url)}` : ""

    function fetch() {
        if (!root.remote || (fetcher.running && fetcher.url === root.url))
            return
        fetcher.running = false
        fetcher.url = root.url
        fetcher.running = true
    }
    onUrlChanged: Qt.callLater(root.fetch)
    Component.onCompleted: Qt.callLater(root.fetch)

    Process {
        id: fetcher
        property string url
        readonly property string path: `${Directories.coverArt}/${Qt.md5(fetcher.url)}`
        command: ["bash", "-c", '[ -f "$1" ] || { mkdir -p "${1%/*}" && curl -4 -sSL "$2" -o "$1.$$" && mv "$1.$$" "$1" || { rm -f "$1.$$"; exit 1; }; }', "_", fetcher.path, fetcher.url]
        onExited: exitCode => {
            if (exitCode === 0)
                root.fetchedUrl = fetcher.url
        }
    }
}
