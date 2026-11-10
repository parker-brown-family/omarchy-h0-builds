// Run: node ~/.config/omarchy/plugins/parker.screen-sleep/test.mjs
import { readFileSync } from "node:fs"
import vm from "node:vm"
import assert from "node:assert/strict"

const dir = new URL(".", import.meta.url)
const read = (name) => readFileSync(new URL(name, dir), "utf8")

const Model = {}
vm.runInNewContext(read("ScreenSleepModel.js").replace(".pragma library", ""), Model)

// Timeout is ten minutes.
assert.equal(Model.DEFAULT_IDLE_SECONDS, 600)

// idle, stayAwake, screensOff -> action
const cases = [
  [true, false, false, "off"], // 10 min of no input: turn screens off
  [true, false, true, ""],     // already off
  [false, false, true, "on"],  // mouse/keyboard input: turn back on
  [false, false, false, ""],   // already on
  [true, true, false, ""],     // stay-awake keeps screens on
  [true, true, true, "on"],    // stay-awake toggled while dark wakes them
  [false, true, true, "on"],
  [false, true, false, ""],
]
for (const [idle, stay, off, want] of cases)
  assert.equal(Model.nextAction(idle, stay, off), want, JSON.stringify({ idle, stay, off }))

// Screens off/on is exactly Hyprland's DPMS dispatcher, run without a shell.
assert.deepEqual([...Model.argvFor("off")], ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "disable" })'])
assert.deepEqual([...Model.argvFor("on")], ["hyprctl", "dispatch", 'hl.dsp.dpms({ action = "enable" })'])
assert.deepEqual([...Model.argvFor("")], [])

const service = read("Service.qml").replace(/\/\/.*$/gm, "")

// Every process the service can start, and nothing else: the two DPMS
// dispatches above, plus mkdir/test for reading the stay-awake marker file.
const commands = [...service.matchAll(/(?:\.command\s*=|command:|execDetached\()\s*([^\n]+)/g)].map((m) => m[1].trim())
assert.deepEqual(commands, [
  "Model.argvFor(action)",
  '["mkdir", "-p", root.stayAwakeStateDir]',
  '["test", "-f", root.stayAwakeStateDir + "/stay-awake"]',
  'Model.argvFor("on"))',
])
// Any other way to start a process would bypass the list above.
assert.equal((service.match(/\bProcess\s*\{/g) || []).length, 3)
assert.equal((service.match(/exec\w*\(/g) || []).length, 1)

// Never suspend: no shell and no sleep/suspend/hibernate/poweroff primitive
// anywhere in the plugin's code (comments stripped).
const forbidden = /\bbash\b|\bsh\b|systemctl|loginctl|suspend|hibernate|hybrid-sleep|poweroff|reboot|rtcwake|\/sys\/power|omarchy-|zzz/i
for (const [file, code] of [["Service.qml", service], ["ScreenSleepModel.js", read("ScreenSleepModel.js").replace(/\/\/.*$/gm, "")]])
  assert.ok(!forbidden.test(code), file + " contains " + code.match(forbidden))

console.log("parker.screen-sleep: all tests passed")
