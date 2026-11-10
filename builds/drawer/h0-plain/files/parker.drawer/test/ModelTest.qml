// Run from the plugin directory:
//   QML_XHR_ALLOW_FILE_READ=1 QT_QPA_PLATFORM=offscreen qml6 test/ModelTest.qml
import QtQuick
import "../DrawerModel.js" as M

QtObject {
  function check(cond, msg) { if (!cond) throw new Error("FAIL: " + msg) }
  function same(a, b, msg) { check(JSON.stringify(a) === JSON.stringify(b), msg + " got " + JSON.stringify(a)) }

  Component.onCompleted: {
    var xhr = new XMLHttpRequest()
    xhr.open("GET", Qt.resolvedUrl("../../../shell.json"), false)
    xhr.send()
    var bar = JSON.parse(xhr.responseText).bar
    var id = "parker.drawer"
    var before = JSON.stringify(bar)
    var tucked = M.tuckedIds(bar.layout, id)
    var filtered = M.filteredBarConfig(bar, id)
    var vis = function(s) { return filtered.layout[s].map(function(e) { return e.id }) }
    ;["left", "center", "right"].forEach(function(s) {
      tucked.forEach(function(t) { check(vis(s).indexOf(t) === -1, t + " still on bar") })
    })
    check(vis("right").indexOf(id) !== -1, "drawer button must stay on the bar")
    check(JSON.stringify(bar) === before, "real config must not be mutated")
    check(filtered.id === id && filtered.position === bar.position, "other bar keys preserved")

    var drawerEntry = bar.layout.right.filter(function(e) { return e.id === id })[0]
    var settings = {}
    for (var k in drawerEntry) if (k !== "id") settings[k] = drawerEntry[k]
    var items = M.drawerItems(bar.layout, M.entryFromSettings(id, settings), id)
    same(items.map(function(i) { return i.id }), drawerEntry.items, "drawer order")
    check(items.every(function(i) { return i.inLayout }), "tucked widgets keep layout entries")

    same(M.itemList({ items: "omarchy.clock" }, id), ["omarchy.clock"], "string items")
    same(M.itemList({ items: [id, "a", "a", "", { id: "b" }] }, id), ["a", "b"], "dedupe/self/objects")
    same(M.itemList({}, id), [], "no items")
    var clock = M.drawerItems({ center: [{ id: "omarchy.clock", format: "HH:mm" }] }, { items: ["omarchy.clock", "x.missing"] }, id)
    same(clock[0], { id: "omarchy.clock", region: "center", settings: { format: "HH:mm" }, inLayout: true }, "settings lookup")
    check(clock[1].inLayout === false, "missing widget flagged")
    same(M.filteredBarConfig({ position: "top" }, id), { position: "top" }, "no layout")

    console.log("visible left:", vis("left"), "| center:", vis("center"), "| right:", vis("right"))
    console.log("drawer:", items.map(function(i) { return i.id + "@" + i.region }).join(", "))
    console.log("MODEL TESTS PASSED")
    Qt.callLater(function() { Qt.exit(0) })
  }
}
