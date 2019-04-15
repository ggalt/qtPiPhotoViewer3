import QtQuick 2.2
import QtQuick.Dialogs 1.0

FileDialog {
    id: directoryDialog
    title: "Please choose a Directory"
    selectFolder: true


    onAccepted: {
        console.log("You chose: " + fileUrls)
        close()
//        Qt.quit()
    }
    onRejected: {
        console.log("Canceled")
//        close()
        Qt.quit()
    }
//    Component.onCompleted: visible = true
}
