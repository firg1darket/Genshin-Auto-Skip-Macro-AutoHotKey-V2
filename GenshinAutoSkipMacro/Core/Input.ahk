#Requires AutoHotkey v2.0

PressMacroKey() {
    global Config, App
    key := Config["PressKey"]
    hold := Random(Config["HoldMin"], Config["HoldMax"])
    vk := GetKeyVK(key)

    if vk {
        DllCall("user32.dll\keybd_event", "UChar", vk, "UChar", 0, "UInt", 0, "UPtr", 0)
        Sleep(hold)
        DllCall("user32.dll\keybd_event", "UChar", vk, "UChar", 0, "UInt", 0x0002, "UPtr", 0)
    } else {
        SendInput("{" key " down}")
        Sleep(hold)
        SendInput("{" key " up}")
    }
}

ReleaseMacroKey() {
    global Config
    key := Config["PressKey"]
    vk := GetKeyVK(key)
    try {
        if vk
            DllCall("user32.dll\keybd_event", "UChar", vk, "UChar", 0, "UInt", 0x0002, "UPtr", 0)
        else
            SendInput("{" key " up}")
    }
}
