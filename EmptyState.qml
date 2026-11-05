import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    spacing: 4
    MaterialShapeWrappedMaterialSymbol {
        Layout.alignment: Qt.AlignHCenter
        Layout.bottomMargin: 8
        shape: MaterialShape.Shape.Cookie7Sided
        text: "music_off"
        iconSize: 28
        padding: 14
    }
    StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Translation.tr("Nothing playing")
        font.pixelSize: Appearance.font.pixelSize.large
        color: Appearance.colors.colOnLayer0
    }
    StyledText {
        Layout.alignment: Qt.AlignHCenter
        text: Translation.tr("Media from any app shows up here")
        font.pixelSize: Appearance.font.pixelSize.small
        color: Appearance.colors.colSubtext
    }
}
