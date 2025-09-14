local AceLocale = LibStub("AceLocale-3.0")
local L = AceLocale:NewLocale("MythicPlusKeyAnnouncer", "frFR")
if not L then return end

L["Mythic Plus Key Announcer"] = "Оповещатель о ключах Mythic Plus"
L["Show popup on join"] = "Показывать всплывающее окно при вступлении"
L["Message Color"] = "Цвет сообщения"
L["Announcement Channel"] = "Канал оповещений"
L["Whisper (requires target)"] = "Шёпот (требуется цель)"
L["Channel (requires channel number)"] = "Канал (требуется номер канала)"
L["Target"] = "Цель"
L["Configure how group announcements are sent and displayed."] = "Настройка отправки и отображения групповых оповещений."
L["Say"] = "Сказать"
L["Party"] = "Группа"
L["Raid"] = "Рейд"
L["Guild"] = "Гильдия"
L["Instance"] = "Подземелье"
L["Yell"] = "Крик"
L["Test the configured announcement and popup."] = "Тестирование настроенного оповещения и всплывающего окна."
L["Show a popup window when you join a Mythic+ group."] = "Показывать всплывающее окно при вступлении в группу M+."
L["Set the color for the group filled chat message."] = "Установить цвет для сообщения в чате о заполнении группы."
L["Test Announcement"] = "Тестовое оповещение"
L["Joined Mythic+ Group"] = "Присоединился к группе M+"
L["No whisper target set; sending to SAY."] = "Цель для шёпота не установлена; отправка в канал 'СКАЗАТЬ'."
L["Invalid channel number; sending to SAY."] = "Недопустимый номер канала; отправка в канал 'СКАЗАТЬ'."
L["Mythic Plus Key Group:"] = "Группа с ключом M+:"
L["No recent group found."] = "Недавних групп не найдено."
L["Re-sent last announcement."] = "Повторно отправлено последнее оповещение."
L["No plain announcement available to resend."] = "Нет простого оповещения, доступного для повторной отправки."
L["Announcement channel set to %s"] = "Канал оповещений установлен на %s"

return L
