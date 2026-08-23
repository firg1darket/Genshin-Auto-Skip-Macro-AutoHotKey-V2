#Requires AutoHotkey v2.0

; --- check the game (DON"T TOUCH)

IsGenshinRunning() {
    return !!(ProcessExist("GenshinImpact.exe")
        || ProcessExist("YuanShen.exe")
        || ProcessExist("GenshinImpactCloudGame.exe"))
}

IsGenshinActive() {
    try {
        hwnd := WinExist("A")
        if !hwnd
            return false

        title := StrLower(WinGetTitle("ahk_id " hwnd))
        exe := WinGetProcessName("ahk_id " hwnd)

        titleMatch := InStr(title, "genshin impact") || InStr(title, "原神")
        exeMatch := (exe = "GenshinImpact.exe"
            || exe = "YuanShen.exe"
            || exe = "GenshinImpactCloudGame.exe")

        return titleMatch || exeMatch
    } catch {
        return false
    }
}

; --- check pixels 

ScreenX(x) {
    global Config
    return Round(x * A_ScreenWidth / Config["ReferenceW"])
}

ScreenY(y) {
    global Config
    return Round(y * A_ScreenHeight / Config["ReferenceH"])
}

PixelAtReference(x, y) {
    try {
        return PixelGetColor(ScreenX(x), ScreenY(y), "RGB")
    } catch {
        return ""
    }
}

IsDialoguePlaying() {
    return PixelAtReference(84, 46) = 0xECE5D8
}

IsDialogueOptionAvailable() {
    try {
        if (PixelAtReference(1200, 700) = 0xFFFFFF)
            return false

        return (PixelAtReference(1301, 808) = 0xFFFFFF)
            || (PixelAtReference(1301, 790) = 0xFFFFFF)
            || (PixelAtReference(1300, 800) = 0xFFFFFF)
    } catch {
        return false
    }
}

PixelDialogueDetected() {
    return IsDialoguePlaying() || IsDialogueOptionAvailable()
}

; --- alt checkers

ImageDialogueDetected() {
    static lastCheck := 0
    static lastResult := false
    static checkInterval := 120
    static imageFiles := [
        ; Russian, Chinese and English UI templates supplied from the actual game UI, touch it if you know what you're doing.
        A_ScriptDir "\\Images\\dialog button ru.png",
        A_ScriptDir "\\Images\\dialog button.png",
        A_ScriptDir "\\Images\\dialog button cn.png",
        A_ScriptDir "\\Images\\dialog button cn alt.png",
        A_ScriptDir "\\Images\\dialog button en.png",
        A_ScriptDir "\\Images\\dialog button en alt.png",
        A_ScriptDir "\\Images\\variants\\ru_90.png",
        A_ScriptDir "\\Images\\variants\\ru_94.png",
        A_ScriptDir "\\Images\\variants\\ru_97.png",
        A_ScriptDir "\\Images\\variants\\ru_100.png",
        A_ScriptDir "\\Images\\variants\\ru_103.png",
        A_ScriptDir "\\Images\\variants\\ru_106.png",
        A_ScriptDir "\\Images\\variants\\ru_110.png",
        A_ScriptDir "\\Images\\variants\\orig_90.png",
        A_ScriptDir "\\Images\\variants\\orig_94.png",
        A_ScriptDir "\\Images\\variants\\orig_97.png",
        A_ScriptDir "\\Images\\variants\\orig_100.png",
        A_ScriptDir "\\Images\\variants\\orig_103.png",
        A_ScriptDir "\\Images\\variants\\orig_106.png",
        A_ScriptDir "\\Images\\variants\\orig_110.png"
    ]

    if (A_TickCount - lastCheck < checkInterval)
        return lastResult

    lastCheck := A_TickCount
    lastResult := false

    
    for _, imagePath in imageFiles {
        if !FileExist(imagePath)
            continue
        try {
            if ImageSearch(&foundX, &foundY, 0, 0, A_ScreenWidth - 1, A_ScreenHeight - 1, "*60 *TransBlack " Chr(34) imagePath Chr(34)) {
                lastResult := true
                return true
            }
        } catch {
            continue
        }
    }
    return false
}

DialogueDetected() {
    if PixelDialogueDetected()
        return true

    return ImageDialogueDetected()
}
