import QtQuick 2.15

// arr of { host, friendlyname, accesskey, zones, enabled }
// see load()
BaseListModel {

    property bool autoLoad: true
    property bool loadEnabledOnly: true

    // Configured mcws host string
    property string configString: ''
    onConfigStringChanged: if (autoLoad) load()

    signal loadStart()
    signal loadFinish(int count)
    signal loadError(string msg)

    function load() {
        loadStart()
        clear()

        try {
            JSON.parse(configString)
            .forEach(item => {
                if (!loadEnabledOnly | item.enabled) {
                    var h = Object.assign({ host: ''
                                          , accesskey: ''
                                          , friendlyname: ''
                                          , zones: ''
                                          , enabled: false }, item)
                    // Because friendlyname can be used as displayText,
                    // if null, default to host name
                    if (h.friendlyname === '')
                        h.friendlyname = h.host.split(':')[0]
                    append(h)
                }
            })
        }
        catch (err) {
            var s = err.message + '\n' + configString
            console.warn(s)
            loadError('Host config parse error: ' + s)
        }

        loadFinish(count)
    }

}
