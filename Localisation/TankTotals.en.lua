
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):NewLocale("TankTotals", "enUS", true);

if L then

	-- death knight
		-- L["DK_FLATMIT"] = "Unbreakable:";

		L["IBF_YELL"] = "DK WALL";
		L["VB_YELL"] = "VAMPIRIC BLOOD";
		L["BS_YELL"] = "BONE SHIELD";
		L["UA_YELL"] = "UNBREAKABLE ARMOR";

		L["WOTN_YELL"] = "NECROPOLIS JUST SAVED MY UN-LIFE! DON'T MAKE ME USE IBF!";
		L["WOTN_YELL_ORIG"] = "NECROPOLIS JUST SAVED MY UN-LIFE! DON'T MAKE ME USE IBF!";

	-- paladin
		L["PALA_FLATMIT"] = "Block Value:";

		L["DG_YELL"] = "RAIDWALL";
		L["DP_YELL"] = "BUBBLE WALL";
		L["HSALV_YELL"] = "WALL OF SALVATION";

		L["AD_YELL"] = "ARDENT DEFENDER JUST SAVED MY LIFE! DON'T MAKE ME LOH!";
		L["AD_YELL_ORIG"] = "ARDENT DEFENDER JUST SAVED MY LIFE! DON'T MAKE ME LOH!";

		L["AD_HEALYELL"] = "ARDENT DEFENDER HEALED ME! KEEP ME UP FOR 2 MINUTES!";
		L["AD_HEALYELL_ORIG"] = "ARDENT DEFENDER HEALED ME! KEEP ME UP FOR 2 MINUTES!";

	-- druid
		L["DRUID_FLATMIT"] = "Savage Def:";

		L["BSKIN_YELL"] = "DRUID WALL";
		L["FR_YELL"] = "FRENZIED REGEN";
		L["SI_YELL"] = "LAST STAND (FERLOL)";

	-- warrior
		L["WARR_FLATMIT"] = "Block Value:";

		L["SB_YELL"] = "SPELL BLOCK";
		L["SW_YELL"] = "SHIELD WALL";
		L["LS_YELL"] = "LAST STAND";

	-- general language
		-- ardent defender & wotn save msgs
		L["SAVE_MSG1"] = "saved you!";
		L["SAVE_MSG2"] = "Total saves:";

                L["NONTANK_MSG"] = "disabled due to non-tanking class.";

		L["TITLE_BOSSES"] = "(lvl + 3)";
		L["TITLE_NORMAL"] = "(lvl + 0)";

		L["AVOID_HEADING"] = "Avoidance:";
		L["MIT_HEADING"] = "Mitigation:";
		L["TOTAL_PDR_HEADING"] = "Total DR:";
                L["BLOCK_TOTAL"] = "Block Total:";

		L["EFF_HP_HEADING"] = "Effective HP:";
		L["EXP_TL_HEADING"] = "Expected TTL:";

		L["NEH_HEADING"] = "EH2:";
		L["SURVIVAL_HEADING"] = "Mitigation:";
		L["NEH_LOWER_HEADING"] = "Lower:";
		L["NEH_UPPER_HEADING"] = "Upper:";

		L["ALLSPELL_HEADING"] = "Spell:";
		L["BLOCK"] = "Block:";

                L["NONE"] = "NONE";
                L["DEFAULT"] = "DEFAULT";
                L["LATEST"] = "LATEST FIGHT";
                L["ADDON_DISABLED"] = "Disabled";

		L["HOLY"] = "Holy";
		L["FIRE"] = "Fire";
		L["NATURE"] = "Nature";
		L["FROST"] = "Frost";
		L["SHADOW"] = "Shadow";
		L["ARCANE"] = "Arcane";
		L["UNRESISTIBLE"] = "Unresistible";

		L["FIRESTORM"] = "FireStorm";
		L["FROSTFIRE"] = "FrostFire";
		L["FROSTSTORM"] = "FrostStorm";
		L["SHADOWSTORM"] = "ShadowStorm";
		L["SHADOWFROST"] = "ShadowFrost";
		L["SPELLFIRE"] = "SpellFire";

		L["BLEED"] = "Bleed";
                L["MELEE"] = "Melee";

		L["BLOCK_CAP"] = "Block Cap:";
		L["CD_ACTIVE"] = " is UP!";
		L["CD_FADED"] = " is DOWN!";
		L["CD_ONTARGET"] = " on ";

		L["TAUNT_IMMUNE"] = "TAUNT IMMUNE: ";
		L["TAUNT_MISSED"] = "TAUNT MISSED ";

		L["AD_ACTIVE_HEADING"] = "AD Active:";
		L["AD_TOTAL_HEADING"] = "AD Reduced:";

		L["WOTN_ACTIVE_HEADING"] = "WN Active:"
		L["WOTN_TOTAL_HEADING"] = "WN Estimate:"

                L["SD_UPTIME_HEADING"] = "SD Uptime:";
                L["SD_TOTAL_HEADING"] = "SD Reduced:"

		L["PERFIGHT_REPORT"] = "Combat Report";
		L["PERFIGHT_SAVES"] = "Deaths Averted:";
		L["PERFIGHT_MITIGATED"] = "Damage Mitigated:";
		L["PERFIGHT_UPTIME"] = " Uptime:";

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

                L["NEH_CLICK"] = "Use these values for EH2";
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
		L["SETTINGS_GENERAL"] = "General";
		L["SETTINGS_GENERAL_DESC"] = "en/disable, reset or unlock the addon, or switch between normal and Boss values";

		L["SETTINGS_DAMAGE"] = "Mob Damage";
		L["SETTINGS_DAMAGE_DESC"] = "set the values of unmitigated mob melee and relative percentages of bleed/magic damage sources, used in TotalDR/TTL/NEH calculations";

		L["SETTINGS_APPEARANCE"] = "Appearance";
		L["SETTINGS_APPEARANCE_DESC"] = "alter the scale, accuracy, font and content of the display";

		L["SETTINGS_ANNOUNCE"] = "Announce";
		L["SETTINGS_ANNOUNCE_DESC"] = "change the type of events to be announced and the channel to which they are sent";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Secondary Output";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "sets an optional secondary announcement channel via LibSink; target can be an SCT addon such as Parrot, MSBT, etc";

		L["SETTINGS_CLASS"] = "Class";
		L["SETTINGS_CLASS_DESC"] = "any class-specific options are found here";

		L["SETTINGS_GUI"] = "Configuration GUI";
		L["SETTINGS_GUI_DESC"] = "opens the Configuration GUI";

		L["SETTINGS_ENABLED"] = "Enabled";
		L["SETTINGS_ENABLED_DESC"] = "enable or disable TankTotals";

		L["SETTINGS_ENABLED_SPEC1"] = "Primary Spec";
		L["SETTINGS_ENABLED_SPEC2"] = "Secondary Spec";
		L["SETTINGS_ENABLED_PERSPEC_DESC"] = "indicates whether TankTotals should automatically en/disable itself when the player switches to this spec";

		L["SETTINGS_STANDALONE"] = "Standalone Display";
		L["SETTINGS_STANDALONE_DESC"] = "enable or disable the display of the standalone window. If disabled, the TankTotals window will still be accessible via its DataBroker feed.";

		L["SETTINGS_BOSSVALUES"] = "Boss Values";
		L["SETTINGS_BOSSVALUES_DESC"] = "switch between standard values and vs Bosses (lvl+0 / lvl+3)";

		L["SETTINGS_POPUP"] = "Show Only on Mouseover";
		L["SETTINGS_POPUP_DESC"] = "shows the standalone display only when the mouse cursor is over the title bar";

		L["SETTINGS_RESETPOS"] = "Reset Main Window";
		L["SETTINGS_RESETPOS_DESC"] = "resets the TankTotals standalone window to the centre of the screen";

		L["SETTINGS_DECIMAL"] = "Decimal Accuracy";
		L["SETTINGS_DECIMAL_DESC"] = "the number of decimal places to which values will be calculated";

		L["SETTINGS_HITAMOUNT"] = "TTL Melee Damage";
		L["SETTINGS_HITAMOUNT_DESC"] = "sets the amount of damage a mob inflicts BEFORE mitigation. This is used to calculate the contribution of flat mitigation (BV or Savage Defense) to Expected TTL and Total DR. Set this to 0 to disregard flat mitigation.";

		L["SETTINGS_PARRYHASTE"] = "Include Parry Haste";
		L["SETTINGS_PARRYHASTE_DESC"] = "include or exclude parry haste in the calculation of expected time-to-live";

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

		L["SETTINGS_MELEE_DESC"] = "deduced from the other EH2 values; this slider is for information only, and cannot be set manually.";
		L["SETTINGS_BLEED_DESC"] = "sets the relative percentage of incoming damage due to bleeds or other armor-ignoring effects";
		L["SETTINGS_NEHXY_PERC_DESC"] = "sets the relative percentage of incoming damage due to this magic school";

		L["SETTINGS_TTL_OPTIONS"] = "TTL Options";
		L["SETTINGS_TTL_OPTIONS_DESC"] = "melee damage, parry haste and damage delivery options for TTL and Total DR";

		L["SETTINGS_SCALE"] = "Scale";
		L["SETTINGS_SCALE_DESC"] = "sets the scale of the TankTotals main window";

		L["SETTINGS_FONT"] = "Font";
		L["SETTINGS_FONT_DESC"] = "sets the font used by TankTotals";

		L["SETTINGS_FONTOUTLINE"] = "Font Outline";
		L["SETTINGS_FONTOUTLINE_DESC"] = "sets the thickness of the font outline";

		L["SETTINGS_GROWDIR"] = "Growth Direction";
		L["SETTINGS_GROWDIR_DESC"] = "sets the orientation of the standalone display window";

		L["SETTINGS_RES"] = "Show Magic Schools";
		L["SETTINGS_RES_DESC"] = "enable or disable the display of guaranteed and average mitigation for individual magic schools, when relevant";

		L["SETTINGS_COOLDOWNS"] = "Cooldowns";
		L["SETTINGS_COOLDOWNS_DESC"] = "enable or disable announcement of tanking CDs";

		L["SETTINGS_TAUNTMISS"] = "Taunt Misses";
		L["SETTINGS_TAUNTMISS_DESC"] = "enable or disable announcements when a taunt misses or the target is immune";

		L["SETTINGS_SPECIALTAUNT"] = "AoE Taunt Misses";
		L["SETTINGS_SPECIALTAUNT_DESC"] = "include or exclude AoE taunts in miss announcements; these are Challenging Roar, Challenging Shout, and Righteous Defense.";

		L["SETTINGS_TAUNTMISS_SOUND"] = "Taunt Miss Alert";
		L["SETTINGS_TAUNTMISS_SOUND_DESC"] = "choose a sound effect to be played whenever a taunt misses, or set to None to disable the audio alert";

		L["SETTINGS_CHANNEL"] = "Announce Channel";
		L["SETTINGS_CHANNEL_DESC"] = "sets the channel to which announcements are sent";

		L["SETTINGS_INSTANCE"] = "Instances Only";
		L["SETTINGS_INSTANCE_DESC"] = "enable announcements only while in instances";

		L["SETTINGS_STANCE"] = "Stances Only";
		L["SETTINGS_STANCE_DESC"] = "enable announcements only while a tanking stance is active; that is, one of Frost Presence, Bear Form, Righteous Fury or Defensive Stance.";

		L["SETTINGS_PVP"] = "Enable in PVP";
		L["SETTINGS_PVP_DESC"] = "enable announcements while in BGs and arenas";

		L["SETTINGS_HOP"] = "Remove HoP";
		L["SETTINGS_HOP_DESC"] = "enable or disable automatic removal of Hand of Protection";

		L["SETTINGS_WOTN_ANNOUNCE"] = "Announce WN Saves";
		L["SETTINGS_WOTN_ANNOUNCE_DESC"] = "enable or disable Will Of The Necropolis announcements";

		L["SETTINGS_WOTN_TEXT"] = "WN Announce Text";
		L["SETTINGS_WOTN_TEXT_DESC"] = "sets the text to be announced when Will of the Necropolis saves you";

		L["SETTINGS_AD_ANNOUNCE"] = "Announce AD Saves";
		L["SETTINGS_AD_ANNOUNCE_DESC"] = "enable or disable announcements when Ardent Defender's mitigation prevents a killing blow";

		L["SETTINGS_AD_TEXT"] = "AD Save Text";
		L["SETTINGS_AD_TEXT_DESC"] = "sets the text to be announced when Ardent Defender's damage mitigation prevents a killing blow";

		L["SETTINGS_AD_ANNOUNCEHEAL"] = "Announce AD Heals";
		L["SETTINGS_AD_ANNOUNCEHEAL_DESC"] = "enable or disable announcements when Ardent Defender's heal procs";

		L["SETTINGS_AD_HEALTEXT"] = "AD Heal Text";
		L["SETTINGS_AD_HEALTEXT_DESC"] = "sets the text to be announced when Ardent Defender's heal procs";

		L["SETTINGS_AD_CDBAR"] = "Show AD CD Bar";
		L["SETTINGS_AD_CDBAR_DESC"] = "activate a cooldown bar to indicate how long remains before Ardent Defender can heal you again";

		L["SETTINGS_CDBAR_TEXTURE"] = "CD Bar Texture";
		L["SETTINGS_CDBAR_TEXTURE_DESC"] = "sets the texture to be used on the cooldown bar";

		L["SETTINGS_ADHEAL_EHTTL"] = "AD Heal in EH/TTL";
		L["SETTINGS_ADHEAL_EHTTL_DESC"] = "include the AD heal in calculations of EH, EH2 and expected time-to-live, when not on cooldown";

		L["SETTINGS_WOTN_CDBAR"] = "Show WOTN CD Bar";
		L["SETTINGS_WOTN_CDBAR_DESC"] = "activate a cooldown bar to indicate how long remains before Will of the Necropolis can proc again";

		L["SETTINGS_WOTN_EHTTL"] = "WOTN in EH/TTL";
		L["SETTINGS_WOTN_EHTTL_DESC"] = "include the single hit mitigated by WOTN in calculations of EH (but not NEH) and expected time-to-live";

		L["SETTINGS_STATS_RESET"] = "Reset Stats";
		L["SETTINGS_STATS_RESET_DESC"] = "resets combat statistics";

		L["SETTINGS_PERFIGHT"] = "Per-Fight Statistics";
		L["SETTINGS_PERFIGHT_DESC"] = "check to delete stats upon entering combat and print a short report upon exit; uncheck to simply keep a cumulative tally across all fights.";
end
