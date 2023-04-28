
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):NewLocale("TankTotals", "esES", false);

if L then

	-- death knight
		-- L["DK_FLATMIT"] = "Inquebrantable:";

		L["IBF_YELL"] = strupper(S["Icebound Fortitude"]);
		L["UA_YELL"] = strupper(S["Unbreakable Armor"]);
		L["VB_YELL"] = strupper(S["Vampiric Blood"]);
		L["BS_YELL"] = strupper(S["Bone Shield"]);

		L["WOTN_YELL"] = strupper(S["Will of the Necropolis"]).." ¡ME HA SALVADO LA VIDA!";
		L["WOTN_YELL_ORIG"] = strupper(S["Will of the Necropolis"]).." ¡ME HA SALVADO LA VIDA!";

	-- paladin
		L["PALA_FLATMIT"] = "Valor:";

		L["DG_YELL"] = strupper(S["Divine Guardian"]);
		L["DP_YELL"] = strupper(S["Divine Protection"]);
		L["HSALV_YELL"] = strupper(S["Hand of Salvation"]);

		L["AD_YELL"] = strupper(S["Ardent Defender"]).." ¡ME HA SALVADO LA VIDA!";
		L["AD_YELL_ORIG"] = strupper(S["Ardent Defender"]).." ¡ME HA SALVADO LA VIDA!";

		L["AD_HEALYELL"] = strupper(S["Ardent Defender"]).." ¡ME ACABA DE CURADO! MANTENERME VIVO DURANTE 2 MINUTOS!";
		L["AD_HEALYELL_ORIG"] = strupper(S["Ardent Defender"]).." ¡ME ACABA DE CURADO! MANTENERME VIVO DURANTE 2 MINUTOS!";

	-- druid
		L["DRUID_FLATMIT"] = "Salvaje:";

		L["BSKIN_YELL"] = strupper(S["Barkskin"]);
		L["FR_YELL"] = strupper(S["Frenzied Regeneration"]);
		L["SI_YELL"] = strupper(S["Survival Instincts"]);

	-- warrior
		L["WARR_FLATMIT"] = "Valor:";

		L["SB_YELL"] = strupper(S["Shield Block"]);
		L["SW_YELL"] = strupper(S["Shield Wall"]);
		L["LS_YELL"] = strupper(S["Last Stand"]);

	-- general language
		-- ardent defender & wotn save msgs
		L["SAVE_MSG1"] = "te ha salvado!";
		L["SAVE_MSG2"] = "Veces salvado:";

                L["NONTANK_MSG"] = "disabled due to non-tanking class.";

		L["TITLE_BOSSES"] = "(Jefe)";
		L["TITLE_NORMAL"] = "(80)";

		L["AVOID_HEADING"] = "Evasión:";
		L["MIT_HEADING"] = "Mitigación:";
		L["TOTAL_PDR_HEADING"] = "Total:";
                L["BLOCK_TOTAL"] = "Valor Total:";

		L["EFF_HP_HEADING"] = "Salud Eficaz:";
		L["EXP_TL_HEADING"] = "Tiempo de Vivir:";

		L["NEH_HEADING"] = "EH2:";
		L["SURVIVAL_HEADING"] = "Mitigation:";
		L["NEH_LOWER_HEADING"] = "Lower:";
		L["NEH_UPPER_HEADING"] = "Upper:";

		L["ALLSPELL_HEADING"] = "Hechizo:";
		L["BLOCK"] = "Bloqueo:";

                L["NONE"] = "NONE";
                L["DEFAULT"] = "DEFAULT";
                L["LATEST"] = "LATEST FIGHT";
                L["ADDON_DISABLED"] = "Disabled";

		L["HOLY"] = "Sagrado";
		L["FIRE"] = "Fuego";
		L["NATURE"] = "Naturaleza";
		L["FROST"] = "Escarcha";
		L["SHADOW"] = "Sombras";
		L["ARCANE"] = "Arcano";
		L["UNRESISTIBLE"] = "Unresistible";

		L["FIRESTORM"] = "FireStorm";
		L["FROSTFIRE"] = "FrostFire";
		L["FROSTSTORM"] = "FrostStorm";
		L["SHADOWSTORM"] = "ShadowStorm";
		L["SHADOWFROST"] = "ShadowFrost";
		L["SPELLFIRE"] = "SpellFire";

		L["BLEED"] = "Sangrar";
                L["MELEE"] = "Melee";

		L["BLOCK_CAP"] = "Límite:";
		L["CD_ACTIVE"] = " ACTIVADO!";
		L["CD_FADED"] = " DESACTIVADO!";
		L["CD_ONTARGET"] = " lo tiene ";

		L["TAUNT_IMMUNE"] = "IMMUNE AL PROVOCAR: ";
		L["TAUNT_MISSED"] = "PROVOCAR FALLADO ";

		L["AD_ACTIVE_HEADING"] = "Umbral de DC:";
		L["AD_TOTAL_HEADING"] = "DC Reducción:";

		L["WOTN_ACTIVE_HEADING"] = "Umbral de VN:"
		L["WOTN_TOTAL_HEADING"] = "VN Estimación:"

                L["SD_UPTIME_HEADING"] = "DS Actividad:";
                L["SD_TOTAL_HEADING"] = "DS Reducción:"

		L["PERFIGHT_REPORT"] = "Informe";
		L["PERFIGHT_SAVES"] = "Veces salvado:";
		L["PERFIGHT_MITIGATED"] = "Cantidad Mitigada:";
		L["PERFIGHT_UPTIME"] = " Actividad:";

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
		L["SETTINGS_GENERAL"] = "General";
		L["SETTINGS_GENERAL_DESC"] = "activar, desactivar, desbloquear, o cambiar a totales de Jefes";

		L["SETTINGS_DAMAGE"] = "Mob Damage";
		L["SETTINGS_DAMAGE_DESC"] = "set the values of unmitigated mob melee and relative percentages of bleed/magic damage sources, used in TotalDR/TTL/NEH calculations";

		L["SETTINGS_APPEARANCE"] = "Apariencia";
		L["SETTINGS_APPEARANCE_DESC"] = "cambiar la escala, precisión, tipo de fuente o contenido de la ventana de TankTotals";

		L["SETTINGS_ANNOUNCE"] = "Anunciar";
		L["SETTINGS_ANNOUNCE_DESC"] = "cambiar el tipo y el canal de eventos que se anunciarán";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Secondary Output";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "sets an optional secondary announcement channel via LibSink; target can be an SCT addon such as Parrot, MSBT, etc";

		L["SETTINGS_CLASS"] = "Clase";
		L["SETTINGS_CLASS_DESC"] = "opciones específicas de su clase";

		L["SETTINGS_GUI"] = "Configuración interfaz";
		L["SETTINGS_GUI_DESC"] = "abre el panel GUI";

		L["SETTINGS_ENABLED"] = "Activar";
		L["SETTINGS_ENABLED_DESC"] = "activar o desactivar TankTotals";

		L["SETTINGS_ENABLED_SPEC1"] = "Primary Spec";
		L["SETTINGS_ENABLED_SPEC2"] = "Secondary Spec";
		L["SETTINGS_ENABLED_PERSPEC_DESC"] = "indicates whether TankTotals should automatically en/disable itself when the player switches to this spec";

		L["SETTINGS_STANDALONE"] = "Standalone Display";
		L["SETTINGS_STANDALONE_DESC"] = "enable or disable the display of the standalone window. If disabled, the TankTotals window will still be accessible via its DataBroker feed.";

		L["SETTINGS_BOSSVALUES"] = "Valores de Jefes";
		L["SETTINGS_BOSSVALUES_DESC"] = "cambiar entre valores normales o valores de Jefes (80-83)";

		L["SETTINGS_POPUP"] = "Mostrar durante Mouseover";
		L["SETTINGS_POPUP_DESC"] = "muestra la ventana principal sólo cuando el cursor del ratón está sobre la barra de título";

		L["SETTINGS_RESETPOS"] = "Reiniciar Ventana";
		L["SETTINGS_RESETPOS_DESC"] = "reinicia la posición de la ventana de TankTotals al centro de la pantalla";

		L["SETTINGS_DECIMAL"] = "Precisión de Decimales";
		L["SETTINGS_DECIMAL_DESC"] = "muestra decimales en los valores";

		L["SETTINGS_HITAMOUNT"] = "Daños del Enemigo";
		L["SETTINGS_HITAMOUNT_DESC"] = "especifica la cantidad de daño que inflige un enemigo para usted ANTES de mitigación. Pone a 0 para pasar por alto.";

		L["SETTINGS_PARRYHASTE"] = "Prisa por Parada";
		L["SETTINGS_PARRYHASTE_DESC"] = "incluir o excluir prisa causada por Parry en el cálculo del tiempo de vida esperado";

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

		L["SETTINGS_NEH_SAVEDATA"] = "Save Data Segment";
		L["SETTINGS_NEH_SAVEDATA_DESC"] = "permanently saves the current EH2 data segment";

		L["SETTINGS_NEH_RELOAD"] = "Reload Data Segment";
		L["SETTINGS_NEH_RELOAD_DESC"] = "reloads the current EH2 data segment";

		L["SETTINGS_NEH_RELOAD_PROFILE"] = "Reload Profile";
		L["SETTINGS_NEH_RELOAD_PROFILE_DESC"] = "reloads the current EH2 damage profile";

		L["SETTINGS_NEH_DELETEDATA"] = "Delete Data Segment";
		L["SETTINGS_NEH_DELETEDATA_DESC"] = "permanently deletes the current EH2 data segment";

		L["SETTINGS_NEH_CHOOSEDATA"] = "EH2 Data Source";
		L["SETTINGS_NEH_CHOOSEDATA_DESC"] = "selects the data used to calculate EH2 damage percentages, Lower and Upper bounds. Select \"NONE\" to reset data, or \"Latest Fight\" to use the most recent combat data, if such data exists.";

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

		L["SETTINGS_SCALE"] = "Escala";
		L["SETTINGS_SCALE_DESC"] = "cambia la escala de la ventana de TankTotals";

		L["SETTINGS_FONT"] = "Fuente";
		L["SETTINGS_FONT_DESC"] = "determina el tipo de fuente que se usará en TankTotals";

		L["SETTINGS_FONTOUTLINE"] = "Densidad de Fuente";
		L["SETTINGS_FONTOUTLINE_DESC"] = "cambia la densidad del fuente";

		L["SETTINGS_GROWDIR"] = "Orientación";
		L["SETTINGS_GROWDIR_DESC"] = "establece la orientación de la ventana principal de";

		L["SETTINGS_RES"] = "Escuelas de Magia";
		L["SETTINGS_RES_DESC"] = "mostrar u oculta la mitigación asegurada y la mitigación media para escuelas individuales de magia";

		L["SETTINGS_COOLDOWNS"] = "Habilidades";
		L["SETTINGS_COOLDOWNS_DESC"] = "activar o desactivar el anuncio de habilidades de tanques";

		L["SETTINGS_TAUNTMISS"] = "Fallos de Provocar";
		L["SETTINGS_TAUNTMISS_DESC"] = "activar o desactivar para cuando un Provocar falla o el enemigo es inmune al Provocar";

		L["SETTINGS_SPECIALTAUNT"] = "Fallos de Provocar Especiales";
		L["SETTINGS_SPECIALTAUNT_DESC"] = "incluye o excluye el anuncio de habilidades de Provocar especiales; específicamente "..S["Challenging Shout"]..", "..S["Challenging Roar"].." y "..S["Righteous Defense"];

		L["SETTINGS_TAUNTMISS_SOUND"] = "Taunt Miss Alert";
		L["SETTINGS_TAUNTMISS_SOUND_DESC"] = "choose a sound effect to be played whenever a taunt misses, or set to None to disable the audio alert";

		L["SETTINGS_CHANNEL"] = "Canal de Anuncios";
		L["SETTINGS_CHANNEL_DESC"] = "cambia el canal donde se anuncia";

		L["SETTINGS_INSTANCE"] = "Anuncios en Mazmorras";
		L["SETTINGS_INSTANCE_DESC"] = "activar los anuncios sólo en mazmorras";

		L["SETTINGS_STANCE"] = "Anuncios en Actitudes";
		L["SETTINGS_STANCE_DESC"] = "activar o desactivar anuncios sólo cuando un actitud de tanque esta activado, específicamente "..S["Frost Presence"]..", "..S["Dire Bear Form"]..", "..S["Righteous Fury"].." o "..S["Defensive Stance"]..".";

		L["SETTINGS_PVP"] = "Activar en PvP";
		L["SETTINGS_PVP_DESC"] = "activar anuncios en campos de batalla y arena";

		L["SETTINGS_HOP"] = "Desactivar MdP";
		L["SETTINGS_HOP_DESC"] = "activar o desactivar la desactivación automática de "..S["Hand of Protection"];

		L["SETTINGS_WOTN_ANNOUNCE"] = "Anuncio de VdlN";
		L["SETTINGS_WOTN_ANNOUNCE_DESC"] = "activar o desactivar "..S["Will of the Necropolis"].." salvos";

		L["SETTINGS_SECONDARY_OUTPUT"] = "Secondary Output";
		L["SETTINGS_SECONDARY_OUTPUT_DESC"] = "sets an optional secondary announcement channel via LibSink; target can be an SCT addon such as Parrot, MSBT, etc";

		L["SETTINGS_WOTN_TEXT"] = "Texto del anuncio";
		L["SETTINGS_WOTN_TEXT_DESC"] = "establece el texto que se anunciará cuando "..S["Will of the Necropolis"].." le ahorra";

		L["SETTINGS_AD_ANNOUNCE"] = "Anuncio de DC";
		L["SETTINGS_AD_ANNOUNCE_DESC"] = "activar o desactivar "..S["Ardent Defender"].." salvos";

		L["SETTINGS_AD_TEXT"] = "Texto del anuncio";
		L["SETTINGS_AD_TEXT_DESC"] = "establece el texto que se anunciará cuando "..S["Ardent Defender"].." le ahorra";

		L["SETTINGS_AD_ANNOUNCEHEAL"] = "Anuncio de Sanación DC";
		L["SETTINGS_AD_ANNOUNCEHEAL_DESC"] = "activar o desactivar los anuncios de "..S["Ardent Defender"].." cura cuando usted";

		L["SETTINGS_AD_HEALTEXT"] = "Texto del anuncio";
		L["SETTINGS_AD_HEALTEXT_DESC"] = "establece el texto que se anunciará cuando "..S["Ardent Defender"].." que cura";

		L["SETTINGS_AD_CDBAR"] = "DC Reutilización";
		L["SETTINGS_AD_CDBAR_DESC"] = "activar una barra para indicar cuánto tiempo se mantiene antes de "..S["Ardent Defender"].." puede sanar de nuevo";

		L["SETTINGS_CDBAR_TEXTURE"] = "Barra Textura";
		L["SETTINGS_CDBAR_TEXTURE_DESC"] = "configura la textura que se utilizarán para la barra de estado";

		L["SETTINGS_ADHEAL_EHTTL"] = "DC Curación en SE/TV";
		L["SETTINGS_ADHEAL_EHTTL_DESC"] = "incluir la curación de la DC en los cálculos de la salud eficaz y el tiempo de vivir";

		L["SETTINGS_WOTN_CDBAR"] = "VdlN Reutilización";
		L["SETTINGS_WOTN_CDBAR_DESC"] = "mostrar una barra que indica cuánto tiempo antes de "..S["Will of the Necropolis"].." se puede activar de nuevo";

		L["SETTINGS_WOTN_EHTTL"] = "WOTN in EH/TTL";
		L["SETTINGS_WOTN_EHTTL_DESC"] = "include the single hit mitigated by WOTN in calculations of EH (but not NEH) and expected time-to-live";

		L["SETTINGS_STATS_RESET"] = "Puesto de las Estadísticas";
		L["SETTINGS_STATS_RESET_DESC"] = "restablecer las estadísticas de lucha contra la";

		L["SETTINGS_PERFIGHT"] = "Luchas Individuales";
		L["SETTINGS_PERFIGHT_DESC"] = "marque esta casilla de verificación para eliminar las estadísticas cuando se inicia el combate y la impresión de un breve informe cuando se termine. Desactive la casilla para simplemente grabar un total acumulado.";
end
