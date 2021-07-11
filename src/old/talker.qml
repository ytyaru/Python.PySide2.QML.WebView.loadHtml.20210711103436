import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtWebKit 3.0

ApplicationWindow {
    id: mainWindow
    width: 600
    height: 200
    title: qsTr("Qt + QML + PySide2 + Webkit")
    visible: true
    locale: locale

    ColumnLayout {
        spacing: 0
        anchors.fill: parent
        Rectangle {
            color: "#DDCCFF"
            Layout.fillWidth: true
            Layout.preferredHeight: 40
            TextInput {
                id: _url
                text: "https://www.google.co.jp/"
//                text: "https://news.yahoo.co.jp/rss/topics/top-picks.xml"
                focus: true
                KeyNavigation.tab: _webView
                font.pixelSize: Math.max(16, parent.width / 80)
                anchors.fill: parent
                onAccepted: {
//                    _webView.loadHtml(Connect.make_html(_rssUrl.text))
//                    Connect.talk_news(_rssUrl.text)
                    _webView.url = _url.text
                }
            }
        }
        WebView {
            id: _webView
            Layout.fillWidth: true
            Layout.fillHeight: true
//            url: "https://www.google.co.jp/"
            onLoadingChanged: {
                if (loadRequest.status == WebView.LoadStartedStatus) {
                    console.log("Load start: " + loadRequest.url)
                } else if (loadRequest.status == WebView.LoadSucceededStatus) {
                    console.log("Load succeeded: " + loadRequest.url)
//                    Connect.talk_news(_rssUrl.text)
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
                /*
                    Qt.NoModifier-修飾キーが押されていません。
                    Qt.ShiftModifier-キーボードのShiftキーが押されました。
                    Qt.ControlModifier-キーボードのCtrlキーが押されました。
                    Qt.AltModifier-キーボードのAltキーが押されました。
                    Qt.MetaModifier-キーボードのメタキーが押されました。
                    Qt.KeypadModifier-キーパッドボタンが押されました。
                    Qt.GroupSwitchModifier -X11のみ。キーボードのMode_switchキーが押されました。
                */
                /*
                switch(event.key){
                case Qt.Key_Home:
                    _webView.goBack()
                    console.debug("Key=" + event.key + ",text=[Home],accepted=" + event.accepted);
                    break;
                case Qt.Key_End:
                    _webView.goFoword()
                    console.debug("Key=" + event.key + ",text=[End],accepted=" + event.accepted);
                    break;
                case Qt.Key_Space:
                    _webView.goFoword()
                    console.debug("Key=" + event.key + ",text=[Space],accepted=" + event.accepted);
                    break;
                case Qt.Key_Backspace:
                    _webView.goBack()
                    console.debug("Key=" + event.key + ",text=[BkSp],accepted=" + event.accepted);
                    break;
                case Qt.Key_Shift | Qt.Key_Backspace :
                    _webView.goFoword()
                    console.debug("Key=" + event.key + ",text=[Shift+BkSp],accepted=" + event.accepted);
                    break;
                default:
                    console.debug("Key=" + event.key + ",text=" + event.text + ",accepted=" + event.accepted);
                    break;
                }
                // イベントが到達しなくなる
                //event.accepted = true;
                */
            }
            Component.onCompleted: {
                _webView.url = _url.text
            }
        }
    }
}
