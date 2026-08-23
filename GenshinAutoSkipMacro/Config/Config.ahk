#Requires AutoHotkey v2.0

global ConfigFile := A_ScriptDir "\Config\settings.ini"
global Config := Map(
    "ReferenceW", 1920,
    "ReferenceH", 1080,
    "PressKey", "f",
    "HoldMin", 40,
    "HoldMax", 90,
    "IntervalMin", 150,
    "IntervalMax", 350,
    "LongIntervalChance", 0.10,
    "BreakChance", 0.03,
    "BreakMin", 2500,
    "BreakMax", 6000,
    "BreakCooldown", 25000,
    "StartHotkey", "F8"
)

LoadConfig() {
    global Config, ConfigFile
    if !FileExist(ConfigFile)
        return
    for key, defaultValue in Config {
        value := IniRead(ConfigFile, "Settings", key, defaultValue)
        if (Type(defaultValue) = "Integer")
            Config[key] := Integer(value)
        else if (Type(defaultValue) = "Float")
            Config[key] := Float(value)
        else
            Config[key] := value
    }
}

SaveConfig() {
    global Config, ConfigFile
    if !DirExist(A_ScriptDir "\Config")
        DirCreate(A_ScriptDir "\Config")
    for key, value in Config
        IniWrite(value, ConfigFile, "Settings", key)
}

LoadConfig()
