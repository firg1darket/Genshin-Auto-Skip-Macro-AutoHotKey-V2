#Requires AutoHotkey v2.0

class Lang {
    static current := "EN"

    static Init() {
        global Config

        if IsObject(Config) && Config.Has("Language")
            this.current := Config["Language"]
        else if IsObject(Config)
            Config["Language"] := "EN"

        if !this.IsValid(this.current)
            this.current := "EN"
    }

    static IsValid(language) {
        return language = "EN" || language = "RU" || language = "ZH"
    }

    static Set(language) {
        global Config

        if !this.IsValid(language)
            language := "EN"

        this.current := language

        if IsObject(Config)
            Config["Language"] := language
    }

    static Next() {
        if this.current = "EN"
            this.Set("RU")
        else if this.current = "RU"
            this.Set("ZH")
        else
            this.Set("EN")

        return this.current
    }

    static Get(key) {
        static texts := Map(
            "EN", Map(
                "window_title", "Genshin Auto-Skip Dialogue",
                "title", "GENSHIN AUTO-SKIP DIALOGUE",
                "subtitle", "Automatic dialogue detection and skipping",
                "tab_main", "MAIN",
                "tab_settings", "SETTINGS",
                "tab_information", "INFORMATION",
                "stats_heading", "STATUS INFORMATION",
                "stats_sub", "The macro presses the dialogue key only after detection.",
                "macro_status", "MACRO STATUS",
                "game_status", "GAME STATUS",
                "start_stop", "START / PAUSE",
                "key_clicking", "DIALOGUE KEY",
                "controls", "CONTROLS",
                "controls_sub", "Start, pause or configure the macro.",
                "start", "START",
                "pause", "PAUSE",
                "settings", "SETTINGS",
                "footer", "automatic dialogue skipping",
                "key_bindings", "KEY BINDINGS",
                "settings_sub", "Click a binding and press the key you want to assign.",
                "dialogue_key", "DIALOGUE KEY",
                "start_pause", "START / PAUSE",
                "capture_default", "Esc cancels key capture. Save settings to apply changes.",
                "capture_key", "PRESS A KEY...",
                "capture_now", "Press a key now  •  Esc cancels",
                "capture_cancelled", "Key rebinding cancelled",
                "binding_changed", "Binding changed. Click SAVE SETTINGS to apply.",
                "saved", "Settings saved successfully",
                "back", "BACK",
                "save", "SAVE SETTINGS",
                "info_heading", "INFORMATION",
                "waiting_for_genshin", "WAITING FOR GENSHIN",
                "info_sub", "Genshin Auto-Skip Dialogue Macro",
                "how_works", "HOW IT WORKS",
                "info_1", "• Detects dialogue using pixel checks. (thanks 1hubert)",
                "info_2", "• If pixels do not match, checks dialogue images.",
                "info_3", "• Supports Russian, English and Chinese UI.",
                "info_4", "• Presses the selected key only after dialogue detection.",
                "info_5", "• Genshin Impact must be running and active.",
                "credits", "CREDITS",
                "credits_sub", "Based primarily on an existing open-source project",
                "based_on", "Original project",
                "original_author", "Original author",
                "fork_note", "This project is an independent AutoHotkey adaptation.",
                "open_github", "OPEN GITHUB",
                "language", "LANGUAGE: EN",
                "back_main", "BACK TO MAIN",
                "running", "RUNNING",
                "paused", "PAUSED",
                "active", "ACTIVE",
                "not_focused", "RUNNING / NOT FOCUSED",
                "not_found", "NOT FOUND",
                "checking", "CHECKING..."
            ),

            "RU", Map(
                "window_title", "Скип Диалогов Genshin",
                "title", "GENSHIN СКИП ДИАЛОГОВ",
                "subtitle", "Hoyoplay пошли нах, банить людей за макросы тупизм",
                "tab_main", "ГЛАВНАЯ",
                "tab_settings", "НАСТРОЙКИ",
                "tab_information", "ИНФОРМАЦИЯ",
                "stats_heading", "ИНФОРМАЦИЯ О СТАТУСЕ",
                "stats_sub", "Макрос нажимает клавишу как будет обнаружен диалоговое окно",
                "macro_status", "СТАТУС МАКРОСА",
                "game_status", "СТАТУС ИГРЫ",
                "start_stop", "ЗАПУСК / ПАУЗА",
                "key_clicking", "КЛАВИША",
                
                "controls", "УПРАВЛЕНИЕ",
                "controls_sub", "Запускайте, ставьте на паузу или настройте макрос.",
                "start", "ЗАПУСК",
                "pause", "ПАУЗА",
                "settings", "НАСТРОЙКИ",
                "footer", "автоматический пропуск диалогов",
                "key_bindings", "НАСТРОЙКА КЛАВИШ",
                "settings_sub", "Нажмите на бинд, затем нажмите нужную клавишу.",
                "dialogue_key", "КЛАВИША ДИАЛОГА",
                "start_pause", "ЗАПУСК / ПАУЗА",
                "capture_default", "Esc отменяет выбор. Сохраните настройки для применения.",
                "capture_key", "НАЖМИТЕ КЛАВИШУ...",
                "capture_now", "Нажмите клавишу  |  Esc отмена",
                "capture_cancelled", "Изменение бинда отменено",
                "binding_changed", "Бинд изменён. Нажмите СОХРАНИТЬ для применения.",
                "saved", "Настройки успешно сохранены",
                "back", "НАЗАД",
                "save", "СОХРАНИТЬ",
                "info_heading", "ИНФОРМАЦИЯ",
                "info_sub", "Макрос автоматического пропуска диалогов",
                "how_works", "КАК ЭТО РАБОТАЕТ",
                "info_1", "• Проверяет наличие диалога по пикселям (спасибо 1hubert)",
                "info_2", "• Если пиксели не совпали, ищет диалог по изображению.",
                "info_3", "• мамут рахал всё знает",
                "info_4", "• Нажимает выбранную клавишу только после обнаружения диалога.",
                "info_5", "• Genshin Impact должен быть запущен и активен.",
                "credits", "БЛАГОДАРНОСТИ",
                "credits_sub", "Проект в значительной степени основан на open-source проекте",
                "based_on", "Исходный проект",
                "original_author", "Автор оригинала",
                "fork_note", "Этот проект является независимой адаптацией на AutoHotkey.",
                "open_github", "ОТКРЫТЬ GITHUB",
                "language", "ЯЗЫК: RU",
                "back_main", "НАЗАД",
                "running", "РАБОТАЕТ",
                "paused", "НА ПАУЗЕ",
                "active", "АКТИВЕН",
                "not_focused", "ЗАПУЩЕН / НЕ В ФОКУСЕ",
                "not_found", "НЕ НАЙДЕН",
                "checking", "ПРОВЕРКА...",
                "waiting_for_genshin", "ОЖИДАНИЕ GENSHIN",
            ),

            "ZH", Map(
                "window_title", "原神自动跳过对话",
                "title", "原神 自动跳过对话",
                "subtitle", "自动检测并跳过对话",
                "tab_main", "主页",
                "tab_settings", "设置",
                "tab_information", "信息",
                "stats_heading", "状态信息",
                "stats_sub", "只有检测到对话后才会按下按键。",
                "macro_status", "宏状态",
                "game_status", "游戏状态",
                "start_stop", "开始 / 暂停",
                "key_clicking", "对话按键",
                "controls", "控制",
                "controls_sub", "启动、暂停或配置宏。",
                "start", "开始",
                "pause", "暂停",
                "settings", "设置",
                "footer", "自动跳过对话",
                "key_bindings", "按键设置",
                
                "settings_sub", "点击绑定，然后按下你想使用的按键。",
                "dialogue_key", "对话按键",
                "start_pause", "开始 / 暂停",
                "capture_default", "按 Esc 取消。保存设置以应用更改。",
                "capture_key", "请按一个按键...",
                "capture_now", "请按一个按键  •  Esc 取消",
                "capture_cancelled", "已取消修改按键",
                "binding_changed", "按键已修改。点击保存设置应用。",
                "saved", "设置已成功保存",
                "back", "返回",
                "save", "保存设置",
                "info_heading", "信息",
                "info_sub", "原神自动跳过对话宏",
                "how_works", "工作原理",
                "info_1", "• 使用像素检测对话。",
                "info_2", "• 如果像素不匹配，则搜索对话图像。",
                "info_3", "• 支持俄语、英语和中文界面。",
                "info_4", "• 只有检测成功后才会按下按键。",
                "info_5", "• 原神必须正在运行并处于活动状态。",
                "credits", "鸣谢",
                "credits_sub", "本项目主要参考了一个开源项目",
                "based_on", "原始项目",
                "original_author", "原作者",
                "fork_note", "本项目是独立的 AutoHotkey 改编版本。",
                "open_github", "打开 GITHUB",
                "language", "语言: 中文",
                "back_main", "返回主页",
                "running", "运行中",
                "paused", "已暂停",
                "active", "活动中",
                "not_focused", "正在运行 / 未聚焦",
                "not_found", "未找到",
                "checking", "检查中...",
                "waiting_for_genshin", "等待原神",
            )
        )

        if !texts.Has(this.current)
            this.current := "EN"

        if !texts[this.current].Has(key)
            return key

        return texts[this.current][key]
    }
}