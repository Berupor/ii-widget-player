import QtQuick

/** The MprisPlayer surface the views read, with made-up values. */
QtObject {
    property string identity
    property string desktopEntry
    property string trackTitle
    property string trackArtist
    property string trackArtUrl
    property bool isPlaying
    property real position
    property real length
    property bool canSeek: true
    property bool canGoNext: true
    property bool canGoPrevious: true
    property bool canTogglePlaying: true

    function togglePlaying() { isPlaying = !isPlaying }
    function next() {}
    function previous() {}
}
