import QtQuick 2.15
import QtQuick.XmlListModel 2.0
import '../helpers/utils.js' as Utils

XmlListModel {
    id: xlm
    query: "/Response/Item"

    property string hostUrl
    property string fields: ''
    property string command: ''

    signal aboutToLoad()
    signal resultsReady(var count)

    onSourceChanged: {
        if (source.toString() !== '')
            aboutToLoad()
    }

    onCommandChanged: load()

    onHostUrlChanged: source = ''

    onFieldsChanged: {
        roles.length = 0
        source = ''
        fields.split(',').forEach(fld => {
            roles.push(
                Qt.createQmlObject('import QtQuick.XmlListModel 2.0;
                                    XmlRole { name: "%1";
                                    query: "Field[@Name=\'%2\']/string()" }'.arg(fld.replace(/ /g, "").toLowerCase()).arg(fld), xlm))
        })
    }

    onStatusChanged: {
        if (status === XmlListModel.Ready)
            resultsReady(count)
    }

    function load(resetSource) {
        if (resetSource !== undefined & resetSource)
            source = ''
        if (command !== '')
            source = hostUrl + command
                    + (fields !== '' ? '&Fields=' + fields : '')
    }

    function findIndex(compare) {
        if (!Utils.isFunction(compare))
            return -1

        for (var i=0, len = xlm.count; i<len; ++i) {
            if (compare(xlm.get(i)))
                return i
        }
        return -1
    }

    function find(compare) {
        if (!Utils.isFunction(compare))
            return undefined

        for (var i=0, len = xlm.count; i<len; ++i) {
            if (compare(xlm.get(i)))
                return xml.get(i)
        }
        return undefined
    }

    function forEach(callback) {
        if (!Utils.isFunction(callback))
            return

        for (var i=0, len = xlm.count; i<len; ++i) {
            callback(xlm.get(i))
        }
    }
}
