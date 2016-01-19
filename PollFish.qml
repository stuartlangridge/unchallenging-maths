import QtQuick 2.0
import Ubuntu.Web 0.2

WebView {
    id: wv
    property string api_key
    function begin() {
        wv.url = Qt.resolvedUrl("poller.html");
    }
    onTitleChanged: {
        if (title.match(/^status:::/)) {
            wv.status = title.substr(9);
        }
    }

    property string status: "initialising"
}
