import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtWebKit 3.0

ApplicationWindow {
    id: mainWindow
    width: 800
    height: 600
    title: qsTr("Qt + QML + PySide2 + Webkit")
    visible: true
    locale: locale

    RowLayout {
        spacing: 0
        anchors.fill: parent

        Rectangle {
            color: '#FFCCCC'
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width / 2
            TextEdit {
                id: _editor
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pixelSize: Math.max(16, this.width / 40)
                focus: true
                textFormat: TextEdit.PlainText
//                textFormat: TextEdit.AutoText
//                textFormat: TextEdit.RichText
//                textFormat: MarkdownText
                wrapMode: TextEdit.Wrap
                text: '# 見出し\n\n* 箇条書き\n* 箇条書き\n\n[google][]\n\n[google]:https://www.google.co.jp/\n\n列1|列2\n-|-\n値1|値2\n値3|値4\n\n'
                onTextChanged: {
//                    console.log("Text has changed to:", text)
                    _webView.loadHtml(Connect.parse(text))
                }
            }
        }

        WebView {
            id: _webView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Component.onCompleted: _webView.loadHtml(Connect.parse(_editor.text))
            onLoadingChanged: {
                if (loadRequest.status == WebView.LoadStartedStatus) {
                    console.log("Load start: " + loadRequest.url)
                } else if (loadRequest.status == WebView.LoadSucceededStatus) {
                    console.log("Load succeeded: " + loadRequest.url)
                } else if (loadRequest.status == WebView.LoadFailedStatus) {
                    console.log("Load failed: " + loadRequest.url + ". Error code: " + loadRequest.errorString)   
                }
            }
            Keys.onPressed: {
                if ((event.key == Qt.Key_Backspace) && (event.modifiers & Qt.ShiftModifier)) {
                    console.debug("Key=" + event.key + ",text=[Shift+BkSp],accepted=" + event.accepted);
                    if (_webView.canGoFoword) { _webView.goFoword(); }
                } else if (event.key == Qt.Key_Backspace) {
                    console.debug("Key=" + event.key + ",text=[BkSp],accepted=" + event.accepted);
                    if (_webView.canGoBack) { _webView.goBack(); }
                } else {
                    console.debug("Key=" + event.key + ",text=" + event.text + ",accepted=" + event.accepted);
                }
            }
        }
    }
}
