import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick

/** Wavy while playing, flat when paused; seeks where the player allows it. */
StyledSlider {
    id: root
    property var player
    readonly property real length: root.player?.length ?? 0

    configuration: StyledSlider.Configuration.Wavy
    wavy: root.player?.isPlaying ?? false
    enabled: (root.player?.canSeek ?? false) && root.length > 0
    usePercentTooltip: false
    tooltipContent: StringUtils.friendlyTimeForSeconds(root.value * root.length)
    value: root.length > 0 ? (root.player?.position ?? 0) / root.length : 0
    onMoved: root.player.position = root.value * root.length
}
