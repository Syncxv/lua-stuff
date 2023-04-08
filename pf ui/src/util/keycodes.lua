keycodes_module = {}

keycodes_module.Keys = {
    LAlt = Enum.KeyCode.LeftAlt,
    RAlt = Enum.KeyCode.RightAlt,
    LShift = Enum.KeyCode.LeftShift,
    RShift = Enum.KeyCode.RightShift,
    LControl = Enum.KeyCode.LeftControl,
    RControl = Enum.KeyCode.RightControl,
    Tab = Enum.KeyCode.Tab,
    CapsLock = Enum.KeyCode.CapsLock,
    Backspace = Enum.KeyCode.Backspace,
    Delete = Enum.KeyCode.Delete,
    Insert = Enum.KeyCode.Insert,
    PageUp = Enum.KeyCode.PageUp,
    PageDown = Enum.KeyCode.PageDown,
    Home = Enum.KeyCode.Home,
    End = Enum.KeyCode.End,
    NumLock = Enum.KeyCode.NumLock,
    ScrollLock = Enum.KeyCode.ScrollLock,
    RightBracket = Enum.KeyCode.RightBracket,
    LeftBracket = Enum.KeyCode.LeftBracket,
    F1 = Enum.KeyCode.F1,
    F2 = Enum.KeyCode.F2,
    F3 = Enum.KeyCode.F3,
    F4 = Enum.KeyCode.F4,
    F5 = Enum.KeyCode.F5,
    F6 = Enum.KeyCode.F6,
    F7 = Enum.KeyCode.F7,
    F8 = Enum.KeyCode.F8,
    F9 = Enum.KeyCode.F9,
    F10 = Enum.KeyCode.F10,
    F11 = Enum.KeyCode.F11,
    F12 = Enum.KeyCode.F12,
}

keycodes_module.KeyNames = {}

for key, keyCode in pairs(keycodes_module.Keys) do
    table.insert(keycodes_module.KeyNames, key)
end