#Requires AutoHotkey v2.0
#SingleInstance Force

; Genshin usually runs elevated on this setup. Relaunch this script as admin
; when it was started normally, so input is sent at the same integrity level.
if !A_IsAdmin {
    try {
        Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
    } catch Error as e {
        MsgBox('Administrator rights are required to run this macro.`n`n' e.Message, 'Genshin Dialogue Macro', 'Iconx')
    }
    ExitApp()
}

Persistent
#Include %A_ScriptDir%\Config\Config.ahk
#Include %A_ScriptDir%\Core\Input.ahk
#Include %A_ScriptDir%\Core\Dialogue.ahk
#Include %A_ScriptDir%\Core\Macro.ahk
#Include "Core\Language.ahk"
#Include "GUI\GUI.ahk"

global App := GenshinMacroApp()
LoadConfig()
Lang.Init()

App := GenshinMacroApp()
App.Init()
