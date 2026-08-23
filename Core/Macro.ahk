#Requires AutoHotkey v2.0

class MacroController {
    __New() {
        this.active := false
        this.running := true
        this.nextPress := 0
        this.lastBreak := 0
        this.breakUntil := 0
        this.noDialogueCycles := 0
    }

    Start() {
        global App

        if !IsGenshinRunning() {
            this.active := false
            ReleaseMacroKey()
            App.SetStatus("genshin_not_found")
            return
        }

        this.active := true
        this.nextPress := A_TickCount
        this.breakUntil := 0
        this.noDialogueCycles := 0
        App.ClearStatus()
    }

    Pause() {
        global App
        this.active := false
        this.breakUntil := 0
        this.noDialogueCycles := 0
        ReleaseMacroKey()
        App.ClearStatus()
    }

    Toggle() {
        if this.active
            this.Pause()
        else
            this.Start()
    }

    Stop() {
        this.active := false
        this.running := false
        this.breakUntil := 0
        ReleaseMacroKey()
        SetTimer(MacroTick, 0)
        try SaveConfig()
        ExitApp()
    }

    Tick() {
        global Config, App
        if !this.running || !this.active
            return

        if !IsGenshinRunning() {
            this.active := false
            this.breakUntil := 0
            ReleaseMacroKey()
            App.SetStatus("genshin_closed")
            return
        }

        if !IsGenshinActive() {
            App.SetStatus("waiting_for_genshin")
            return
        }

        if (this.breakUntil > A_TickCount)
            return

        App.ClearStatus()
        if !DialogueDetected() {
            this.noDialogueCycles += 1
            if (this.noDialogueCycles > 15) {
                Sleep(100)
                this.noDialogueCycles := 0
            } else {
                this.nextPress := A_TickCount
            }
            return
        }

        this.noDialogueCycles := 0

        if (A_TickCount - this.lastBreak >= Config["BreakCooldown"] && Random() < Config["BreakChance"]) {
            pauseMs := Random(Config["BreakMin"], Config["BreakMax"])
            this.lastBreak := A_TickCount
            this.breakUntil := A_TickCount + pauseMs
            App.SetStatus("random_break")
            return
        }

        if (A_TickCount >= this.nextPress) {
            PressMacroKey()
            interval := Random(Config["IntervalMin"], Config["IntervalMax"])
            if (Random() < Config["LongIntervalChance"])
                interval := Round(interval * 1.5)
            this.nextPress := A_TickCount + interval
        }
    }
}

global Macro := MacroController()

MacroTick() {
    global Macro
    Macro.Tick()
}

SetTimer(MacroTick, 20)
