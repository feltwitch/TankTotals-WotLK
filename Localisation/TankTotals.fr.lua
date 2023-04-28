
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):NewLocale("TankTotals", "frFR", false);

if L then

	-- death knight
		-- L["DK_FLATMIT"] = "Incassable:";

		L["IBF_YELL"] = strupper(S["Icebound Fortitude"]);
		L["UA_YELL"] = strupper(S["Unbreakable Armor"]);
		L["VB_YELL"] = strupper(S["Vampiric Blood"]);
		L["BS_YELL"] = strupper(S["Bone Shield"]);

		L["WOTN_YELL"] = strupper(S["Will of the Necropolis"]).." M'A SAUVÉ LA VIE! NE PAS ME FORCER À UTILISER "..strupper(S["Icebound Fortitude"]).."!";
		L["WOTN_YELL_ORIG"] = strupper(S["Will of the Necropolis"]).." M'A SAUVÉ LA VIE! NE PAS ME FORCER À UTILISER "..strupper(S["Icebound Fortitude"]).."!";

	-- paladin
		L["PALA_FLATMIT"] = "Valeur:";

		L["DG_YELL"] = strupper(S["Divine Guardian"]);
		L["DP_YELL"] = strupper(S["Divine Protection"]);
		L["HSALV_YELL"] = strupper(S["Hand of Salvation"]);

		L["AD_YELL"] = strupper(S["Ardent Defender"]).." M'A SAUVÉ LA VIE! NE PAS ME FORCER À UTILISER "..strupper(S["Lay on Hands"]).."!";
		L["AD_YELL_ORIG"] = strupper(S["Ardent Defender"]).." M'A SAUVÉ LA VIE! NE PAS ME FORCER À UTILISER "..strupper(S["Lay on Hands"]).."!";

		L["AD_HEALYELL"] = strupper(S["Ardent Defender"]).."VIENT DE M'A GUÉRI! GARDEZ-MOI EN VIE POUR LES 2 MINUTES!";
		L["AD_HEALYELL_ORIG"] = strupper(S["Ardent Defender"]).."VIENT DE M'A GUÉRI! GARDEZ-MOI EN VIE POUR LES 2 MINUTES!";

	-- druid
		L["DRUID_FLATMIT"] = "Sauvage:";

		L["BSKIN_YELL"] = strupper(S["Barkskin"]);
		L["FR_YELL"] = strupper(S["Frenzied Regeneration"]);
		L["SI_YELL"] = strupper(S["Survival Instincts"]);

	-- warrior
		L["WARR_FLATMIT"] = "Valeur:";

		L["SB_YELL"] = strupper(S["Shield Block"]);
		L["SW_YELL"] = strupper(S["Shield Wall"]);
		L["LS_YELL"] = strupper(S["Last Stand"]);

	-- general language
		-- ardent defender & wotn save msgs
		L["SAVE_MSG1"] = "sauvegardé vous!";
		L["SAVE_MSG2"] = "Nombre total de sauvegardes:";

                L["NONTANK_MSG"] = "disabled due to non-tanking class.";

		L["TITLE_BOSSES"] = "(Bosses)";
		L["TITLE_NORMAL"] = "(80)";

		L["AVOID_HEADING"] = "Évitement:";
		L["MIT_HEADING"] = "Atténuation:";
		L["TOTAL_PDR_HEADING"] = "Total:";
                L["BLOCK_TOTAL"] = "Valeur Total:";

		L["EFF_HP_HEADING"] = "Santé Efficaces:";
		L["EXP_TL_HEADING"] = "Temps à Vivre:";

		L["NEH_HEADING"] = "EH2:";
		L["SURVIVAL_HEADING"] = "Mitigation:";
		L["NEH_LOWER_HEADING"] = "Lower:";
		L["NEH_UPPER_HEADING"] = "Upper:";

		L["ALLSPELL_HEADING"] = "Spell:";
		L["BLOCK"] = "Blocage:";

                L["NONE"] = "NONE";
                L["DEFAULT"] = "DEFAULT";
                L["LATEST"] = "LATEST FIGHT";
                L["ADDON_DISABLED"] = "Disabled";

		L["HOLY"] = "Sacré";
		L["FIRE"] = "Feu";
		L["NATURE"] = "Nature";
		L["FROST"] = "Givre";
		L["SHADOW"] = "Ombre";
		L["ARCANE"] = "Arcanes";
		L["UNRESISTIBLE"] = "Unresistible";

		L["FIRESTORM"] = "FireStorm";
		L["FROSTFIRE"] = "FrostFire";
		L["FROSTSTORM"] = "FrostStorm";
		L["SHADOWSTORM"] = "ShadowStorm";
		L["SHADOWFROST"] = "ShadowFrost";
		L["SPELLFIRE"] = "SpellFire";

		L["BLEED"] = "Saigner";
                L["MELEE"] = "Melee";

		L["BLOCK_CAP"] = "Bouchon:";
		L["CD_ACTIVE"] = " est ACTIVE!";
		L["CD_FADED"] = " est INACTIF!";
		L["CD_ONTARGET"] = " sur ";

		L["TAUNT_IMMUNE"] = "IMMUNISÉ À LA PROVOCATION: ";
		L["TAUNT_MISSED"] = "PROVOCATION A RATÉ ";

		L["AD_ACTIVE_HEADING"] = "AD Active:";
		L["AD_TOTAL_HEADING"] = "AD Réduction:";

		L["WOTN_ACTIVE_HEADING"] = "WN Active:"
		L["WOTN_TOTAL_HEADING"] = "WN Réduction:"

                L["SD_UPTIME_HEADING"] = "DS Uptime:";
                L["SD_TOTAL_HEADING"] = "DS Réduction:"

		L["PERFIGHT_REPORT"] = "Rapport";
		L["PERFIGHT_SAVES"] = "Nombre total de sauvegardes:";
		L["PERFIGHT_MITIGATED"] = "Montant total d'atténuer:";
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
		L["SETTINGS_GENERAL"] = "Général";
		L["SETTINGS_GENERAL_DESC"] = "activer, désactiver et déverrouiller l'addon, ou changer entre les valeurs normales et les valeurs pour les Bosses";

		L["SETTINGS_DAMAGE"] = "Mob Damage";
		L["SETTINGS_DAMAGE_DESC"] = "set the values of unmitigated mob melee and relative percentages of bleed/magic damage sources, used in TotalDR/TTL/NEH calculations";

		L["SETTINGS_APPEARANCE"] = "Apparence";
		L["SETTINGS_APPEARANCE_DESC"] = "modifier l'échelle, la précision, la font et le contenu de l'addon";

		L["SETTINGS_ANNOUNCE"] = "Alertes";
		L["SETTINGS_ANNOUNCE_DESC"] = "changer le type de manifestations qui seront annoncées et la chaîne à laquelle ils sont envoyés";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Secondary Output";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "sets an optional secondary announcement channel via LibSink; target can be an SCT addon such as Parrot, MSBT, etc";

		L["SETTINGS_CLASS"] = "Classe";
		L["SETTINGS_CLASS_DESC"] = "paramètres spécifiques à la classe";

		L["SETTINGS_GUI"] = "Configuration GUI";
		L["SETTINGS_GUI_DESC"] = "ouvre l'interface graphique de configuration";

		L["SETTINGS_ENABLED"] = "Activer";
		L["SETTINGS_ENABLED_DESC"] = "activer ou désactiver le TankTotals";

		L["SETTINGS_ENABLED_SPEC1"] = "Primary Spec";
		L["SETTINGS_ENABLED_SPEC2"] = "Secondary Spec";
		L["SETTINGS_ENABLED_PERSPEC_DESC"] = "indicates whether TankTotals should automatically en/disable itself when the player switches to this spec";

		L["SETTINGS_STANDALONE"] = "Standalone Display";
		L["SETTINGS_STANDALONE_DESC"] = "enable or disable the display of the standalone window. If disabled, the TankTotals window will still be accessible via its DataBroker feed.";

		L["SETTINGS_BOSSVALUES"] = "Valeurs du Bosses";
		L["SETTINGS_BOSSVALUES_DESC"] = "basculer entre les valeurs normales et les valeurs de Bosses (80-83)";

		L["SETTINGS_POPUP"] = "Afficher sur Mouseover";
		L["SETTINGS_POPUP_DESC"] = "montre la fenêtre principale que lorsque le curseur souris se trouve sur la barre de titre";

		L["SETTINGS_RESETPOS"] = "Réinitialiser la Fenêtre";
		L["SETTINGS_RESETPOS_DESC"] = "réinitialise la position de la fenêtre du centre de l'écran";

		L["SETTINGS_DECIMAL"] = "Précision Décimale";
		L["SETTINGS_DECIMAL_DESC"] = "le nombre de décimales pour les valeurs qui seront calculés";

		L["SETTINGS_HITAMOUNT"] = "Puissance Ennemie";
		L["SETTINGS_HITAMOUNT_DESC"] = "précise le montant des dommages d'un ennemi inflige à vous AVANT d'atténuation. Mettre à 0 pour ignorer.";

		L["SETTINGS_PARRYHASTE"] = "Hâte par les Parades";
		L["SETTINGS_PARRYHASTE_DESC"] = "inclure ou d'exclure toute hâte causé par les parades dans le calcul du temps prévu à vivre";

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

		L["SETTINGS_SCALE"] = "Taille";
		L["SETTINGS_SCALE_DESC"] = "définit la taille de la fenêtre principale";

		L["SETTINGS_FONT"] = "Font";
		L["SETTINGS_FONT_DESC"] = "définit la font utilisée par TankTotals";

		L["SETTINGS_FONTOUTLINE"] = "Épaisseur";
		L["SETTINGS_FONTOUTLINE_DESC"] = "définit l'épaisseur de la font";

		L["SETTINGS_GROWDIR"] = "Orientation";
		L["SETTINGS_GROWDIR_DESC"] = "définit l'orientation de la fenêtre principale";

		L["SETTINGS_RES"] = "École de Magie";
		L["SETTINGS_RES_DESC"] = "active ou désactive l'affichage de la garantie de l'atténuation et la moyenne pour chaque école de magie";

		L["SETTINGS_COOLDOWNS"] = "Temps de Recharge";
		L["SETTINGS_COOLDOWNS_DESC"] = "d'activer ou de désactiver l'annonce de cooldowns";

		L["SETTINGS_TAUNTMISS"] = "Provocation";
		L["SETTINGS_TAUNTMISS_DESC"] = "activer ou désactiver les alertes quand une provocation a raté ou si la cible est à l'abri";

		L["SETTINGS_SPECIALTAUNT"] = "Spéciale Provocation";
		L["SETTINGS_SPECIALTAUNT_DESC"] = "inclure ou d'exclure "..S["Challenging Shout"]..", "..S["Challenging Roar"].." et "..S["Righteous Defense"].." dans les alertes.";

		L["SETTINGS_CHANNEL"] = "Canal de l'alertes";
		L["SETTINGS_CHANNEL_DESC"] = "définit la canal qui les alertes sont envoyées à";

		L["SETTINGS_TAUNTMISS_SOUND"] = "Taunt Miss Alert";
		L["SETTINGS_TAUNTMISS_SOUND_DESC"] = "choose a sound effect to be played whenever a taunt misses, or set to None to disable the audio alert";

		L["SETTINGS_INSTANCE"] = "Instances";
		L["SETTINGS_INSTANCE_DESC"] = "permettre seulement les alertes alors que dans l'instances";

		L["SETTINGS_STANCE"] = "Posture";
		L["SETTINGS_STANCE_DESC"] = "permettre à des alertes alors que seulement une posture est active; c'est-à-dire "..S["Frost Presence"]..", "..S["Dire Bear Form"]..", "..S["Righteous Fury"].." ou "..S["Defensive Stance"]..".";

		L["SETTINGS_PVP"] = "PVP";
		L["SETTINGS_PVP_DESC"] = "permettre à des alertes dans les champs de bataille et les arènes";

		L["SETTINGS_HOP"] = "Supprimer MdP";
		L["SETTINGS_HOP_DESC"] = "activer ou désactiver la suppression automatique de la "..S["Hand of Protection"];

		L["SETTINGS_WOTN_ANNOUNCE"] = "Alertes des VdlN";
		L["SETTINGS_WOTN_ANNOUNCE_DESC"] = "activer ou désactiver les alertes pour "..S["Will of the Necropolis"];

		L["SETTINGS_WOTN_TEXT"] = "Texte de l'alertes";
		L["SETTINGS_WOTN_TEXT_DESC"] = "définit le texte qui sera annoncée lorsque "..S["Will of the Necropolis"].." vous permet d'économiser";

		L["SETTINGS_AD_ANNOUNCE"] = "Alertes des AD";
		L["SETTINGS_AD_ANNOUNCE_DESC"] = "activer ou désactiver les alertes pour "..S["Ardent Defender"];

		L["SETTINGS_AD_TEXT"] = "Texte de l'alertes";
		L["SETTINGS_AD_TEXT_DESC"] = "définit le texte qui sera annoncée lorsque "..S["Ardent Defender"].." vous permet d'économiser";

		L["SETTINGS_AD_ANNOUNCEHEAL"] = "Alertes des Soins AD";
		L["SETTINGS_AD_ANNOUNCEHEAL_DESC"] = "activer ou désactiver les alertes lorsque vous guérit "..S["Ardent Defender"];

		L["SETTINGS_AD_HEALTEXT"] = "Texte de l'alertes des Soins AD";
		L["SETTINGS_AD_HEALTEXT_DESC"] = "définit le texte qui sera annoncée lorsque vous guérit "..S["Ardent Defender"];

		L["SETTINGS_AD_CDBAR"] = "AD Recharge";
		L["SETTINGS_AD_CDBAR_DESC"] = "activer une barre d'indiquer combien de temps encore avant que "..S["Ardent Defender"].." peut vous guérir de nouveau";

		L["SETTINGS_CDBAR_TEXTURE"] = "Barre Texture";
		L["SETTINGS_CDBAR_TEXTURE_DESC"] = "définit la texture à être utilisé sur la barre de temps de recharge";

		L["SETTINGS_ADHEAL_EHTTL"] = "AD Heal in SE/TV";
		L["SETTINGS_ADHEAL_EHTTL_DESC"] = "comprennent la guérison de l'AD dans les calculs de santé efficaces et de temps à vivre";

		L["SETTINGS_WOTN_CDBAR"] = "VdlN Recharge";
		L["SETTINGS_WOTN_CDBAR_DESC"] = "afficher une barre d'indiquer combien de temps encore avant que "..S["Will of the Necropolis"].." peut activer une nouvelle fois";

		L["SETTINGS_WOTN_EHTTL"] = "WOTN in EH/TTL";
		L["SETTINGS_WOTN_EHTTL_DESC"] = "include the single hit mitigated by WOTN in calculations of EH (but not NEH) and expected time-to-live";

		L["SETTINGS_STATS_RESET"] = "Réinitialiser Stats";
		L["SETTINGS_STATS_RESET_DESC"] = "réinitialise les statistiques de combat";

		L["SETTINGS_PERFIGHT"] = "Combats Individuels";
		L["SETTINGS_PERFIGHT_DESC"] = "cochez cette case à cocher pour supprimer les statistiques commence combattre et à faire imprimer un rapport quand il se termine. Décochez la case pour enregistrer simplement un total cumulé.";
end
