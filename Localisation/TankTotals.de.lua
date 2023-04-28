
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):NewLocale("TankTotals", "deDE", false);

if L then

	-- death knight
		-- L["DK_FLATMIT"] = "Undurchdring:";

		L["IBF_YELL"] = strupper(S["Icebound Fortitude"]);
		L["UA_YELL"] = strupper(S["Unbreakable Armor"]);
		L["VB_YELL"] = strupper(S["Vampiric Blood"]);
		L["BS_YELL"] = strupper(S["Bone Shield"]);

		L["WOTN_YELL"] = strupper(S["Will of the Necropolis"]).." MEIN LEBEN GERETTET! NICHT ZWINGEN MICH "..strupper(S["Icebound Fortitude"]).." ZU VERWENDEN!";
		L["WOTN_YELL_ORIG"] = strupper(S["Will of the Necropolis"]).." MEIN LEBEN GERETTET! NICHT ZWINGEN MICH "..strupper(S["Icebound Fortitude"]).." ZU VERWENDEN!";

	-- paladin
		L["PALA_FLATMIT"] = "Blockwert:";

		L["DG_YELL"] = strupper(S["Divine Guardian"]);
		L["DP_YELL"] = strupper(S["Divine Protection"]);
		L["HSALV_YELL"] = strupper(S["Hand of Salvation"]);

		L["AD_YELL"] = strupper(S["Ardent Defender"]).." MEIN LEBEN GERETTET! NICHT ZWINGEN MICH "..strupper(S["Lay on Hands"]).." ZU VERWENDEN!";
		L["AD_YELL_ORIG"] = strupper(S["Ardent Defender"]).." MEIN LEBEN GERETTET! NICHT ZWINGEN MICH "..strupper(S["Lay on Hands"]).." ZU VERWENDEN!";

		L["AD_HEALYELL"] = strupper(S["Ardent Defender"]).." HAT MICH GEHEILT! HALTEN SIE MICH AM LEBEN FÜR 2 MINUTEN!";
		L["AD_HEALYELL_ORIG"] = strupper(S["Ardent Defender"]).." HAT MICH GEHEILT! HALTEN SIE MICH AM LEBEN FÜR 2 MINUTEN!";

	-- druid
		L["DRUID_FLATMIT"] = "Wilde Ver:";

		L["BSKIN_YELL"] = strupper(S["Barkskin"]);
		L["FR_YELL"] = strupper(S["Frenzied Regeneration"]);
		L["SI_YELL"] = strupper(S["Survival Instincts"]);

	-- warrior
		L["WARR_FLATMIT"] = "Blockwert:";

		L["SB_YELL"] = strupper(S["Shield Block"]);
		L["SW_YELL"] = strupper(S["Shield Wall"]);
		L["LS_YELL"] = strupper(S["Last Stand"]);

	-- general language
		-- ardent defender & wotn save msgs
		L["SAVE_MSG1"] = "dich gerettet!";
		L["SAVE_MSG2"] = "Gesamtzahl der Rettungen:";

                L["NONTANK_MSG"] = "disabled due to non-tanking class.";

		L["TITLE_BOSSES"] = "(Boss)";
		L["TITLE_NORMAL"] = "(80)";

		L["AVOID_HEADING"] = "Vermeidung:";
		L["MIT_HEADING"] = "Milderung:";
		L["TOTAL_PDR_HEADING"] = "Insgesamt:";
                L["BLOCK_TOTAL"] = "Blockgesamt:";

		L["EFF_HP_HEADING"] = "Effektiv Leben:";
		L["EXP_TL_HEADING"] = "Lebensdauer:";

		L["NEH_HEADING"] = "EH2:";
		L["SURVIVAL_HEADING"] = "Mitigation:";
		L["NEH_LOWER_HEADING"] = "Lower:";
		L["NEH_UPPER_HEADING"] = "Upper:";

		L["ALLSPELL_HEADING"] = "Zauber:";
		L["BLOCK"] = "Block:";

                L["NONE"] = "NONE";
                L["DEFAULT"] = "DEFAULT";
                L["LATEST"] = "LATEST FIGHT";
                L["ADDON_DISABLED"] = "Disabled";

		L["HOLY"] = "Heilig";
		L["FIRE"] = "Feuer";
		L["NATURE"] = "Natur";
		L["FROST"] = "Frost";
		L["SHADOW"] = "Schatten";
		L["ARCANE"] = "Arcane";
		L["UNRESISTIBLE"] = "Unresistible";

		L["FIRESTORM"] = "FireStorm";
		L["FROSTFIRE"] = "FrostFire";
		L["FROSTSTORM"] = "FrostStorm";
		L["SHADOWSTORM"] = "ShadowStorm";
		L["SHADOWFROST"] = "ShadowFrost";
		L["SPELLFIRE"] = "SpellFire";

		L["BLEED"] = "Blutung";
                L["MELEE"] = "Melee";

		L["BLOCK_CAP"] = "Block Grenze:";
		L["CD_ACTIVE"] = " ist AKTIV!";
		L["CD_FADED"] = " ist INAKTIV!";
		L["CD_ONTARGET"] = " auf ";

		L["TAUNT_IMMUNE"] = "SPOTT-IMMUN: ";
		L["TAUNT_MISSED"] = "SPOTT VERPASST ";

		L["AD_ACTIVE_HEADING"] = "UV Grenze:";
		L["AD_TOTAL_HEADING"] = "UV Kürzung:";

		L["WOTN_ACTIVE_HEADING"] = "WN Grenze:"
		L["WOTN_TOTAL_HEADING"] = "WN Kürzung:"

                L["SD_UPTIME_HEADING"] = "WV Betriebszeit:";
                L["SD_TOTAL_HEADING"] = "WV Kürzung:"

		L["PERFIGHT_REPORT"] = "Bericht";
		L["PERFIGHT_SAVES"] = "Gesamtzahl der Rettungen:";
		L["PERFIGHT_MITIGATED"] = "Gesamtbetrag gemildert:";
		L["PERFIGHT_UPTIME"] = " Betriebszeit:";

		L["SPEC_ENABLED"] = "spec change detected; addon enabled.";
		L["SPEC_DISABLED"] = "spec change detected; addon disabled.";

		L["UNKNOWN"] = "Unknown";
		L["REC_SUSPENDED"] = "detected; logging suspended.";

                -- NEH combat report
                L["NEH_REPORT"] = "Death Report";
                L["NEH_LIFESPAN"] = "Lifespan";
                L["NEH_DAMAGE"] = "Damage:";
                L["NEH_ABSORB"] = "Absorbed:";
                L["NEH_AVOID"] = "Avoided:";
                L["NEH_PERCENT"] = "Percent:";
                L["NEH_HEALING"] = "Healing:";

                L["NEH_CLICK"] = "Use these values for NEH";
                L["NEH_CLICKSAVE"] = "Use and Save";

                L["NEH_RESET"] = "EH2 combat data reset.";
                L["NEH_SAVED"] = "EH2 data segment saved.";
                L["NEH_DELETED"] = "EH2 data segment deleted.";
                L["NEH_ACCEPTED"] = "New EH2 values accepted.";
                L["NEH_NODATA"] = "No current EH2 combat data found.";
                L["NEH_NOSPELL"] = "no such spell ID.";

		L["NEH_CLOSE"] = "Close";
		L["NEH_IMPORT"] = "Import Profiles";
		L["NEH_IMPORT_INSTRUCTIONS"] = "TankTotals: paste the profile set into the text box.";
		L["NEH_EXPORT_INSTRUCTIONS"] = "TankTotals: copy the profile set from the text box. It can then be exchanged with other TankTotals users.";

		-- settings menus
		L["SETTINGS_GENERAL"] = "Allgemeine";
		L["SETTINGS_GENERAL_DESC"] = "mit diese Optionen können Sie das Addon aktivieren, deaktivieren oder entsperren. Können Sie auch zwischen Normal- und Boss-Werte wechseln.";

		L["SETTINGS_DAMAGE"] = "Mob Damage";
		L["SETTINGS_DAMAGE_DESC"] = "set the values of unmitigated mob melee and relative percentages of bleed/magic damage sources, used in TotalDR/TTL/NEH calculations";

		L["SETTINGS_APPEARANCE"] = "Aussehen";
		L["SETTINGS_APPEARANCE_DESC"] = "mit diesen Optionen können Sie die Skala, Genauigkeit, Schriftart und den Inhalt des Displays ändern";

		L["SETTINGS_ANNOUNCE"] = "Ankündigungen";
		L["SETTINGS_ANNOUNCE_DESC"] = "mit diesen Optionen können Sie die Art der Veranstaltungen wird noch bekannt gegeben, und der Kanal, in dem sie gesendet werden";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Secondary Output";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "sets an optional secondary announcement channel via LibSink; target can be an SCT addon such as Parrot, MSBT, etc";

		L["SETTINGS_CLASS"] = "Klasse";
		L["SETTINGS_CLASS_DESC"] = "beliebig Klasse-spezifische Einstellungen ändern";

		L["SETTINGS_GUI"] = "GUI-Konfiguration";
		L["SETTINGS_GUI_DESC"] = "diese Option öffnet die GUI-Konfiguration";

		L["SETTINGS_ENABLED"] = "Aktiviert";
		L["SETTINGS_ENABLED_DESC"] = "aktiviert oder deaktiviert TankTotals";

		L["SETTINGS_ENABLED_SPEC1"] = "Primary Spec";
		L["SETTINGS_ENABLED_SPEC2"] = "Secondary Spec";
		L["SETTINGS_ENABLED_PERSPEC_DESC"] = "indicates whether TankTotals should automatically en/disable itself when the player switches to this spec";

		L["SETTINGS_STANDALONE"] = "Standalone Display";
		L["SETTINGS_STANDALONE_DESC"] = "enable or disable the display of the standalone window. If disabled, the TankTotals window will still be accessible via its DataBroker feed.";

		L["SETTINGS_BOSSVALUES"] = "Bosswerte";
		L["SETTINGS_BOSSVALUES_DESC"] = "umschalt zwischen Standard-und Boss-Werte (80-83)";

		L["SETTINGS_POPUP"] = "Zeigt bei Mouseover";
		L["SETTINGS_POPUP_DESC"] = "zeigt das Hauptfenster nur dann, wann der Mauszeiger über die Titelleiste ist";

		L["SETTINGS_RESETPOS"] = "Fenster rücksetzen";
		L["SETTINGS_RESETPOS_DESC"] = "setzt das Fenster in die Mitte des Bildschirms";

		L["SETTINGS_DECIMAL"] = "Dezimal-Genauigkeit";
		L["SETTINGS_DECIMAL_DESC"] = "steuert die Anzahl der Dezimalstellen, auf die die Werte berechnet werden";

		L["SETTINGS_HITAMOUNT"] = "Feindmacht";
		L["SETTINGS_HITAMOUNT_DESC"] = "legt die Höhe des Schadens ein Feind zufügt VOR Milderung.";

		L["SETTINGS_PARRYHASTE"] = "Eile durch Parieren";
		L["SETTINGS_PARRYHASTE_DESC"] = "ein-oder ausschließen Eile durch Parieren bei der Berechnung der erwarteten Zeit bis zur Live";

		L["SETTINGS_TTL_CONTINUOUS"] = "Continuous Damage";
		L["SETTINGS_TTL_CONTINUOUS_DESC"] = "check to model each incoming hit as being delivered across the entire duration of the mob's swing; uncheck to model hits as instantaneous events at each tick of the swing timer.";

		L["SETTINGS_SHOWNEH"] = "Show EH2";
		L["SETTINGS_SHOWNEH_DESC"] = "shows EH2 values, i.e. effective health given specified relative percentages of melee, bleed and magic damage";

		L["SETTINGS_RECORD_NEHXY"] = "Record Damage";
		L["SETTINGS_RECORD_NEHXY_DESC"] = "enables or disables the automatic recording of damage sources in-combat. When combat ends, you will have the option of using the observed percentages to recalculate EH2.";

		L["SETTINGS_NEH_INCLUDEAVOID"] = "Include Avoidance";
		L["SETTINGS_NEH_INCLUDEAVOID_DESC"] = "indicates whether avoidance (dodges, parries, melee/spell misses, etc) should be included in the EH2 damage percentages. Changing this option while a recorded damage report is active will recalculate EH2. Note that this will tend to heavily bend the weighted EH2 mitigation towards melee damage.";

		L["SETTINGS_AD_STOP_NEHREC"] = "Stop on AD Heal";
		L["SETTINGS_AD_STOP_NEHREC_DESC"] = "indicates whether the damage analysis should stop when an Ardent Defender heal proc is detected, or whether it should continue recording until you are actually dead.";

		L["SETTINGS_NEH_CHOOSEDATA"] = "EH2 Data Source";
		L["SETTINGS_NEH_CHOOSEDATA_DESC"] = "selects the data used to calculate EH2 damage percentages, Lower and Upper bounds. Select \"NONE\" to reset data, or \"Latest Fight\" to use the most recent combat data, if such data exists.";

		L["SETTINGS_NEH_SAVEDATA"] = "Save Data Segment";
		L["SETTINGS_NEH_SAVEDATA_DESC"] = "permanently saves the current EH2 data segment";

		L["SETTINGS_NEH_RELOAD"] = "Reload Data Segment";
		L["SETTINGS_NEH_RELOAD_DESC"] = "reloads the current EH2 data segment";

		L["SETTINGS_NEH_RELOAD_PROFILE"] = "Reload Profile";
		L["SETTINGS_NEH_RELOAD_PROFILE_DESC"] = "reloads the current EH2 damage profile";

		L["SETTINGS_NEH_DELETEDATA"] = "Delete Data Segment";
		L["SETTINGS_NEH_DELETEDATA_DESC"] = "permanently deletes the current EH2 data segment";

		L["SETTINGS_NEH_PRINTREPORT"] = "Print Report";
		L["SETTINGS_NEH_PRINTREPORT_DESC"] = "if a damage record is active, this will re-print the damage report.";

		L["SETTINGS_RESET_NEH_SLIDERS"] = "Reset EH2 Profile";
		L["SETTINGS_RESET_NEH_SLIDERS_DESC"] = "resets the EH2 percentages to the Default profile";

		L["SETTINGS_NEH_IMPEXP_HEADING"] = "Import/Export";
		L["SETTINGS_NEH_CUSTOMSPELLS_HEADING"] = "Custom Spell Schools";
		L["SETTINGS_NEH_SLIDERS_HEADING"] = "EH2 Damage Percentages";

		L["SETTINGS_NEH_CUSTOM_SCHOOL"] = "Custom School";
		L["SETTINGS_NEH_CUSTOM_SCHOOL_DESC"] = "select the school with which this spell ID will be associated while recording EH2. Recall that Bleed refers to *any* physical attack which bypasses armor.";

		L["SETTINGS_NEH_CUSTOM_SPELL"] = "Spell ID";
		L["SETTINGS_NEH_CUSTOM_SPELL_DESC"] = "enter the ID of the spell to customise. It will be added to the database when Enter is pressed; please set the spell school correctly before doing so.";

		L["SETTINGS_NEH_PRINT_SPELLS"] = "Print Custom Spells";
		L["SETTINGS_NEH_PRINT_SPELLS_DESC"] = "print the list of custom spell/school pairings";

		L["SETTINGS_NEH_IMPORT"] = "Import EH2 Profile Set";
		L["SETTINGS_NEH_IMPORT_DESC"] = "import a set of EH2 profiles from an external source";

		L["SETTINGS_NEH_EXPORT"] = "Export EH2 Profile Set";
		L["SETTINGS_NEH_EXPORT_DESC"] = "export a copy of your saved EH2 profiles";

		L["SETTINGS_NEH_PERCENTPROFILES"] = "EH2 Damage Profile";
		L["SETTINGS_NEH_PERCENTPROFILES_DESC"] = "choose a saved EH2 damage profile";

                L["SETTINGS_SAVE_NEH_SLIDERS"] = "Save Current EH2 Profile:"
                L["SETTINGS_SAVE_NEH_SLIDERS_DESC"] = "enter a profile name and press enter to save the current slider configuration"

                L["SETTINGS_DELETE_NEH_SLIDERS"] = "Delete EH2 Profile"
                L["SETTINGS_DELETE_NEH_SLIDERS_DESC"] = "delete the current EH2 profile"

		L["SETTINGS_RESET_NEH"] = "Reset Saved Data";
		L["SETTINGS_RESET_NEH_DESC"] = "discards saved EH2 combat data. Your most recent recorded combat session will not be deleted.";

		L["SETTINGS_NEH_SLIDERS"] = "EH2 Profiles";
		L["SETTINGS_NEH_SLIDERS_DESC"] = "slider bars allowing the percentage contribution of each damage type to be specified.";

		L["SETTINGS_MELEE_DESC"] = "deduced from the other EH2 values; this slider is for information only, and cannot be set manually.";
		L["SETTINGS_BLEED_DESC"] = "sets the relative percentage of incoming damage due to bleeds or other armor-ignoring effects";
		L["SETTINGS_NEHXY_PERC_DESC"] = "sets the relative percentage of incoming damage due to this magic school";

		L["SETTINGS_TTL_OPTIONS"] = "TTL Options";
		L["SETTINGS_TTL_OPTIONS_DESC"] = "melee damage, parry haste and damage delivery options for TTL and Total DR";

		L["SETTINGS_SCALE"] = "Skala";
		L["SETTINGS_SCALE_DESC"] = "steuert die Größe des Hauptfensters";

		L["SETTINGS_FONT"] = "Schriftart";
		L["SETTINGS_FONT_DESC"] = "wählen Sie eine Schriftart aus der Liste";

		L["SETTINGS_FONTOUTLINE"] = "Umriss";
		L["SETTINGS_FONTOUTLINE_DESC"] = "steuert die Stärke der Schriftart";

		L["SETTINGS_GROWDIR"] = "Orientierung";
		L["SETTINGS_GROWDIR_DESC"] = "legt die Ausrichtung des Hauptfensters";

		L["SETTINGS_RES"] = "Zauberschulen";
		L["SETTINGS_RES_DESC"] = "aktiviert oder deaktiviert die Anzeige der garantierten und der durchschnittlichen Milderung für die einzelnen Zauberschule";

		L["SETTINGS_COOLDOWNS"] = "Abklingzeiten";
		L["SETTINGS_COOLDOWNS_DESC"] = "aktiviert oder deaktiviert die Ankündigung der Abklingzeiten";

		L["SETTINGS_TAUNTMISS"] = "Spott";
		L["SETTINGS_TAUNTMISS_DESC"] = "aktiviert oder deaktiviert der Ankündigung, wann ein Spott vermisst oder das Ziel immun ist";

		L["SETTINGS_SPECIALTAUNT"] = "Sonderspott";
		L["SETTINGS_SPECIALTAUNT_DESC"] = "ein-oder ausschließt "..S["Challenging Shout"]..", "..S["Challenging Roar"].." und "..S["Righteous Defense"].." in die Ankündigungen.";

		L["SETTINGS_TAUNTMISS_SOUND"] = "Taunt Miss Alert";
		L["SETTINGS_TAUNTMISS_SOUND_DESC"] = "choose a sound effect to be played whenever a taunt misses, or set to None to disable the audio alert";

		L["SETTINGS_CHANNEL"] = "Kanal";
		L["SETTINGS_CHANNEL_DESC"] = "setzt den Kanal, auf die Ankündigungen gesendet werden";

		L["SETTINGS_INSTANCE"] = "Instanzen";
		L["SETTINGS_INSTANCE_DESC"] = "ermöglicht Ankündigungen nur in Instanzen";

		L["SETTINGS_STANCE"] = "Haltungen";
		L["SETTINGS_STANCE_DESC"] = "ermöglicht Ankündigungen nur während eine Panzerhaltung aktiv ist; das heißt "..S["Frost Presence"]..", "..S["Dire Bear Form"]..", "..S["Righteous Fury"].." oder "..S["Defensive Stance"]..".";

		L["SETTINGS_PVP"] = "PVP";
		L["SETTINGS_PVP_DESC"] = "aktiviert oder deaktiviert Ankündigungen in Schlachtfelder und Arenen";

		L["SETTINGS_HOP"] = "HdS Entfernung";
		L["SETTINGS_HOP_DESC"] = "aktiviert oder deaktiviert der automatischen Entfernung von "..S["Hand of Protection"];

		L["SETTINGS_WOTN_ANNOUNCE"] = "WN Ankündigungen";
		L["SETTINGS_WOTN_ANNOUNCE_DESC"] = "aktiviert oder deaktiviert die Ankündigungen für "..S["Will of the Necropolis"];

		L["SETTINGS_WOTN_TEXT"] = "WN Ankündigungstext";
		L["SETTINGS_WOTN_TEXT_DESC"] = "geben Sie den Text wird noch bekannt gegeben, wenn "..S["Will of the Necropolis"].." spart Sie";

		L["SETTINGS_AD_ANNOUNCE"] = "UV Ankündigungen";
		L["SETTINGS_AD_ANNOUNCE_DESC"] = "aktiviert oder deaktiviert die Ankündigungen für "..S["Ardent Defender"];

		L["SETTINGS_AD_TEXT"] = "UV Ankündigungstext";
		L["SETTINGS_AD_TEXT_DESC"] = "geben Sie den Text wird noch bekannt gegeben, wenn "..S["Ardent Defender"].." spart Sie";

		L["SETTINGS_AD_ANNOUNCEHEAL"] = "UV-Heilung Ankündigungen";
		L["SETTINGS_AD_ANNOUNCEHEAL_DESC"] = "aktiviert oder deaktiviert Ankündigungen, wenn "..S["Ardent Defender"].." heilt Sie";

		L["SETTINGS_AD_HEALTEXT"] = "UV-Heilung Ankündigungstext";
		L["SETTINGS_AD_HEALTEXT_DESC"] = "geben Sie den Text wird noch bekannt gegeben, wenn "..S["Ardent Defender"].." heilt Sie";

		L["SETTINGS_AD_CDBAR"] = "UV Abklingzeit";
		L["SETTINGS_AD_CDBAR_DESC"] = "anzeige einer Bar die angibt, wie lange vor "..S["Ardent Defender"].." heilen können Sie wieder";

		L["SETTINGS_CDBAR_TEXTURE"] = "Statusleiste Textur";
		L["SETTINGS_CDBAR_TEXTURE_DESC"] = "legt die Textur für die Statusleiste verwendet werden";

		L["SETTINGS_ADHEAL_EHTTL"] = "UV Heilung in EL/LD";
		L["SETTINGS_ADHEAL_EHTTL_DESC"] = "einschließt die Heilung von UV bei der Berechnung der Effektiv Leben und erwartete Lebensdauer";

		L["SETTINGS_WOTN_CDBAR"] = "WN Abklingzeit";
		L["SETTINGS_WOTN_CDBAR_DESC"] = "anzeige einer Bar die angibt, wie lange vor "..S["Will of the Necropolis"].." kann wieder aktivieren";

		L["SETTINGS_WOTN_EHTTL"] = "WOTN in EH/TTL";
		L["SETTINGS_WOTN_EHTTL_DESC"] = "include the single hit mitigated by WOTN in calculations of EH (but not NEH) and expected time-to-live";

		L["SETTINGS_STATS_RESET"] = "Statistiken rücksetzen";
		L["SETTINGS_STATS_RESET_DESC"] = "rücksetzen die Bekämpfungsstatistiken";

		L["SETTINGS_PERFIGHT"] = "Pro-Kampf Statistiken";
		L["SETTINGS_PERFIGHT_DESC"] = "markieren Sie dieses Kontrollkästchen, um die Statistik zu löschen, wenn Bekämpfung beginnt und zu drucken einen kurzen Bericht, wenn sie endet. Deaktivieren Sie das Kontrollkästchen, wenn Sie nur einen Gesamtwert brauchen.";
end
