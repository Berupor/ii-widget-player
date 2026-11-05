import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.services
import QtQuick
import QtQuick.Layouts

/** Neutral card: the hero player up top, the rest as rows under it. */
Item {
    id: root
    property var hero: null
    property var rest: []
    readonly property bool playing: root.hero?.isPlaying ?? false
    signal picked(var player)

    implicitWidth: Appearance.sizes.mediaControlsWidth
    implicitHeight: surface.implicitHeight + Appearance.sizes.elevationMargin * 2

    component TimeLabel: StyledText {
        font.pixelSize: Appearance.font.pixelSize.smaller
        font.features: { "tnum": 1 }
        color: Appearance.colors.colSubtext
    }
    component SideButton: GroupButton {
        property string iconName
        baseWidth: 56
        baseHeight: 48
        buttonRadius: Appearance.rounding.full
        colBackground: Appearance.colors.colSecondaryContainer
        colBackgroundHover: Appearance.colors.colSecondaryContainerHover
        colBackgroundActive: Appearance.colors.colSecondaryContainerActive
        contentItem: MaterialSymbol {
            text: parent.iconName
            fill: 1
            iconSize: 24
            horizontalAlignment: Text.AlignHCenter
            color: Appearance.colors.colOnSecondaryContainer
        }
    }

    StyledRectangularShadow {
        target: surface
    }
    Rectangle {
        id: surface
        x: Appearance.sizes.elevationMargin
        y: Appearance.sizes.elevationMargin
        width: root.width - Appearance.sizes.elevationMargin * 2
        implicitHeight: root.hero ? content.implicitHeight + 32 : 200
        radius: Appearance.rounding.large
        color: Appearance.colors.colLayer0
        border.width: 1
        border.color: Appearance.colors.colLayer0Border

        EmptyState {
            visible: !root.hero
            anchors.centerIn: parent
        }

        ColumnLayout {
            id: content
            visible: !!root.hero
            x: 16
            y: 16
            width: parent.width - 32
            spacing: 16

            RowLayout {
                spacing: 16
                PlayerArt {
                    Layout.alignment: Qt.AlignTop
                    player: root.hero
                    size: 112
                    radius: Appearance.rounding.normal
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignTop
                    spacing: 4
                    RowLayout {
                        spacing: 6
                        PlayerAppIcon {
                            player: root.hero
                            implicitSize: 14
                        }
                        StyledText {
                            Layout.fillWidth: true
                            text: root.hero?.identity ?? ""
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: Appearance.colors.colSubtext
                            elide: Text.ElideRight
                        }
                    }
                    StyledText {
                        Layout.fillWidth: true
                        Layout.topMargin: 4
                        text: StringUtils.cleanMusicTitle(root.hero?.trackTitle) || Translation.tr("Untitled")
                        font.family: Appearance.font.family.title
                        font.pixelSize: Appearance.font.pixelSize.huge
                        font.variableAxes: Appearance.font.variableAxes.title
                        color: Appearance.colors.colOnLayer0
                        wrapMode: Text.Wrap
                        maximumLineCount: 2
                        elide: Text.ElideRight
                    }
                    StyledText {
                        Layout.fillWidth: true
                        visible: text.length > 0
                        text: root.hero?.trackArtist ?? ""
                        font.pixelSize: Appearance.font.pixelSize.normal
                        color: Appearance.colors.colSubtext
                        elide: Text.ElideRight
                    }
                }
            }

            ColumnLayout {
                spacing: 0
                TrackProgress {
                    Layout.fillWidth: true
                    player: root.hero
                }
                RowLayout {
                    TimeLabel {
                        text: StringUtils.friendlyTimeForSeconds(root.hero?.position ?? 0)
                    }
                    Item {
                        Layout.fillWidth: true
                    }
                    TimeLabel {
                        text: StringUtils.friendlyTimeForSeconds(root.hero?.length ?? 0)
                    }
                }
            }

            ButtonGroup {
                Layout.alignment: Qt.AlignHCenter
                spacing: 4
                SideButton {
                    iconName: "skip_previous"
                    enabled: root.hero?.canGoPrevious ?? false
                    downAction: () => root.hero.previous()
                }
                GroupButton {
                    baseWidth: 96
                    baseHeight: 48
                    toggled: true
                    enabled: root.hero?.canTogglePlaying ?? false
                    buttonRadius: root.playing ? Appearance.rounding.normal : Appearance.rounding.full
                    downAction: () => root.hero.togglePlaying()
                    contentItem: MaterialSymbol {
                        text: root.playing ? "pause" : "play_arrow"
                        fill: 1
                        iconSize: 28
                        horizontalAlignment: Text.AlignHCenter
                        color: Appearance.colors.colOnPrimary
                    }
                }
                SideButton {
                    iconName: "skip_next"
                    enabled: root.hero?.canGoNext ?? false
                    downAction: () => root.hero.next()
                }
            }

            Rectangle {
                Layout.fillWidth: true
                visible: root.rest.length > 0
                implicitHeight: restList.implicitHeight + 8
                radius: Appearance.rounding.normal
                color: Appearance.colors.colLayer2

                ColumnLayout {
                    id: restList
                    x: 4
                    y: 4
                    width: parent.width - 8
                    spacing: 0
                    Repeater {
                        model: root.rest
                        delegate: RippleButton {
                            id: row
                            required property var modelData
                            Layout.fillWidth: true
                            implicitHeight: 56
                            buttonRadius: Appearance.rounding.small
                            colBackgroundHover: Appearance.colors.colLayer2Hover
                            colRipple: Appearance.colors.colLayer2Active
                            onClicked: root.picked(row.modelData)
                            contentItem: RowLayout {
                                spacing: 12
                                PlayerArt {
                                    Layout.leftMargin: 4
                                    player: row.modelData
                                    size: 40
                                    radius: Appearance.rounding.verysmall
                                }
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 0
                                    StyledText {
                                        Layout.fillWidth: true
                                        text: StringUtils.cleanMusicTitle(row.modelData.trackTitle) || Translation.tr("Untitled")
                                        font.pixelSize: Appearance.font.pixelSize.normal
                                        color: Appearance.colors.colOnLayer2
                                        elide: Text.ElideRight
                                    }
                                    StyledText {
                                        Layout.fillWidth: true
                                        text: [row.modelData.identity, row.modelData.trackArtist].filter(s => s).join(" · ")
                                        font.pixelSize: Appearance.font.pixelSize.smaller
                                        color: Appearance.colors.colSubtext
                                        elide: Text.ElideRight
                                    }
                                }
                                RippleButton {
                                    Layout.rightMargin: 4
                                    implicitWidth: 40
                                    implicitHeight: 40
                                    buttonRadius: Appearance.rounding.full
                                    enabled: row.modelData.canTogglePlaying ?? false
                                    onClicked: row.modelData.togglePlaying()
                                    contentItem: MaterialSymbol {
                                        text: row.modelData.isPlaying ? "pause" : "play_arrow"
                                        fill: 1
                                        iconSize: 22
                                        horizontalAlignment: Text.AlignHCenter
                                        color: Appearance.colors.colOnLayer2
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
