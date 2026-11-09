import QtQuick

// Service half of the drawer. Bar widgets are only injected with `bar`,
// `moduleName` and `settings`; services also receive the host's bar-widget
// catalogue (a detached snapshot holding the real widget components, kept
// current by the shell). The drawer widget fetches this object through
// `bar.shell.serviceFor("parker.drawer")`, its own plugin's service, and builds
// the tucked widgets from that catalogue.
QtObject {
  property var barWidgetRegistry: null
}
