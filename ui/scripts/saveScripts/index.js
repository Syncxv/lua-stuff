import * as ffi from 'ffi-napi'
import robot from 'robotjs'

const user32 = new ffi.Library('user32', {
    'GetTopWindow': ['long', ['long']],
    'FindWindowA': ['long', ['string', 'string']],
    'SetActiveWindow': ['long', ['long']],
    'SetForegroundWindow': ['bool', ['long']],
    'BringWindowToTop': ['bool', ['long']],
    'ShowWindow': ['bool', ['long', 'int']],
    'SwitchToThisWindow': ['void', ['long', 'bool']],
    'GetForegroundWindow': ['long', []],
    'AttachThreadInput': ['bool', ['int', 'long', 'bool']],
    'GetWindowThreadProcessId': ['int', ['long', 'int']],
    'SetWindowPos': ['bool', ['long', 'long', 'int', 'int', 'int', 'int', 'uint']],
    'SetFocus': ['long', ['long']]
});

const kernel32 = new ffi.Library('Kernel32.dll', {
    'GetCurrentThreadId': ['int', []]
});


const winToSetOnTop = user32.FindWindowA(null, "WeaponControllerConfig - Roblox Studio")
var foregroundHWnd = user32.GetForegroundWindow()
var currentThreadId = kernel32.GetCurrentThreadId()
var windowThreadProcessId = user32.GetWindowThreadProcessId(foregroundHWnd, null)
var showWindow = user32.ShowWindow(winToSetOnTop, 9)
var setWindowPos1 = user32.SetWindowPos(winToSetOnTop, -1, 0, 0, 0, 0, 3)
var setWindowPos2 = user32.SetWindowPos(winToSetOnTop, -2, 0, 0, 0, 0, 3)
var setForegroundWindow = user32.SetForegroundWindow(winToSetOnTop)
var attachThreadInput = user32.AttachThreadInput(windowThreadProcessId, currentThreadId, 0)
var setFocus = user32.SetFocus(winToSetOnTop)
var setActiveWindow = user32.SetActiveWindow(winToSetOnTop)
console.log(winToSetOnTop, setActiveWindow, setFocus)



var mouse=robot.getMousePos();
console.log("Mouse is at x:" + mouse.x + " y:" + mouse.y);
