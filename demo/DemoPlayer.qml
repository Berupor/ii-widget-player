//@ probe -g 440x560
/**
 * The view on made-up players, so shots look the same on every machine.
 * `scene`: 0 four players, 1 one paused without art, 2 none. `appIcons` as the widget option.
 */
import ".."
import "stubs"
import "../hero.js" as Hero
import QtQuick

Item {
    id: root
    property int scene: 0
    property bool appIcons: true
    property int picked: -1

    readonly property var players: [
        [dunes, clip, tide, moss],
        [symphony],
        []
    ][root.scene]
    readonly property var hero: Hero.pick(root.players[root.picked] ?? null, null, root.players)

    function checks() {
        const all = [dunes, clip, tide, moss]
        return [
            { "name": "a hand-picked player wins over the playing one", "got": Hero.pick(tide, dunes, all) === tide, "want": true },
            { "name": "the active player leads when nothing is picked", "got": Hero.pick(null, clip, all) === clip, "want": true },
            { "name": "an active player outside the list (playerctld) is skipped", "got": Hero.pick(null, symphony, all) === dunes, "want": true },
            { "name": "a picked player that went away falls back", "got": Hero.pick(symphony, null, all) === dunes, "want": true },
            { "name": "nothing playing leads with the first", "got": Hero.pick(null, null, [tide, moss]) === tide, "want": true },
            { "name": "no players, no hero", "got": Hero.pick(null, null, []), "want": null },
            { "name": "rows skip the hero and keep the player order", "got": Hero.rows([], dunes, all), "want": [clip, tide, moss] },
            { "name": "picking a row hands its slot to the old hero", "got": Hero.swap([clip, tide, moss], tide, dunes), "want": [clip, dunes, moss] },
            { "name": "rows keep the slots order and append newcomers", "got": Hero.rows([moss, clip], tide, all), "want": [moss, clip, dunes] },
            { "name": "four players take more room than the empty card", "got": view.implicitHeight > 300, "want": root.scene === 0 }
        ]
    }

    StubPlayer {
        id: dunes
        identity: "Spotify"
        desktopEntry: "spotify"
        trackTitle: "Dune Sea"
        trackArtist: "Sand Theory"
        trackArtUrl: Qt.resolvedUrl("art/dunes.jpg")
        isPlaying: true
        position: 50
        length: 364
    }
    StubPlayer {
        id: clip
        identity: "Firefox"
        desktopEntry: "firefox"
        trackTitle: "How tides work, explained with a bathtub and a very long title"
        trackArtist: "Science Hour"
        trackArtUrl: Qt.resolvedUrl("art/clip.jpg")
        isPlaying: true
        position: 290
        length: 1717
    }
    StubPlayer {
        id: tide
        identity: "KDE Connect"
        desktopEntry: "org.kde.kdeconnect.app"
        trackTitle: "Low Tide"
        trackArtist: "Harbour Lights"
        trackArtUrl: Qt.resolvedUrl("art/tide.jpg")
        position: 189
        length: 218
    }
    StubPlayer {
        id: moss
        identity: "Vivaldi"
        desktopEntry: "vivaldi-stable"
        trackTitle: "Moss"
        trackArtUrl: Qt.resolvedUrl("art/moss.jpg")
        position: 12
        length: 245
    }
    StubPlayer {
        id: symphony
        identity: "mpv"
        desktopEntry: "mpv"
        trackTitle: "Symphony No. 9 in D minor, Op. 125 \"Choral\": IV. Presto - Allegro assai - Allegro assai vivace"
        trackArtist: "Berliner Philharmoniker, Herbert von Karajan"
        position: 412
        length: 1468
    }

    HeroView {
        id: view
        width: parent.width
        hero: root.hero
        rest: Hero.rows([], root.hero, root.players)
        appIcons: root.appIcons
    }
}
