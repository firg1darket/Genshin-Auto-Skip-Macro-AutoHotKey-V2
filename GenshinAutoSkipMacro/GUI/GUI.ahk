#Requires AutoHotkey v2.0

class GenshinMacroApp {
    __New() {
        this.mainControls := []
        this.settingsControls := []
        this.informationControls := []
        this.bindButtons := Map()
        this.hotkeys := Map()
        this.captureTarget := ""
        this.isCapturing := false
        this.captureHook := 0
        this.statusOverride := ""
        this.githubUrl := "https://github.com/1hubert/genshin-dialogue-autoskip"
    }

    Init() {
        this.gui := Gui("-Caption +Border", Lang.Get("window_title"))
        this.gui.BackColor := "171923"
        this.gui.MarginX := 0
        this.gui.MarginY := 0

        this.gui.OnEvent("Close", ObjBindMethod(this, "ExitNow"))

        iconPath := A_ScriptDir "\Images\genshin_dialogue.ico"

        if FileExist(iconPath)
            TraySetIcon(iconPath)

        this.BuildShell()
        this.BuildMain()
        this.BuildSettings()
        this.BuildInformation()

        this.ApplyLanguage()
        this.ShowMain()
        this.RegisterHotkeys()

        this.gui.Show("w720 h620")

        SetTimer(ObjBindMethod(this, "UpdateStatus"), 150)
    }

    BuildShell() {
        this.gui.Add("Progress", "x0 y0 w720 h58 Disabled Background11131B", 0)
        this.gui.Add("Progress", "x0 y57 w720 h1 Disabled Background3A3F4E", 0)
        this.gui.Add("Progress", "x20 y56 w680 h2 Disabled BackgroundB77CFF", 0)

        iconPath := A_ScriptDir "\Images\genshin_dialogue.ico"

        if FileExist(iconPath)
            this.gui.Add("Picture", "x18 y12 w34 h34 BackgroundTrans", iconPath)

        this.gui.SetFont("s11 w600 cEEE6D4", "Segoe UI")

        this.titleText := this.gui.Add(
            "Text",
            "x62 y13 w470 h22 BackgroundTrans",
            ""
        )

        this.titleText.OnEvent("Click", ObjBindMethod(this, "DragWindow"))

        this.gui.SetFont("s8 c9299A8", "Segoe UI")

        this.subtitleText := this.gui.Add(
            "Text",
            "x63 y35 w470 h16 BackgroundTrans",
            ""
        )

        this.subtitleText.OnEvent("Click", ObjBindMethod(this, "DragWindow"))

        this.gui.SetFont("s10 w600 cB8BFCC", "Segoe UI")

        this.minBtn := this.gui.Add(
            "Text",
            "x638 y14 w26 h26 Center 0x200 Border Background171923",
            "—"
        )

        this.minBtn.OnEvent("Click", (*) => this.gui.Minimize())

        this.gui.SetFont("s13 w400 cE6D5D2", "Segoe UI")

        this.closeBtn := this.gui.Add(
            "Text",
            "x674 y12 w28 h28 Center 0x200 Border Background171923",
            "×"
        )

        this.closeBtn.OnEvent("Click", ObjBindMethod(this, "ExitNow"))

        this.gui.SetFont("s9 w600 cEEE6D4", "Segoe UI")

        this.tabMain := this.gui.Add(
            "Text",
            "x20 y72 w120 h28 Center 0x200 Border Background202431",
            ""
        )

        this.tabSettings := this.gui.Add(
            "Text",
            "x145 y72 w120 h28 Center 0x200 Border Background202431",
            ""
        )

        this.tabInformation := this.gui.Add(
            "Text",
            "x270 y72 w120 h28 Center 0x200 Border Background202431",
            ""
        )

        this.tabMain.OnEvent("Click", (*) => this.ShowMain())
        this.tabSettings.OnEvent("Click", (*) => this.ShowSettings())
        this.tabInformation.OnEvent("Click", (*) => this.ShowInformation())

        this.tabAccent := this.gui.Add(
            "Progress",
            "x20 y98 w120 h2 Disabled BackgroundB77CFF",
            0
        )

        this.gui.Add(
            "Progress",
            "x20 y110 w680 h1 Disabled Background3A3F4E",
            0
        )
    }

    BuildMain() {
        panel := this.gui.Add(
            "Text",
            "x20 y126 w680 h154 Border Background202431",
            ""
        )

        this.PushMain(panel)

        this.gui.SetFont("s10 w600 cEEE6D4", "Segoe UI")

        this.mainHeading := this.gui.Add(
            "Text",
            "x38 y142 w350 h24 BackgroundTrans",
            ""
        )

        this.PushMain(this.mainHeading)

        this.gui.SetFont("s8 c9299A8", "Segoe UI")

        this.mainSub := this.gui.Add(
            "Text",
            "x38 y166 w600 h18 BackgroundTrans",
            ""
        )

        this.PushMain(this.mainSub)

        sep := this.gui.Add(
            "Progress",
            "x38 y192 w644 h1 Disabled Background3A3F4E",
            0
        )

        this.PushMain(sep)

        this.gui.SetFont("s9 c9299A8", "Segoe UI")

        this.lblMacroStatus := this.gui.Add("Text", "x38 y210 w145 h20 BackgroundTrans", "")
        this.lblGameStatus := this.gui.Add("Text", "x38 y238 w145 h20 BackgroundTrans", "")
        this.lblStartStop := this.gui.Add("Text", "x350 y210 w130 h20 BackgroundTrans", "")
        this.lblKeyClicking := this.gui.Add("Text", "x350 y238 w130 h20 BackgroundTrans", "")

        this.gui.SetFont("s10 w600 cEEE6D4", "Segoe UI")

        this.statusText := this.gui.Add("Text", "x185 y209 w170 h22 BackgroundTrans", "")
        this.genshinText := this.gui.Add("Text", "x185 y237 w150 h22 BackgroundTrans", "")
        this.startKeyText := this.gui.Add("Text", "x490 y209 w160 h22 BackgroundTrans", "")
        this.dialogueKeyText := this.gui.Add("Text", "x490 y237 w160 h22 BackgroundTrans", "")

        for _, c in [
            this.lblMacroStatus,
            this.lblGameStatus,
            this.lblStartStop,
            this.lblKeyClicking,
            this.statusText,
            this.genshinText,
            this.startKeyText,
            this.dialogueKeyText
        ]
            this.PushMain(c)

        this.gui.SetFont("s10 w600 cEEE6D4", "Segoe UI")

        this.controlsHeading := this.gui.Add(
            "Text",
            "x20 y300 w300 h24",
            ""
        )

        this.PushMain(this.controlsHeading)

        this.gui.SetFont("s8 c9299A8", "Segoe UI")

        this.controlsSub := this.gui.Add(
            "Text",
            "x20 y324 w600 h18",
            ""
        )

        this.PushMain(this.controlsSub)

        this.gui.SetFont("s11 w600 cEEE6D4", "Segoe UI")

        this.startBtn := this.gui.Add(
            "Text",
            "x20 y360 w335 h56 Center 0x200 Border Background30253D",
            ""
        )

        this.settingsBtn := this.gui.Add(
            "Text",
            "x365 y360 w335 h56 Center 0x200 Border Background202431",
            ""
        )

        this.startBtn.OnEvent("Click", (*) => Macro.Toggle())
        this.settingsBtn.OnEvent("Click", (*) => this.ShowSettings())

        this.PushMain(this.startBtn)
        this.PushMain(this.settingsBtn)

        this.gui.SetFont("s8 cA88BD1", "Segoe UI")

        this.footer := this.gui.Add(
            "Text",
            "x20 y452 w680 h32 Center",
            ""
        )

        this.PushMain(this.footer)
    }

    BuildSettings() {
        panel := this.gui.Add(
            "Text",
            "x20 y126 w680 h250 Hidden Border Background202431",
            ""
        )

        this.PushSettings(panel)

        this.gui.SetFont("s11 w600 cEEE6D4", "Segoe UI")

        this.settingsHeading := this.gui.Add(
            "Text",
            "x38 y142 w624 h24 Hidden BackgroundTrans",
            ""
        )

        this.PushSettings(this.settingsHeading)

        this.gui.SetFont("s8 c9299A8", "Segoe UI")

        this.settingsSub := this.gui.Add(
            "Text",
            "x38 y168 w624 h18 Hidden BackgroundTrans",
            ""
        )

        this.PushSettings(this.settingsSub)

        sep := this.gui.Add(
            "Progress",
            "x38 y194 w624 h1 Hidden Disabled Background3A3F4E",
            0
        )

        this.PushSettings(sep)

        this.gui.SetFont("s9 w600 cB9C0CC", "Segoe UI")

        this.dialogueLabel := this.gui.Add(
            "Text",
            "x38 y212 w190 h42 Hidden 0x200",
            ""
        )

        this.startPauseLabel := this.gui.Add(
            "Text",
            "x38 y264 w190 h42 Hidden 0x200",
            ""
        )

        this.PushSettings(this.dialogueLabel)
        this.PushSettings(this.startPauseLabel)

        this.gui.SetFont("s10 w600 cEEE6D4", "Segoe UI")

        b1 := this.gui.Add(
            "Text",
            "x245 y212 w417 h42 Hidden Center 0x200 Border Background171923",
            ""
        )

        b2 := this.gui.Add(
            "Text",
            "x245 y264 w417 h42 Hidden Center 0x200 Border Background171923",
            ""
        )

        b1.OnEvent("Click", ObjBindMethod(this, "CaptureBind", "PressKey"))
        b2.OnEvent("Click", ObjBindMethod(this, "CaptureBind", "StartHotkey"))

        this.bindButtons["PressKey"] := b1
        this.bindButtons["StartHotkey"] := b2

        this.PushSettings(b1)
        this.PushSettings(b2)

        this.gui.SetFont("s8 cA88BD1", "Segoe UI")

        this.captureHint := this.gui.Add(
            "Text",
            "x38 y320 w624 h22 Hidden Center 0x200",
            ""
        )

        this.PushSettings(this.captureHint)

        this.gui.SetFont("s11 w600 cEEE6D4", "Segoe UI")

        this.backBtn := this.gui.Add(
            "Text",
            "x20 y402 w335 h56 Hidden Center 0x200 Border Background202431",
            ""
        )

        this.saveBtn := this.gui.Add(
            "Text",
            "x365 y402 w335 h56 Hidden Center 0x200 Border Background30253D",
            ""
        )

        this.backBtn.OnEvent("Click", (*) => this.ShowMain())
        this.saveBtn.OnEvent("Click", (*) => this.SaveSettings())

        this.PushSettings(this.backBtn)
        this.PushSettings(this.saveBtn)
    }

    BuildInformation() {
        this.infoTopPanel := this.gui.Add(
            "Text",
            "x20 y126 w680 h210 Hidden Border Background202431",
            ""
        )

        this.PushInformation(this.infoTopPanel)

        this.gui.SetFont("s16 w600 cEEE6D4", "Segoe UI")

        this.infoHeading := this.gui.Add(
            "Text",
            "x38 y142 w624 h30 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.infoHeading)

        this.gui.SetFont("s9 cB77CFF", "Segoe UI")

        this.infoSub := this.gui.Add(
            "Text",
            "x38 y176 w624 h20 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.infoSub)

        sep1 := this.gui.Add(
            "Progress",
            "x38 y208 w624 h1 Hidden Disabled Background3A3F4E",
            0
        )

        this.PushInformation(sep1)

        this.gui.SetFont("s10 w600 cEEE6D4", "Segoe UI")

        this.infoHowWorks := this.gui.Add(
            "Text",
            "x38 y222 w624 h22 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.infoHowWorks)

        this.gui.SetFont("s9 cB9C0CC", "Segoe UI")

        this.infoLine1 := this.gui.Add("Text", "x50 y252 w600 h18 Hidden BackgroundTrans", "")
        this.infoLine2 := this.gui.Add("Text", "x50 y273 w600 h18 Hidden BackgroundTrans", "")
        this.infoLine3 := this.gui.Add("Text", "x50 y294 w600 h18 Hidden BackgroundTrans", "")
        this.infoLine4 := this.gui.Add("Text", "x50 y315 w600 h18 Hidden BackgroundTrans", "")

        this.PushInformation(this.infoLine1)
        this.PushInformation(this.infoLine2)
        this.PushInformation(this.infoLine3)
        this.PushInformation(this.infoLine4)

        this.creditsCard := this.gui.Add(
            "Text",
            "x20 y352 w680 h150 Hidden Border Background1C1E2A",
            ""
        )

        this.PushInformation(this.creditsCard)

        this.gui.SetFont("s11 w600 cB77CFF", "Segoe UI")

        this.creditsHeading := this.gui.Add(
            "Text",
            "x40 y370 w620 h22 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.creditsHeading)

        this.gui.SetFont("s8 c8D93A4", "Segoe UI")

        this.creditsSub := this.gui.Add(
            "Text",
            "x40 y395 w620 h18 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.creditsSub)

        this.gui.SetFont("s8 c747A8B", "Segoe UI")

        this.basedOnLabel := this.gui.Add(
            "Text",
            "x40 y425 w130 h20 Hidden BackgroundTrans",
            ""
        )

        this.authorLabel := this.gui.Add(
            "Text",
            "x40 y450 w130 h20 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.basedOnLabel)
        this.PushInformation(this.authorLabel)

        this.gui.SetFont("s9 w600 cEEE6D4", "Segoe UI")

        this.projectText := this.gui.Add(
            "Text",
            "x175 y423 w300 h22 Hidden BackgroundTrans",
            "genshin-dialogue-autoskip"
        )

        this.authorText := this.gui.Add(
            "Text",
            "x175 y448 w150 h22 Hidden BackgroundTrans",
            "1hubert"
        )

        this.PushInformation(this.projectText)
        this.PushInformation(this.authorText)

        this.gui.SetFont("s9 w600 cEEE6D4", "Segoe UI")

        this.githubBtn := this.gui.Add(
            "Text",
            "x505 y425 w155 h45 Hidden Center 0x200 Border Background30253D",
            ""
        )

        this.githubBtn.OnEvent("Click", ObjBindMethod(this, "OpenGitHub"))

        this.PushInformation(this.githubBtn)

        this.gui.SetFont("s8 c8D93A4", "Segoe UI")

        this.forkNote := this.gui.Add(
            "Text",
            "x40 y477 w620 h18 Hidden BackgroundTrans",
            ""
        )

        this.PushInformation(this.forkNote)

        this.gui.SetFont("s11 w600 cEEE6D4", "Segoe UI")

        this.languageBtn := this.gui.Add(
            "Text",
            "x20 y522 w335 h56 Hidden Center 0x200 Border Background30253D",
            ""
        )

        this.infoBackBtn := this.gui.Add(
            "Text",
            "x365 y522 w335 h56 Hidden Center 0x200 Border Background202431",
            ""
        )

        this.languageBtn.OnEvent("Click", (*) => this.ToggleLanguage())
        this.infoBackBtn.OnEvent("Click", (*) => this.ShowMain())

        this.PushInformation(this.languageBtn)
        this.PushInformation(this.infoBackBtn)
    }

    PushMain(c) {
        this.mainControls.Push(c)
    }

    PushSettings(c) {
        this.settingsControls.Push(c)
    }

    PushInformation(c) {
        this.informationControls.Push(c)
    }

    HideAllPages() {
        for _, c in this.mainControls
            c.Visible := false

        for _, c in this.settingsControls
            c.Visible := false

        for _, c in this.informationControls
            c.Visible := false
    }

    ShowMain() {
        this.CancelCapture()
        this.HideAllPages()

        for _, c in this.mainControls
            c.Visible := true

        this.tabAccent.Move(20, 98, 120, 2)
        this.UpdateStatus()
    }

    ShowSettings() {
        if this.isCapturing
            return

        this.HideAllPages()

        for _, c in this.settingsControls
            c.Visible := true

        this.tabAccent.Move(145, 98, 120, 2)
        this.UpdateBindTexts()
    }

    ShowInformation() {
        if this.isCapturing
            return

        this.HideAllPages()

        for _, c in this.informationControls
            c.Visible := true

        this.tabAccent.Move(270, 98, 120, 2)
    }

    ToggleLanguage() {
        Lang.Next()

        try SaveConfig()

        this.ApplyLanguage()
    }

    ApplyLanguage() {
        this.gui.Title := Lang.Get("window_title")

        this.titleText.Text := Lang.Get("title")
        this.subtitleText.Text := Lang.Get("subtitle")

        this.tabMain.Text := Lang.Get("tab_main")
        this.tabSettings.Text := Lang.Get("tab_settings")
        this.tabInformation.Text := Lang.Get("tab_information")

        this.mainHeading.Text := Lang.Get("stats_heading")
        this.mainSub.Text := Lang.Get("stats_sub")

        this.lblMacroStatus.Text := Lang.Get("macro_status")
        this.lblGameStatus.Text := Lang.Get("game_status")
        this.lblStartStop.Text := Lang.Get("start_stop")
        this.lblKeyClicking.Text := Lang.Get("key_clicking")

        this.controlsHeading.Text := Lang.Get("controls")
        this.controlsSub.Text := Lang.Get("controls_sub")
        this.settingsBtn.Text := Lang.Get("settings")
        this.footer.Text := Lang.Get("footer")

        this.settingsHeading.Text := Lang.Get("key_bindings")
        this.settingsSub.Text := Lang.Get("settings_sub")
        this.dialogueLabel.Text := Lang.Get("dialogue_key")
        this.startPauseLabel.Text := Lang.Get("start_pause")
        if !this.isCapturing
            this.captureHint.Text := Lang.Get("capture_default")
        this.backBtn.Text := Lang.Get("back")
        this.saveBtn.Text := Lang.Get("save")

        this.infoHeading.Text := Lang.Get("info_heading")
        this.infoSub.Text := Lang.Get("info_sub")
        this.infoHowWorks.Text := Lang.Get("how_works")

        this.infoLine1.Text := Lang.Get("info_1")
        this.infoLine2.Text := Lang.Get("info_2")
        this.infoLine3.Text := Lang.Get("info_3")
        this.infoLine4.Text := Lang.Get("info_4")

        this.creditsHeading.Text := Lang.Get("credits")
        this.creditsSub.Text := Lang.Get("credits_sub")
        this.basedOnLabel.Text := Lang.Get("based_on") ":"
        this.authorLabel.Text := Lang.Get("original_author") ":"
        this.forkNote.Text := Lang.Get("fork_note")
        this.githubBtn.Text := Lang.Get("open_github")

        this.languageBtn.Text := Lang.Get("language")
        this.infoBackBtn.Text := Lang.Get("back_main")

        this.UpdateBindTexts()
        this.UpdateStatus()
    }

    UpdateBindTexts() {
        global Config

        if this.isCapturing
            return

        if !IsObject(Config)
            return

        if this.bindButtons.Has("PressKey") && Config.Has("PressKey")
            this.bindButtons["PressKey"].Text := Config["PressKey"]

        if this.bindButtons.Has("StartHotkey") && Config.Has("StartHotkey")
            this.bindButtons["StartHotkey"].Text := Config["StartHotkey"]

        if Config.Has("StartHotkey")
            this.startKeyText.Text := Config["StartHotkey"]

        if Config.Has("PressKey")
            this.dialogueKeyText.Text := Config["PressKey"]
    }

    CaptureBind(name, *) {
        global Config

        if this.isCapturing || !this.bindButtons.Has(name)
            return

        this.isCapturing := true
        this.captureTarget := name
        this.captureHook := 0
        this.bindButtons[name].Text := Lang.Get("capture_key")
        this.captureHint.Text := Lang.Get("capture_now")

        for keyName, button in this.bindButtons {
            if keyName != name
                button.Enabled := false
        }

        ih := InputHook("L1")
        this.captureHook := ih
        ih.KeyOpt("{All}", "E")
        ih.Start()
        ih.Wait()

        key := ih.EndKey

        for _, button in this.bindButtons
            button.Enabled := true

        this.captureHook := 0
        this.isCapturing := false
        this.captureTarget := ""

        if (key = "Escape") {
            this.UpdateBindTexts()
            this.captureHint.Text := Lang.Get("capture_cancelled")
            return
        }

        if (key != "") {
            Config[name] := key
            this.bindButtons[name].Text := key
            this.captureHint.Text := Lang.Get("binding_changed")
            return
        }

        this.UpdateBindTexts()
        this.captureHint.Text := Lang.Get("capture_cancelled")
    }

    CancelCapture() {
        if !this.isCapturing
            return

        try this.captureHook.Stop()
    }

    SaveSettings(*) {
        if this.isCapturing
            return

        try SaveConfig()

        this.RegisterHotkeys()
        this.UpdateBindTexts()
        this.captureHint.Text := Lang.Get("saved")

        SetTimer(
            (*) => this.ShowMain(),
            -700
        )
    }

    RegisterHotkeys() {
        global Config

        for _, key in this.hotkeys {
            try Hotkey(key, "Off")
        }

        this.hotkeys := Map()

        if !IsObject(Config) || !Config.Has("StartHotkey")
            return

        startKey := Config["StartHotkey"]

        if (startKey != "") {
            try {
                Hotkey(startKey, ObjBindMethod(this, "ToggleMacro"), "On")
                this.hotkeys["StartHotkey"] := startKey
            }
        }

        this.UpdateBindTexts()
    }

    ToggleMacro(*) {
        Macro.Toggle()
        this.UpdateStatus()
    }

    SetStatus(statusKey := "") {
        if statusKey = "" {
            this.ClearStatus()
            return
        }

        if this.statusOverride = statusKey
            return

        this.statusOverride := statusKey
        this.RenderStatus()
    }

    ClearStatus(*) {
        if this.statusOverride = ""
            return

        this.statusOverride := ""
        this.RenderStatus()
    }

    RenderStatus() {
        global Macro

        if !IsObject(Macro)
            return

        if this.statusOverride != ""
            newText := this.GetStatusText(this.statusOverride)
        else if Macro.active
            newText := Lang.Get("running")
        else
            newText := Lang.Get("paused")

        if this.statusText.Text != newText
            this.statusText.Text := newText
    }

    GetStatusText(statusKey) {
        lang := "EN"

        try lang := Lang.current

        texts := Map(
            "EN", Map(
                "genshin_not_found", "GENSHIN NOT FOUND",
                "genshin_closed", "GENSHIN CLOSED",
                "waiting_for_genshin", "WAITING FOR GENSHIN WINDOW",
                "random_break", "RANDOM BREAK"
            ),
            "RU", Map(
                "genshin_not_found", "GENSHIN НЕ НАЙДЕН",
                "genshin_closed", "GENSHIN ЗАКРЫТ",
                "waiting_for_genshin", "ОЖИДАНИЕ ОКНА GENSHIN",
                "random_break", "СЛУЧАЙНАЯ ПАУЗА"
            ),
            "ZH", Map(
                "genshin_not_found", "未找到 GENSHIN",
                "genshin_closed", "GENSHIN 已关闭",
                "waiting_for_genshin", "等待 GENSHIN 窗口",
                "random_break", "随机暂停"
            )
        )

        if texts.Has(lang) && texts[lang].Has(statusKey)
            return texts[lang][statusKey]

        return statusKey
    }

    UpdateStatus(*) {
        global Macro

        if !IsObject(Macro)
            return

        this.RenderStatus()

        newStartText := Macro.active ? Lang.Get("pause") : Lang.Get("start")

        if this.startBtn.Text != newStartText
            this.startBtn.Text := newStartText

        gameRunning := false

        for _, processName in [
            "GenshinImpact.exe",
            "YuanShen.exe",
            "GenshinImpactCloudGame.exe"
        ] {
            if ProcessExist(processName) {
                gameRunning := true
                break
            }
        }

        newGameText := gameRunning ? Lang.Get("active") : Lang.Get("not_found")

        if this.genshinText.Text != newGameText
            this.genshinText.Text := newGameText
    }

    OpenGitHub(*) {
        Run(this.githubUrl)
    }

    DragWindow(*) {
        PostMessage(
            0xA1,
            2,
            ,
            ,
            "ahk_id " this.gui.Hwnd
        )
    }

    ExitNow(*) {
        this.CancelCapture()
        try Macro.Stop()
        ExitApp()
    }
}