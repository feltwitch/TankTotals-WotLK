
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):NewLocale("TankTotals", "ruRU", false);

if L then

	-- death knight
		L["DK_FLATMIT"] = "Несокрушимость:";

		L["IBF_YELL"] = "НЕЗЫБЛЕМОСТЬ ЛЬДА";
		L["VB_YELL"] = "КРОВЬ ВАМПИРА";
		L["BS_YELL"] = "КОСТЯНОЙ ЩИТ";
		L["UA_YELL"] = "НЕСОКРУШИМАЯ БРОНЯ";

		L["WOTN_YELL"] = "МЁРТВЫЕ ТОЛЬКО ЧТО СПАСЛИ МОЮ НЕ-ЖИЗНЬ! ВОЗДЕРЖИТЕ МЕНЯ ОТ ИСПОЛЬЗОВАНИЯ НЕЗЫБЛЕМОСТИ ЛЬДА!";
		L["WOTN_YELL_ORIG"] = "МЁРТВЫЕ ТОЛЬКО ЧТО СПАСЛИ МОЮ НЕ-ЖИЗНЬ! ВОЗДЕРЖИТЕ МЕНЯ ОТ ИСПОЛЬЗОВАНИЯ НЕЗЫБЛЕМОСТИ ЛЬДА!";

	-- paladin
		L["PALA_FLATMIT"] = "Блокируеться:";

		L["DG_YELL"] = "ДЛАНЬ ЖЕРТВЕННОСТИ";
		L["DP_YELL"] = "СВЯЩЕННЫЙ ЩИТ";
		L["HSALV_YELL"] = "ДЛАНЬ СПАСЕНИЯ";

		L["AD_YELL"] = "РЕВНОСТНЫЙ ЗАЩИТНИК ТОЛЬКО ЧТО СПАС МЕНЯ! ВОСПОЛНИТЕ МОЁ ЗДОРОВЬЕ!";
		L["AD_YELL_ORIG"] = "РЕВНОСТНЫЙ ЗАЩИТНИК ТОЛЬКО ЧТО СПАС МЕНЯ! ВОСПОЛНИТЕ МОЁ ЗДОРОВЬЕ!";

		L["AD_HEALYELL"] = "Я ВЫЛЕЧЕН РЕВНОСТНЫМ ЗАЩИТНИКОМ! ПОДДЕРЖИТЕ МЕНЯ 2 МИНУТЫ!";
		L["AD_HEALYELL_ORIG"] = "Я ВЫЛЕЧЕН РЕВНОСТНЫМ ЗАЩИТНИКОМ! ПОДДЕРЖИТЕ МЕНЯ 2 МИНУТЫ!";

	-- druid
		L["DRUID_FLATMIT"] = "Дикая защита:";

		L["BSKIN_YELL"] = "ДУБОВАЯ КОЖА";
		L["FR_YELL"] = "НЕИСТОВОЕ ВОССТАНОВЛЕНИЕ";
		L["SI_YELL"] = "ИНСТИНКТЫ ВЫЖИВАНИЯ";

	-- warrior
		L["WARR_FLATMIT"] = "Блокируеться:";

		L["SB_YELL"] = "ОТРАЖЕНИЕ ЗАКЛИНАНИЙ";
		L["SW_YELL"] = "СТЕНА ЩИТОВ";
		L["LS_YELL"] = "НИ ШАГУ НАЗАД";

	-- general language
		-- ardent defender & wotn save msgs
		L["SAVE_MSG1"] = "спас вас!";
		L["SAVE_MSG2"] = "Спасено раз:";

                L["NONTANK_MSG"] = "отключён ввиду танконепригодности класса. Используйте окно настроек для включения либо с целью установки поведения по-умолчанию для этого персонажа.";

		L["TITLE_BOSSES"] = "(Боссы)";
		L["TITLE_NORMAL"] = "(vs 80)";

		L["AVOID_HEADING"] = "Избегание:";
		L["MIT_HEADING"] = "Смягчение:";
		L["TOTAL_PDR_HEADING"] = "Общее УУ:";
                L["BLOCK_TOTAL"] = "Block Total:";

		L["EFF_HP_HEADING"] = "Эфф. здоровье:";
		L["EXP_TL_HEADING"] = "Ожидаемое TTL:";

		L["NEH_HEADING"] = "ЭЗ2:";
		L["SURVIVAL_HEADING"] = "Смягчение:";
		L["NEH_LOWER_HEADING"] = "Нижний:";
		L["NEH_UPPER_HEADING"] = "Верхний:";

		L["ALLSPELL_HEADING"] = "Магия:";
		L["BLOCK"] = "Блок:";

                L["NONE"] = "Нет";
                L["DEFAULT"] = "По умолчанию";
                L["LATEST"] = "Последняя битва";
                L["ADDON_DISABLED"] = "деактивирована";

		L["HOLY"] = "Свет";
		L["FIRE"] = "Огонь";
		L["NATURE"] = "Природа";
		L["FROST"] = "Лёд";
		L["SHADOW"] = "Тьма";
		L["ARCANE"] = "Тайная";
		L["UNRESISTIBLE"] = "Прочие";

		L["FIRESTORM"] = "FireStorm";
		L["FROSTFIRE"] = "Ледяной огонь";
		L["FROSTSTORM"] = "FrostStorm";
		L["SHADOWSTORM"] = "ShadowStorm";
		L["SHADOWFROST"] = "ShadowFrost";
		L["SPELLFIRE"] = "SpellFire";

		L["BLEED"] = "Кровотечения";
                L["MELEE"] = "Ближний бой";

		L["BLOCK_CAP"] = "Предел блока:";
		L["CD_ACTIVE"] = " ГОТОВ!";
		L["CD_FADED"] = " НЕГОТОВ!";
		L["CD_ONTARGET"] = " на ";

		L["TAUNT_IMMUNE"] = "ИММУНИТЕТ К TAUNT-ЭФФЕКТУ: ";
		L["TAUNT_MISSED"] = "ПРОМАХ TAUNT-ЭФФЕКТА ";

		L["AD_ACTIVE_HEADING"] = "РЗ активен от:";
		L["AD_TOTAL_HEADING"] = "РЗ поглотил:";

		L["WOTN_ACTIVE_HEADING"] = "ВМ активна от:"
		L["WOTN_TOTAL_HEADING"] = "ВМ поглотила:"

                L["SD_UPTIME_HEADING"] = "ДЗ активна от:";
                L["SD_TOTAL_HEADING"] = "ДЗ поглотила:"

		L["PERFIGHT_REPORT"] = "Отчёт по битве";
		L["PERFIGHT_SAVES"] = "Смертей предотвращенно:";
		L["PERFIGHT_MITIGATED"] = "Урона поглощенно:";
		L["PERFIGHT_UPTIME"] = "Время действия:";

		L["SPEC_ENABLED"] = "Обнаруженна смена спелиазиции; модификация активирована.";
		L["SPEC_DISABLED"] = "Обнаруженна смена спелиазиции; модификация деактивирована.";

		L["UNKNOWN"] = "Неизв.";
		L["REC_SUSPENDED"] = "обнаружено; запись приостановленна.";

                -- NEH combat report
                L["NEH_REPORT"] = "Отчёт смертей";
                L["NEH_LIFESPAN"] = "Время жизни:";
                L["NEH_DAMAGE"] = "Урон:";
                L["NEH_ABSORB"] = "Поглощенно:";
                L["NEH_AVOID"] = "Избегнуто:";
                L["NEH_PERCENT"] = "Отношение:";
                L["NEH_HEALING"] = "Излечение:";

                L["NEH_CLICK"] = "Использовать эти значения для ЭЗ2.";
                L["NEH_CLICKSAVE"] = "Воспользоваться и сохранить.";

                L["NEH_RESET"] = "Сброс данных ЭЗ2 о бое.";
                L["NEH_SAVED"] = "Сегмент данных ЭЗ2 сохранён.";
                L["NEH_DELETED"] = "Сегмент данных ЭЗ2 удалён.";
                L["NEH_ACCEPTED"] = "Новые значения ЭЗ2 приняты.";
                L["NEH_NODATA"] = "Отсутствуют данные ЭЗ2 о бое.";
                L["NEH_NOSPELL"] = "Не найден ID заклинания.";

		L["NEH_CLOSE"] = "Закрыть";
		L["NEH_IMPORT"] = "Загрузить профиль";
		L["NEH_IMPORT_INSTRUCTIONS"] = "TankTotals: записать данные профиля в текстово поле.";
		L["NEH_EXPORT_INSTRUCTIONS"] = "TankTotals: скопировать данные профиля из текстового поля. После ими можно будет обменяться с другими пользователями TankTotals.";

		-- settings menus
		L["SETTINGS_GENERAL"] = "Общие";
		L["SETTINGS_GENERAL_DESC"] = "Вкл/выкл, сбросить, разблокировать, переключение босс/обычный монстр.";

		L["SETTINGS_DAMAGE"] = "Урон от противника";
		L["SETTINGS_DAMAGE_DESC"] = "Установка полного урона ближнего боя противника и относительные величины кровотечений/магических уронов, используемых при вычислении Общего Уменьшения Урона/TTL/Эффективного Здоровья.";

		L["SETTINGS_APPEARANCE"] = "Внешний вид";
		L["SETTINGS_APPEARANCE_DESC"] = "Изменение масштаба, точности, шрифта и отображаемого содержимого.";

		L["SETTINGS_ANNOUNCE"] = "Оповещения";
		L["SETTINGS_ANNOUNCE_DESC"] = "Изменение типов оповещений и каналов для них.";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Вторичный вывод";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "Установка опционального вторичного канала оповещений через LibSink; целью может быть SCT-модификация, в частности: Parrot, MSBT и др.";

		L["SETTINGS_CLASS"] = "Класс";
		L["SETTINGS_CLASS_DESC"] = "Здесь собранны классозависимые опции.";

		L["SETTINGS_GUI"] = "Окно настроек";
		L["SETTINGS_GUI_DESC"] = "Открывает окно настроек.";

		L["SETTINGS_ENABLED"] = "Включенно";
		L["SETTINGS_ENABLED_DESC"] = "Включение/отключение TankTotals";

		L["SETTINGS_ENABLED_SPEC1"] = "Первичная специализация";
		L["SETTINGS_ENABLED_SPEC2"] = "Вторичная специализация";
		L["SETTINGS_ENABLED_PERSPEC_DESC"] = "Следует ли TankTotals автоматически включаться/выключаться при переключении на данную специализацию.";

		L["SETTINGS_STANDALONE"] = "Автономное отображение";
		L["SETTINGS_STANDALONE_DESC"] = "Включить/выключить отображение автономного окна. Во втором случае, окно TankTotals остаётся доступным через DataBroker.";

		L["SETTINGS_BOSSVALUES"] = "Босс";
		L["SETTINGS_BOSSVALUES_DESC"] = "Переключение между обычными противниками и боссами (80/83)";

		L["SETTINGS_POPUP"] = "Показ по наведению курсора";
		L["SETTINGS_POPUP_DESC"] = "Отображение главного экрана только при зависании курсора над заголовком.";

		L["SETTINGS_RESETPOS"] = "Сбросить окна";
		L["SETTINGS_RESETPOS_DESC"] = "Сбрасывает окна TankTotals, приводя к обычному размеру и положению (в центре).";

		L["SETTINGS_DECIMAL"] = "Десятичная точность";
		L["SETTINGS_DECIMAL_DESC"] = "Число значащих разрядов после точки (используются проценты!)";

		L["SETTINGS_HITAMOUNT"] = "Урон ближнего боя";
		L["SETTINGS_HITAMOUNT_DESC"] = "Урон от противника БЕЗ ПОГЛОЩЕНИЙ. Используется при вычислении вклада от смягчений (блок, Несокрушимой брони или Дикой защиты), влияющих на Ожидаемое TTL и Общее УУ. Установка в 0 отключает обработку этих пунктов.";

		L["SETTINGS_PARRYHASTE"] = "Учесть ускорение при парировании";
		L["SETTINGS_PARRYHASTE_DESC"] = "Учитывать/нет ускорение от парирования при расчёте Ожидаемого TTL.";

		L["SETTINGS_TTL_CONTINUOUS"] = "Распределённый урон";
		L["SETTINGS_TTL_CONTINUOUS_DESC"] = "Включение это й опции представляет входящий урон как равномерно распредлённый на промежутке между ударами противника; иначе считаеться, что урон наноситься только в моменты ударов.";

		L["SETTINGS_SHOWNEH"] = "Отображать ЭЗ2";
		L["SETTINGS_SHOWNEH_DESC"] = "Показ значений ЭЗ2, т.е. эффективное здоровье, рассчитыванием на основании отношений урона ближнего боя к эффектам кровотечений и магии.";

		L["SETTINGS_RECORD_NEHXY"] = "Запись урона";
		L["SETTINGS_RECORD_NEHXY_DESC"] = "Вкл/выкл автоматической записи источников урона в бою. По его завершению вам будет предложено использовать полученные отношения для дальнейших расчётов ЭЗ2.";

		L["SETTINGS_NEH_INCLUDEAVOID"] = "Включить избегание";
		L["SETTINGS_NEH_INCLUDEAVOID_DESC"] = "Включение в расчёт ЭЗ2/исключение из него избеганий (уклонения, парирования, промахи и т.д.). Изменение этой опции пока активен записыванный отчёт об уроне пересчитает ЭЗ2. Это сильно повлияет на смягчение по ЭЗ2 от атак ближнего боя.";

		L["SETTINGS_AD_STOP_NEHREC"] = "Остановиться по срабатыванию РЗ-а";
		L["SETTINGS_AD_STOP_NEHREC_DESC"] = "Останавлиавть ли анализ урона когда срабатывает Ревностный защитник, или же продолжать, пока вы действительно не сляжете.";

		L["SETTINGS_NEH_CHOOSEDATA"] = "Источник данных ЭЗ2";
		L["SETTINGS_NEH_CHOOSEDATA_DESC"] = "Выбор данных для вычисления отношений урон ЭЗ2, нижнией и верхней границы. Выберите \"NONE\" для сброса данных, \"Latest Fight\" для использования наиболее свежих данных, если они существуют.";

		L["SETTINGS_NEH_SAVEDATA"] = "Сохранить сегмент данных";
		L["SETTINGS_NEH_SAVEDATA_DESC"] = "Сохраняет текущий сегмент данных ЭЗ2.";

		L["SETTINGS_NEH_RELOAD"] = "Перезагрузить сегмент данных";
		L["SETTINGS_NEH_RELOAD_DESC"] = "Перезагружает текущий сегмент данных ЭЗ2.";

		L["SETTINGS_NEH_RELOAD_PROFILE"] = "перезагрузить профиль";
		L["SETTINGS_NEH_RELOAD_PROFILE_DESC"] = "Перезагрузить текущий профиль ЭЗ2.";

		L["SETTINGS_NEH_DELETEDATA"] = "Удалить сегмент данных";
		L["SETTINGS_NEH_DELETEDATA_DESC"] = "Полностью удалить текущий сегмент данных ЭЗ2.";

		L["SETTINGS_NEH_PRINTREPORT"] = "Вывод отчёта";
		L["SETTINGS_NEH_PRINTREPORT_DESC"] = "Если запись урона активна, будет заново выведен отчёт.";

		L["SETTINGS_RESET_NEH_SLIDERS"] = "Сброс профиля ЭЗ2";
		L["SETTINGS_RESET_NEH_SLIDERS_DESC"] = "Сбрасывает соотношения для ЭЗ2 на значения по-умолчанию.";

		L["SETTINGS_NEH_PERCENTPROFILES"] = "Профиль ЭЗ2";
		L["SETTINGS_NEH_PERCENTPROFILES_DESC"] = "Выбор профиля ЭЗ2.";

                L["SETTINGS_SAVE_NEH_SLIDERS"] = "Сохранить текущий профиль ЭЗ2:"
                L["SETTINGS_SAVE_NEH_SLIDERS_DESC"] = "Введите имя профиля и нажмите ENTER для сохранения текущих соотношений."

                L["SETTINGS_DELETE_NEH_SLIDERS"] = "Удалить профиль ЭЗ2"
                L["SETTINGS_DELETE_NEH_SLIDERS_DESC"] = "Удаление текущего профиля ЭЗ2."

		L["SETTINGS_RESET_NEH"] = "Сброс сохранённых данных";
		L["SETTINGS_RESET_NEH_DESC"] = "Отмена сохранения данных ЭЗ2. Не касаеться последнего результата.";

		L["SETTINGS_NEH_SLIDERS"] = "Профиль ЭЗ2";
		L["SETTINGS_NEH_SLIDERS_DESC"] = "Полосы прокрутки позволяют соотнести урон от разных источником.";

		L["SETTINGS_NEH_IMPEXP_HEADING"] = "Импорт/Экспорт";
		L["SETTINGS_NEH_CUSTOMSPELLS_HEADING"] = "Настройка школ урона";
		L["SETTINGS_NEH_SLIDERS_HEADING"] = "Отношения уронов для ЭЗ2";

		L["SETTINGS_NEH_CUSTOM_SCHOOL"] = "Школа";
		L["SETTINGS_NEH_CUSTOM_SCHOOL_DESC"] = "Выберите школу урона, с которой будет ассоциирован этот ID навыка во время записи данных для ЭЗ2. Кровотечения - *все* физические атаки, игнорирующие броню.";

		L["SETTINGS_NEH_CUSTOM_SPELL"] = "ID навыка";
		L["SETTINGS_NEH_CUSTOM_SPELL_DESC"] = "Введите ID настраиваемого навыка. Он будет учтён по нажатию ENTER; перед этим, пожалуйста, правильно выберите школу урона.";

		L["SETTINGS_NEH_PRINT_SPELLS"] = "Вывод настроенных навыков";
		L["SETTINGS_NEH_PRINT_SPELLS_DESC"] = "Вывод списка пар навык-школа.";

		L["SETTINGS_NEH_IMPORT"] = "Импорт набора профилей ЭЗ2";
		L["SETTINGS_NEH_IMPORT_DESC"] = "Импорт набора профилей ЭЗ2 из внешнего источника.";

		L["SETTINGS_NEH_EXPORT"] = "Экспорт набора профилей ЭЗ2";
		L["SETTINGS_NEH_EXPORT_DESC"] = "Экспорт набора профилей ЭЗ2 из внешнего источника.";

		L["SETTINGS_MELEE_DESC"] = "Вычисленно на основе других значений ЭЗ2; исключительно для чтения.";
		L["SETTINGS_BLEED_DESC"] = "Устанавливает долю урона от кровопусканий и других игнорирующих броню эффектов.";
		L["SETTINGS_NEHXY_PERC_DESC"] = "Устанавливает долю урона от этой школы.";

		L["SETTINGS_TTL_OPTIONS"] = "Опции TTL";
		L["SETTINGS_TTL_OPTIONS_DESC"] = "Настройка урона ближнего боя, ускорения при парировании и отношений источников урона для рассчёта TTL и Общего УУ.";

		L["SETTINGS_SCALE"] = "Масштаб";
		L["SETTINGS_SCALE_DESC"] = "Устанавливает мастштаб окна TankTotals.";

		L["SETTINGS_FONT"] = "Шрифт";
		L["SETTINGS_FONT_DESC"] = "Выбор шрифта, используемого TankTotals.";

		L["SETTINGS_FONTOUTLINE"] = "Начертание шрифта";
		L["SETTINGS_FONTOUTLINE_DESC"] = "Устанавливает толщину линий.";

		L["SETTINGS_GROWDIR"] = "Направление появления";
		L["SETTINGS_GROWDIR_DESC"] = "Устанавливает положение главного окна.";

		L["SETTINGS_RES"] = "Показ сопротивлений";
		L["SETTINGS_RES_DESC"] = "Вкл/выкл показа гарантированного и среднего смягчения против различных школ магии, в случае важности.";

		L["SETTINGS_COOLDOWNS"] = "Перезарядки";
		L["SETTINGS_COOLDOWNS_DESC"] = "Вкл/выкл оповещений о перезарядке танковых навыков.";

		L["SETTINGS_TAUNTMISS"] = "Промахи taunt-навыков.";
		L["SETTINGS_TAUNTMISS_DESC"] = "Вкл/выкл оповещений при промахах или наличия иммунитета к taunt-навыкам у цели.";

		L["SETTINGS_SPECIALTAUNT"] = "Промахи AoE taunt-навыков";
		L["SETTINGS_SPECIALTAUNT_DESC"] = "Учёт AoE taunt-навыков в оповещениях; а именно: Вызывающий рёв, Вызывающий крик, и Праведная защита.";

		L["SETTINGS_TAUNTMISS_SOUND"] = "Предупреждения о промахе taunt-навыков";
		L["SETTINGS_TAUNTMISS_SOUND_DESC"] = "Выбор звукового сигнала, проигрываемого при промахе taunt-навыка, или None для отключения этой возможности.";

		L["SETTINGS_CHANNEL"] = "Канал оповещений";
		L["SETTINGS_CHANNEL_DESC"] = "Выбор канала общения, куда будут отправляться оповещения.";

		L["SETTINGS_INSTANCE"] = "Только в зонах-инстанс";
		L["SETTINGS_INSTANCE_DESC"] = "Оповещать, только пребывая в зонах-инстанс";

		L["SETTINGS_STANCE"] = "Только в стойке";
		L["SETTINGS_STANCE_DESC"] = "Оповещать только при активной стойке; подразумеваются Власть льда, Формы медведя, Праведное неистовство и Защитная стойка.";

		L["SETTINGS_PVP"] = "Включить в PvP";
		L["SETTINGS_PVP_DESC"] = "Оповещать на ПБ и арене.";

		L["SETTINGS_HOP"] = "Отключение Длани защиты";
		L["SETTINGS_HOP_DESC"] = "Вкл/выкл автоматического снятия эффекта от Длани защиты.";

		L["SETTINGS_WOTN_ANNOUNCE"] = "Оповещения спасений ВМ";
		L["SETTINGS_WOTN_ANNOUNCE_DESC"] = "Вкл/выкл оповещений ВМ.";

		L["SETTINGS_WOTN_TEXT"] = "Текст оповещений ВМ";
		L["SETTINGS_WOTN_TEXT_DESC"] = "Устанавливает текст оповещений при срабатывании ВМ.";

		L["SETTINGS_AD_ANNOUNCE"] = "Оповещать спасения РЗ-ом";
		L["SETTINGS_AD_ANNOUNCE_DESC"] = "Вкл/выкл оповещений предотвращений РЗ-ом смертельных ударов.";

		L["SETTINGS_AD_TEXT"] = "Текст оповещений спасения РЗ-ом";
		L["SETTINGS_AD_TEXT_DESC"] = "Устанавливает текст оповещений предотвращений РЗ-ом смертельных ударов.";

		L["SETTINGS_AD_ANNOUNCEHEAL"] = "Оповещать излечения РЗ-а";
		L["SETTINGS_AD_ANNOUNCEHEAL_DESC"] = "Вкл/выкл оповещений при срабатывании лечения РЗ-а.";

		L["SETTINGS_AD_HEALTEXT"] = "Текст оповещений излечения РЗ-а";
		L["SETTINGS_AD_HEALTEXT_DESC"] = "Устанавливает текст оповещений при срабатывании лечения РЗ-а.";

		L["SETTINGS_AD_CDBAR"] = "Показывать полосу перезарядки РЗ-а";
		L["SETTINGS_AD_CDBAR_DESC"] = "Включить полосу, отображающую перезарядку РЗ-а перед возможным повоторным спасением.";

		L["SETTINGS_CDBAR_TEXTURE"] = "Текстура полосы перезарядки РЗ-а";
		L["SETTINGS_CDBAR_TEXTURE_DESC"] = "Устанавливает текстуру полосы перезарядки РЗ-а.";

		L["SETTINGS_ADHEAL_EHTTL"] = "Излечения РЗ-а в ЭЗ/TTL";
		L["SETTINGS_ADHEAL_EHTTL_DESC"] = "Учитывать излечения РЗ-а при расчёте ЭЗ, ЭЗ2 и Ожидаемого TTL.";

		L["SETTINGS_WOTN_CDBAR"] = "Показ полосы перезарядки ВМ";
		L["SETTINGS_WOTN_CDBAR_DESC"] = "Включение полосы перезарядки ВМ, отображающей, коль скоро Воля мёртвых может сработать снова.";

		L["SETTINGS_WOTN_EHTTL"] = "ВМ в ЭЗ/TTL";
		L["SETTINGS_WOTN_EHTTL_DESC"] = "Учитывать смягчение однго удара волею мёртвых при расчёте ЭЗ (но не ЭЗ2) и Ожидаемого TTL";

		L["SETTINGS_STATS_RESET"] = "Сброс статистики";
		L["SETTINGS_STATS_RESET_DESC"] = "Сброс статистик боя.";

		L["SETTINGS_PERFIGHT"] = "Обособленная статистика";
		L["SETTINGS_PERFIGHT_DESC"] = "Включает удаление данных при начале боя и краткий отчёт по завершению; при отключенной опции данные будут аккумулироваться от всех битв..";
end
