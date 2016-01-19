import QtQuick 2.0
import Ubuntu.Web 0.2

/*!
    \qmltype PollFish
    \brief A component to show user surveys from Pollfish.com in a QML app in
    order to monetise that app.

    PollFish needs to have its api_key parameter specified; that api_key is
    obtained from the app's record in your Pollfish account.

    To make the component render a poll, call its begin() method. This method
    can optionally take a dictionary of configuration options as per
    https://www.pollfish.com/docs/webplugin. In particular, while testing,
    pass debug:true in this options object.

    The component's status attribute shows which status the poll is at. The
    possible statuses are:

    surveyClose
        Set when user clicks or touches outside the Pollfish survey container, or
        if she clicks or touches the close icon
    userNotEligible
        Set when the user is not eligible for surveys
    closeAndNoShow
        Set when the survey is closed and the indicator hides permanently
        (e.g., when finishing the survey)
    surveyCompleted
        Set when the user finishes the survey
    surveyAvailable
        Set when there is an availble survey for the user
    noSurveyAvailableOnCall
        Set when there is no survey available
    pollfishDidNotLoad
        Set when Pollfish does not start up for some reason.

    To detect a "success" condition (that is, the user filled in a survey, or they
    did not because there was no survey available), check for
    surveyCompleted || noSurveyAvailableOnCall.

    Example:
    \qml
        import QtQuick 2.4
        import Ubuntu.Components 1.2

        MainView {
            width: units.gu(48)
            height: units.gu(60)

            PageStack {
                id: pageStack
                Component.onCompleted: push(page0)

                Page {
                    id: page0
                    title: i18n.tr("Root page")
                    visible: false

                    Button {
                        text: "Fill in a survey"
                        onClicked: {
                            pageStack.push(pollpage);
                            pollfish.begin({debug: true});
                        }
                    }
                }
                Page {
                    id: pollpage

                    Pollfish {
                        anchors.fill: parent
                        api_key: "abcdef1234567890"
                        onStatusChanged: {
                            if (status == "surveyCompleted" || status == "noSurveyAvailableOnCall") {
                                console.log("They completed the survey");
                            }
                        }
                    }
                }
            }
        }
    \endqml

    The Pollfish component requires both Pollfish.qml and Pollfish.html to be present.
*/

WebView {
    id: wv
    /*!
      The API key for this app, from the Pollfish dashboard
     */
    property string api_key
    /*!
      A uniquely identifying uuid for this user. Entirely optional.
     */
    property string uuid
    /*!
      Show a survey in the Pollfish component.
     */
    function begin(options) {
        var opts = {
            api_key: wv.api_key,
            uuid: wv.uuid || "no-uuid-provided"
        };
        if (options) {
            for (var k in options) {
                opts[k] = options[k];
            }
        }

        wv.url = Qt.resolvedUrl("Pollfish.html") + "#" + JSON.stringify(opts);
    }
    onTitleChanged: {
        if (title.match(/^status:::/)) {
            wv.status = title.substr(9);
        }
    }

    /*!
      The current status of the survey in the component.
     */
    property string status: "initialising"
}
