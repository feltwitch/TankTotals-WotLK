
local S = TankTotals.S;
local media = LibStub("LibSharedMedia-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

-- register TwCenMT and Minimalist regardless of SharedMedia
media:Register("font", "TwCenMT", [[Interface\Addons\TankTotals\Media\Fonts\Tw_Cen_MT_Bold.TTF]]);
media:Register("statusbar", "Minimalist", [[Interface\AddOns\TankTotals\Media\Textures\BarTexture.tga]]);

-- register sound effects for taunt misses
media:Register("sound", "Quake: Thud", [[Interface\AddOns\TankTotals\Media\Sounds\quake_thud.wav]]);
media:Register("sound", "Quake: Bloop", [[Interface\AddOns\TankTotals\Media\Sounds\quake_bloop.wav]]);
media:Register("sound", "Quake: Quad Damage", [[Interface\AddOns\TankTotals\Media\Sounds\quake_quad_damage.wav]]);

-- loaded at runtime
TankTotals.QH = nil;
TankTotals.NEH = nil;
TankTotals.LDB = nil;
TankTotals.ClassModule = nil;

-- quickhealth variables
TankTotals.PlayerQuickHealth = 0;
TankTotals.PlayerQuickHealthMax = 0;

local playerLevel = UnitLevel("player");
local playerLevelFlooredToTens = math.floor(playerLevel / 10) * 10;

local ratingConversions = {
        hit = {
                [70] = 15.7722,
                [80] = 32.78998947,
        },
        defense = {
                [70] = 2.36634,
                [80] = 4.918498039,
        },
        expertise = {
                [70] = 3.94366,
                [80] = 8.1974973675,
        }
}

-- constants
TankTotals.MISS_PER_DEF_SKILL = 0.04;
TankTotals.HIT_RATING_PERCENT = ratingConversions.hit[playerLevelFlooredToTens];
TankTotals.DEF_RATING_PER_SKILL = ratingConversions.defense[playerLevelFlooredToTens];
TankTotals.EXP_RATING_PER_SKILL = ratingConversions.expertise[playerLevelFlooredToTens];

-- constants for NEH table indices
TankTotals.INDEX_BLEED = 0; TankTotals.INDEX_MELEE = 1;
TankTotals.INDEX_HOLY = 2; TankTotals.INDEX_FIRE = 4;
TankTotals.INDEX_NATURE = 8; TankTotals.INDEX_FROST = 16;
TankTotals.INDEX_SHADOW = 32; TankTotals.INDEX_ARCANE = 64;
TankTotals.INDEX_UNRESISTIBLE = 127;

-- mixed schools
TankTotals.INDEX_FIRESTORM = 12; TankTotals.INDEX_FROSTFIRE = 20;
TankTotals.INDEX_FROSTSTORM = 24; TankTotals.INDEX_SHADOWSTORM = 40;
TankTotals.INDEX_SHADOWFROST = 48; TankTotals.INDEX_SPELLFIRE = 68;

TankTotals.MixedMagicMap =
{
        [TankTotals.INDEX_FIRESTORM] = { TankTotals.INDEX_FIRE, TankTotals.INDEX_NATURE },
        [TankTotals.INDEX_FROSTFIRE] = { TankTotals.INDEX_FIRE, TankTotals.INDEX_FROST },
        [TankTotals.INDEX_FROSTSTORM] = { TankTotals.INDEX_FROST, TankTotals.INDEX_NATURE },
        [TankTotals.INDEX_SHADOWSTORM] = { TankTotals.INDEX_SHADOW, TankTotals.INDEX_NATURE },
        [TankTotals.INDEX_SHADOWFROST] = { TankTotals.INDEX_SHADOW, TankTotals.INDEX_FROST },
        [TankTotals.INDEX_SPELLFIRE] = { TankTotals.INDEX_FIRE, TankTotals.INDEX_ARCANE },
}

-- basic stats
TankTotals.BlockCap = 0;
TankTotals.BlockChance = 0;
TankTotals.Avoidance = 0;
TankTotals.ArmorMitigation = 0;
TankTotals.PhysicalMitigation = 0;

-- final mitigation values as per the above indices
-- spell schools are drawn from guaranteed mitigation and minimum resistance
TankTotals.FinalMitigation = getSchoolTable(1, true, true);

-- average spell mitigation including guaranteed mitigation and average resistance
TankTotals.AverageSpellMitigation = getSchoolTable(1, false, true);

-- these tables are PURELY resistance mitigation, they do not include guaranteed mitigation
-- MinResistances is used to feed the corresponding entries in FinalMitigation table
-- AvgResistances feeds AverageSpellMitigation
TankTotals.AvgResistances = getSchoolTable(1, false, true);
TankTotals.MinResistances = getSchoolTable(1, false, true);
TankTotals.RacialResistances = getSchoolTable(1, false, true);

-- bleed, melee, holy, fire, nature, frost, shadow, arcane, unresistible
TankTotals.SchoolNames =
{
    [TankTotals.INDEX_BLEED] = L["BLEED"], [TankTotals.INDEX_MELEE] = L["MELEE"],

    [TankTotals.INDEX_HOLY] = L["HOLY"], [TankTotals.INDEX_FIRE] = L["FIRE"],
    [TankTotals.INDEX_NATURE] = L["NATURE"], [TankTotals.INDEX_FROST] = L["FROST"],
    [TankTotals.INDEX_SHADOW] = L["SHADOW"], [TankTotals.INDEX_ARCANE] = L["ARCANE"],

    [TankTotals.INDEX_FIRESTORM] = L["FIRESTORM"], [TankTotals.INDEX_FROSTFIRE] = L["FROSTFIRE"],
    [TankTotals.INDEX_FROSTSTORM] = L["FROSTSTORM"], [TankTotals.INDEX_SHADOWSTORM] = L["SHADOWSTORM"],
    [TankTotals.INDEX_SHADOWFROST] = L["SHADOWFROST"], [TankTotals.INDEX_SPELLFIRE] = L["SPELLFIRE"],

    [TankTotals.INDEX_UNRESISTIBLE] = L["UNRESISTIBLE"],
};

TankTotals.SchoolColors =
{
    [TankTotals.INDEX_BLEED] = "|cffff0000", [TankTotals.INDEX_MELEE] = "|cffff0000",

    [TankTotals.INDEX_HOLY] = "|cffffff00", [TankTotals.INDEX_FIRE] = "|cffff6103",
    [TankTotals.INDEX_NATURE] = "|cff4dbd33", [TankTotals.INDEX_FROST] = "|cff0198e1",
    [TankTotals.INDEX_SHADOW] = "|cff871f78", [TankTotals.INDEX_ARCANE] = "|cffffffff",

    [TankTotals.INDEX_FIRESTORM] = "|cffCC9900", [TankTotals.INDEX_FROSTFIRE] = "|cff807CF2",
    [TankTotals.INDEX_FROSTSTORM] = "|cff009999", [TankTotals.INDEX_SHADOWSTORM] = "|cff6A6E55",
    [TankTotals.INDEX_SHADOWFROST] = "|cff6666FF", [TankTotals.INDEX_SPELLFIRE] = "|cffA68F1B",

    [TankTotals.INDEX_UNRESISTIBLE] = "|cff999999",
};

-- bonus miss from talents/race
TankTotals.NonDRMiss = 5;

-- mitigation due to stance/buffs/etc.
TankTotals.PassiveMitigation = 1.0;	-- shield of the templar, etc
TankTotals.MitigationFromBuffs = 1.0;	-- righteous fury, etc

TankTotals.PassivePhysicalMitigation = 1.0;   -- nothing yet
TankTotals.PhysicalMitigationFromBuffs = 1.0;   -- DK t8 4-set, post-3.2 Imp LoH, etc

TankTotals.PassiveSpellMitigation = 1.0;	-- guarded by the light, etc
TankTotals.SpellMitigationFromBuffs = 1.0;	-- improved defensive stance, etc

TankTotals.PassiveProbSpellMitigation = 1.0;	-- divine purpose, improved spell reflection, etc
TankTotals.ProbSpellMitigationFromBuffs = 1.0;	-- spell deflection is a bitch

TankTotals.ProbSpellMitigation = 1.0;	        -- general mitigation * guaranteed spell mitigation * prob spell mitigation
TankTotals.GuaranteedSpellMitigation = 1.0;	-- general mitigation * guaranteed spell mitigation

-- effulgent skyflare
TankTotals.ESFD = 1.0;

-- cooldowns monitored by TankTotals
-- specific abilities supplied by class modules
TankTotals.TargettedCDs = { };
TankTotals.SelfCooldowns = { };

-- dual-spec index
TankTotals.ActiveSpec = 0;

-- mitigation buffs that can be given by other players
-- self buffs are registered by class modules
TankTotals.MitigationBuffs =
{
		[S["Greater Blessing of Sanctuary"]] = 0.97,
		[S["Blessing of Sanctuary"]] = 0.97,
		[S["Renewed Hope"]] = 0.97,
		[S["Vigilance"]] = 0.97,
		[S["Hand of Sacrifice"]] = 0.7,
		[S["Divine Sacrifice"]] = 1.0,                  -- dummy value to trigger recalc
		[S["Divine Guardian"]] = 0.8,                   -- 2 points gives 20% reduction; no point in speccing 1/2
		[S["Roar of Sacrifice"]] = 0.7,
		[S["Pain Suppression"]] = 0.6,
		[S["Safeguard"]] = 0.7,                         -- 2 points gives 30% reduction; no point in speccing 1/2
};

TankTotals.SpellMitigationBuffs = { [S["Anti-Magic Zone"]] = 0.25 };

-- the following talents can give less than the stated amounts, but it would be unusual not to spec 2/2 or 3/3
TankTotals.PhysicalMitigationBuffs = { [S["Lay on Hands"]] = 0.8, [S["Inspiration"]] = 0.9, [S["Ancestral Fortitude"]] = 0.9 };

-- settings for each orientation option
TankTotals.GrowOpts =
{
    ["UP"] =
    {
        ["TITLETEXT"] = "TankTotals ",
        [0] = L["TITLE_NORMAL"],
        [3] = L["TITLE_BOSSES"],
        ["LEFT"] =
            { [1] = "BOTTOMLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "TOPLEFT", [4] = 0, [5] = 5 },
        ["RIGHT"] =
            { [1] = "TOPLEFT", frame = function() return TankTotals.LEFT.frame; end, [3] = "TOPRIGHT", [4] = 5, [5] = 0 },
        ["ADCD"] = { [1] = "TOPLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "BOTTOMLEFT", [4] = 0, [5] = -10 },
    },
    ["DOWN"] =
    {
        ["TITLETEXT"] = "TankTotals ",
        [0] = L["TITLE_NORMAL"],
        [3] = L["TITLE_BOSSES"],
        ["LEFT"] =
            { [1] = "TOPLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "BOTTOMLEFT", [4] = 0, [5] = 0 },
        ["RIGHT"] =
            { [1] = "TOPLEFT", frame = function() return TankTotals.LEFT.frame; end, [3] = "TOPRIGHT", [4] = 5, [5] = 0 },
        ["ADCD"] = { [1] = "BOTTOMLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "TOPLEFT", [4] = 0, [5] = 5 },
    },
    ["LEFT"] =
    {
        ["TITLETEXT"] = "T\nT\n",
        [0] = "8\n0",
        [3] = "8\n3",
        ["LEFT"] =
            { [1] = "TOPRIGHT", frame = function() return TankTotals.RIGHT.frame; end, [3] = "TOPLEFT", [4] = -5, [5] = 0 },
        ["RIGHT"] =
            { [1] = "TOPRIGHT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "TOPLEFT", [4] = 0, [5] = 0 },
        ["ADCD"] = { [1] = "BOTTOMLEFT", frame = function() return TankTotals.LEFT.frame; end, [3] = "TOPLEFT", [4] = 0, [5] = 5 },
    },
    ["RIGHT"] =
    {
        ["TITLETEXT"] = "T\nT\n",
        [0] = "8\n0",
        [3] = "8\n3",
        ["LEFT"] =
            { [1] = "TOPLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "TOPRIGHT", [4] = 0, [5] = 0 },
        ["RIGHT"] =
            { [1] = "TOPLEFT", frame = function() return TankTotals.LEFT.frame; end, [3] = "TOPRIGHT", [4] = 5, [5] = 0 },
        ["ADCD"] = { [1] = "BOTTOMLEFT", frame = function() return TankTotals.TitleBar.frame; end, [3] = "TOPRIGHT", [4] = 0, [5] = 5 },
    },
};

local selectedSchool = TankTotals.INDEX_MELEE;

-- Ace config table
TankTotals.ConfigTable =
{	name="TankTotals",
	type="group",
	args=
	{
		General =
		{
			order = 1,
			type = "group",
			name = L["SETTINGS_GENERAL"],
			desc = L["SETTINGS_GENERAL_DESC"],
			args =
			{
				active=
				{
					type="toggle", order = 1, name=L["SETTINGS_ENABLED"], desc=L["SETTINGS_ENABLED_DESC"],
					get=function() return TTPCDB.AddonActive end,
					set=function() TTPCDB.AddonActive = (not TTPCDB.AddonActive); if TTPCDB.AddonActive then TankTotals:Enable(); else TankTotals:Disable(); end end
				},
				spec1=
				{
					type="toggle", order = 2, name=L["SETTINGS_ENABLED_SPEC1"], desc=L["SETTINGS_ENABLED_PERSPEC_DESC"],
                                        disabled = function() return (not TTPCDB.AddonActive); end,
					get=function() return TTPCDB.ActiveInSpec[1] end,
					set=function() TTPCDB.ActiveInSpec[1] = (not TTPCDB.ActiveInSpec[1]); end
				},
				spec2=
				{
					type="toggle", order = 3, name=L["SETTINGS_ENABLED_SPEC2"], desc=L["SETTINGS_ENABLED_PERSPEC_DESC"],
                                        disabled = function() return (not TTPCDB.AddonActive); end,
					get=function() return TTPCDB.ActiveInSpec[2] end,
					set=function() TTPCDB.ActiveInSpec[2] = (not TTPCDB.ActiveInSpec[2]); end
				},
				bossvalues=
				{
					type="toggle", order = 4, name=L["SETTINGS_BOSSVALUES"], desc=L["SETTINGS_BOSSVALUES_DESC"],
                                        disabled = function() return (not TTPCDB.AddonActive); end,
					get=function() return (TTDB.EnemyLevelDiff == 3) end,
					set=function() if (TTDB.EnemyLevelDiff == 0) then TTDB.EnemyLevelDiff = 3 else TTDB.EnemyLevelDiff = 0; end TankTotals:UpdateTotals(); end
				},
				removeHoP=
				{
					type="toggle", order = 5, name=L["SETTINGS_HOP"], desc=L["SETTINGS_HOP_DESC"],
                                        disabled = function() return (not TTPCDB.AddonActive); end,
					get=function() return TTPCDB.HoP_B_Gone end,
					set=function() TTPCDB.HoP_B_Gone = (not TTPCDB.HoP_B_Gone); end
				},
				--[[
                                accuracy=
				{
					type="range", order = 6, name=L["SETTINGS_DECIMAL"], desc=L["SETTINGS_DECIMAL_DESC"],
					min=1, max=10, step=1, isPercent=false,
					get=function() return TTDB.DecimalAccuracy end,
					set=function(info, x) TTDB.DecimalAccuracy = x; TankTotals:UpdateTotals(); end
				},
                                --]]
			},
		},

		Damage =
		{
			order = 2,
			type = "group",
			name = L["SETTINGS_DAMAGE"],
			desc = L["SETTINGS_DAMAGE_DESC"],
                        disabled = function() return (not TTPCDB.AddonActive); end,
			args =
			{
				showNEH=
				{
					type="toggle", order = 1, name=L["SETTINGS_SHOWNEH"], desc=L["SETTINGS_SHOWNEH_DESC"],
					get=function() return TTDB.ShowNEH end,
					set=function() TTDB.ShowNEH = (not TTDB.ShowNEH); TankTotals:UpdateTotals(); end
				},
				recordNEH=
				{
					type="toggle", order = 2, name=L["SETTINGS_RECORD_NEHXY"], desc=L["SETTINGS_RECORD_NEHXY_DESC"],
					get=function() return TTPCDB.RecordNEHXY end,
					set=function() TTPCDB.RecordNEHXY = (not TTPCDB.RecordNEHXY); if TTPCDB.RecordNEHXY then TankTotals.NEH:Enable(); else TankTotals.NEH:Disable(); end end
				},
				incAvoid=
				{
					type="toggle", order = 4, name=L["SETTINGS_NEH_INCLUDEAVOID"], desc=L["SETTINGS_NEH_INCLUDEAVOID_DESC"],
					get=function() return TTDB.AvoidsNEH end,
					set=function() TTDB.AvoidsNEH = (not TTDB.AvoidsNEH); if TTPCDB.NEH_DATA then TankTotals.NEH:AdoptData(TTPCDB.SelectedNEHData); end end
				},
				eh2Data=
				{
					type="select", order = 5, name=L["SETTINGS_NEH_CHOOSEDATA"], desc=L["SETTINGS_NEH_CHOOSEDATA_DESC"],
					values =
                                                function()
                                                        local segments = { };

                                                        for k,_ in pairs(TTDB.SavedNEHData) do
                                                                segments[k] = k;
                                                        end

                                                        return segments;
                                                end,
					get =	function(info) return TTPCDB.SelectedNEHData; end,
					set =	function(info, dataTitle)
                                                        if dataTitle == L["NONE"] then
                                                                TankTotals.NEH:ResetRecordedData();
                                                        else
                                                                TankTotals.NEH:AdoptData(dataTitle);
                                                        end
                                                end,
				},
				reloadEH2Data=
				{
					type="execute", order = 6, name=L["SETTINGS_NEH_RELOAD"], desc=L["SETTINGS_NEH_RELOAD_DESC"],
					func = function() if TTPCDB.SelectedNEHData ~= L["NONE"] then TankTotals.NEH:AdoptData(TTPCDB.SelectedNEHData); end end,
				},
				saveEH2Data=
				{
					type="execute", order = 7, name=L["SETTINGS_NEH_SAVEDATA"], desc=L["SETTINGS_NEH_SAVEDATA_DESC"],
					func = function() if TTPCDB.NEH_DATA then TankTotals.NEH:SaveDataSegment(); end end,
				},
				deleteEH2Data=
				{
					type="execute", order = 8, name=L["SETTINGS_NEH_DELETEDATA"], desc=L["SETTINGS_NEH_DELETEDATA"],
					func = function() if TTPCDB.NEH_DATA then TankTotals.NEH:DeleteDataSegment(); end end,
				},
				printReport=
				{
					type="execute", order = 9, name=L["SETTINGS_NEH_PRINTREPORT"], desc=L["SETTINGS_NEH_PRINTREPORT_DESC"],
					func = function() if TTPCDB.NEH_DATA then TankTotals.NEH:PrintReport(TTPCDB.NEH_DATA); else TankTotals:Print("|cffff0000"..L["NEH_NODATA"]); end end
				},
                                eh2sliders=
                                {
					type="group", order = 12, name=L["SETTINGS_NEH_SLIDERS"], desc=L["SETTINGS_NEH_SLIDERS_DESC"],
					args=
                                        {
                                                profiles=
                                                {
                                                        type="select", order = 1, name=L["SETTINGS_NEH_PERCENTPROFILES"], desc=L["SETTINGS_NEH_PERCENTPROFILES_DESC"],
                                                        values =
                                                                function()
                                                                        local profiles = { };

                                                                        for k,_ in pairs(TTDB.SavedNEHProfiles) do
                                                                                profiles[k] = k;
                                                                        end

                                                                        return profiles;
                                                                end,
                                                        get =	function(info) return TTPCDB.SelectedNEHProfile; end,
                                                        set =	function(info, profile) TankTotals.NEH:AdoptProfile(profile); end,
                                                },
                                                reloadProfile=
                                                {
                                                        type="execute", order = 2, name=L["SETTINGS_NEH_RELOAD_PROFILE"], desc=L["SETTINGS_NEH_RELOAD_PROFILE_DESC"],
                                                        func = function() TankTotals.NEH:AdoptProfile(TTPCDB.SelectedNEHProfile); end,
                                                },
                                                saveProfile=
                                                {
                                                        type="input", order = 3, name=L["SETTINGS_SAVE_NEH_SLIDERS"], desc=L["SETTINGS_SAVE_NEH_SLIDERS_DESC"],
                                                        get=function() return TTPCDB.SelectedNEHProfile; end,
                                                        set=function(info, x) if x ~= "" then TankTotals.NEH:SaveProfile(x); end end
                                                },
                                                deleteProfile=
                                                {
                                                        type="execute", order = 4, name=L["SETTINGS_DELETE_NEH_SLIDERS"], desc=L["SETTINGS_DELETE_NEH_SLIDERS_DESC"],
                                                        func = function() if TTPCDB.SelectedNEHProfile ~= L["DEFAULT"] then TankTotals.NEH:DeleteProfile(TTPCDB.SelectedNEHProfile); end end
                                                },
                                                resetPercents=
                                                {
                                                        type="execute", order = 5, name=L["SETTINGS_RESET_NEH_SLIDERS"], desc=L["SETTINGS_RESET_NEH_SLIDERS_DESC"],
                                                        func = function() TankTotals.NEH:ResetPercentages(); end
                                                },
                                                impExpHead=
                                                {
                                                        type="header", order = 6, name=L["SETTINGS_NEH_IMPEXP_HEADING"],
                                                },
                                                importProfiles=
                                                {
                                                        type="execute", order = 7, name=L["SETTINGS_NEH_IMPORT"], desc=L["SETTINGS_NEH_IMPORT_DESC"],
                                                        func = function() TankTotals.NEH:ImportProfileSet(); end
                                                },
                                                exportProfiles=
                                                {
                                                        type="execute", order = 8, name=L["SETTINGS_NEH_EXPORT"], desc=L["SETTINGS_NEH_EXPORT_DESC"],
                                                        func = function() TankTotals.NEH:ExportProfileSet(); end
                                                },
                                                customHead=
                                                {
                                                        type="header", order = 9, name=L["SETTINGS_NEH_CUSTOMSPELLS_HEADING"],
                                                },
                                                customSchool=
                                                {
                                                        type="select", order = 10, name=L["SETTINGS_NEH_CUSTOM_SCHOOL"], desc=L["SETTINGS_NEH_CUSTOM_SCHOOL_DESC"],
                                                        values =
                                                                function()
                                                                        local schoolIndices = { };

                                                                        for k,v in pairs(TankTotals.SchoolNames) do
                                                                                schoolIndices[k] = v;
                                                                        end

                                                                        return schoolIndices;
                                                                end,
                                                        get =	function(info) return selectedSchool; end,
                                                        set =	function(info, school) selectedSchool = school; end,
                                                },
                                                customSpell=
                                                {
                                                        type="input", order = 11, name="", desc=L["SETTINGS_NEH_CUSTOM_SPELL_DESC"],
                                                        set=function(info, x) TankTotals.NEH:AddCustomSpell(x, selectedSchool); end
                                                },
                                                printSpellList=
                                                {
                                                        type="execute", order = 12, name=L["SETTINGS_NEH_PRINT_SPELLS"], desc=L["SETTINGS_NEH_PRINT_SPELLS_DESC"],
                                                        func = function() TankTotals.NEH:PrintCustomSpells(); end
                                                },
                                                slidersHead=
                                                {
                                                        type="header", order = 13, name=L["SETTINGS_NEH_SLIDERS_HEADING"],
                                                },
                                                melee=
                                                {
                                                        type="range", order = 14, name=L["MELEE"], desc=L["SETTINGS_MELEE_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true, disabled=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_MELEE]; end,
                                                        set=function(info, x) end -- do nothing, it's non-interactive
                                                },
                                                bleed=
                                                {
                                                        type="range", order = 15, name=L["BLEED"], desc=L["SETTINGS_BLEED_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_BLEED]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_BLEED, x); TankTotals:UpdateTotals(); end
                                                },
                                                holy=
                                                {
                                                        type="range", order = 16, name=L["HOLY"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_HOLY]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_HOLY, x); TankTotals:UpdateTotals(); end
                                                },
                                                fire=
                                                {
                                                        type="range", order = 17, name=L["FIRE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_FIRE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_FIRE, x); TankTotals:UpdateTotals(); end
                                                },
                                                nature=
                                                {
                                                        type="range", order = 18, name=L["NATURE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_NATURE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_NATURE, x); TankTotals:UpdateTotals(); end
                                                },
                                                frost=
                                                {
                                                        type="range", order = 19, name=L["FROST"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_FROST]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_FROST, x); TankTotals:UpdateTotals(); end
                                                },
                                                shadow=
                                                {
                                                        type="range", order = 20, name=L["SHADOW"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_SHADOW]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_SHADOW, x); TankTotals:UpdateTotals(); end
                                                },
                                                arcane=
                                                {
                                                        type="range", order = 21, name=L["ARCANE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_ARCANE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_ARCANE, x); TankTotals:UpdateTotals(); end
                                                },
                                                firestorm=
                                                {
                                                        type="range", order = 22, name=L["FIRESTORM"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_FIRESTORM]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_FIRESTORM, x); TankTotals:UpdateTotals(); end
                                                },
                                                frostfire=
                                                {
                                                        type="range", order = 23, name=L["FROSTFIRE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_FROSTFIRE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_FROSTFIRE, x); TankTotals:UpdateTotals(); end
                                                },
                                                froststorm=
                                                {
                                                        type="range", order = 24, name=L["FROSTSTORM"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_FROSTSTORM]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_FROSTSTORM, x); TankTotals:UpdateTotals(); end
                                                },
                                                shadowstorm=
                                                {
                                                        type="range", order = 25, name=L["SHADOWSTORM"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_SHADOWSTORM]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_SHADOWSTORM, x); TankTotals:UpdateTotals(); end
                                                },
                                                shadowfrost=
                                                {
                                                        type="range", order = 26, name=L["SHADOWFROST"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_SHADOWFROST]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_SHADOWFROST, x); TankTotals:UpdateTotals(); end
                                                },
                                                spellfire=
                                                {
                                                        type="range", order = 27, name=L["SPELLFIRE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_SPELLFIRE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_SPELLFIRE, x); TankTotals:UpdateTotals(); end
                                                },
                                                unresistible=
                                                {
                                                        type="range", order = 28, name=L["UNRESISTIBLE"], desc=L["SETTINGS_NEHXY_PERC_DESC"],
                                                        min=0, max=1.0, step=0.001, isPercent=true,
                                                        get=function() return TTPCDB.NEHXY[TankTotals.INDEX_UNRESISTIBLE]; end,
                                                        set=function(info, x) TankTotals.NEH:SetPercentage(TankTotals.INDEX_UNRESISTIBLE, x); TankTotals:UpdateTotals(); end
                                                },
                                        },
                                },
                                ttloptions=
                                {
					type="group", order = 14, name=L["SETTINGS_TTL_OPTIONS"], desc=L["SETTINGS_TTL_OPTIONS_DESC"],
					args=
                                        {
                                                meleeAmount=
                                                {
                                                        type="range", order = 1, name=L["SETTINGS_HITAMOUNT"], desc=L["SETTINGS_HITAMOUNT_DESC"],
                                                        min=0, max=150000, step=1000, isPercent=false,
                                                        get=function() return TTPCDB.MobHitAmount or 50000 end,
                                                        set=function(info, x) TTPCDB.MobHitAmount = x; TankTotals:UpdateTotals(); end
                                                },
                                                parryhaste=
                                                {
                                                        type="toggle", order = 2, name=L["SETTINGS_PARRYHASTE"], desc=L["SETTINGS_PARRYHASTE_DESC"],
                                                        get=function() return TTDB.ParryHaste end,
                                                        set=function() TTDB.ParryHaste = (not TTDB.ParryHaste); TankTotals:UpdateTotals(); end
                                                },
                                                continuous=
                                                {
                                                        type="toggle", order = 3, name=L["SETTINGS_TTL_CONTINUOUS"], desc=L["SETTINGS_TTL_CONTINUOUS_DESC"],
                                                        get=function() return TTDB.ContinuousDmg end,
                                                        set=function() TTDB.ContinuousDmg = (not TTDB.ContinuousDmg); TankTotals:UpdateTotals(); end
                                                },
                                        },
                                },
			},
		},

		Appearance =
		{
			order = 3,
			type = "group",
			name = L["SETTINGS_APPEARANCE"],
			desc = L["SETTINGS_APPEARANCE_DESC"],
                        disabled = function() return (not TTPCDB.AddonActive); end,
			args =
			{
				display=
				{
					type="toggle", order = 1, name=L["SETTINGS_STANDALONE"], desc=L["SETTINGS_STANDALONE_DESC"],
					get=function() return TTPCDB.ShowSummary end,
					set=function() TTPCDB.ShowSummary = (not TTPCDB.ShowSummary); if TTPCDB.ShowSummary then TankTotals:UpdateDisplayText(); else TankTotals:SetShown(false); end end
				},
				mouseover=
				{
					type="toggle", order = 2, name=L["SETTINGS_POPUP"], desc=L["SETTINGS_POPUP_DESC"],
					get=function() return TTDB.PopUp; end,
					set=function() TTDB.PopUp = (not TTDB.PopUp); if(TTDB.PopUp and TankTotals.LEFT.text:IsVisible()) or not(TTDB.PopUp or TankTotals.LEFT.text:IsVisible()) then TankTotals:WindowBlinds(); end end
				},
				--[[ldbstatstext=
				{
					type="toggle", order = 3, name=L["SETTINGS_LDBTEXT"], desc=L["SETTINGS_LDBTEXT_DESC"],
					get=function() return TTDB.LDBStatsText; end,
					set=function() TTDB.LDBStatsText = (not TTDB.LDBStatsText); TankTotals:UpdateTotals(); end
				},--]]
				magicschools=
				{
					type="toggle", order = 3, name=L["SETTINGS_RES"], desc=L["SETTINGS_RES_DESC"],
					get=function() return TTDB.ShowResistances end,
					set=function() TTDB.ShowResistances = (not TTDB.ShowResistances); TankTotals:UpdateTotals(); end
				},
				scale=
				{
					type="range", order = 4, name=L["SETTINGS_SCALE"], desc=L["SETTINGS_SCALE_DESC"],
					min=0.1, max=2.0, step=0.05, isPercent=false,
					get=function() return TTPCDB.WindowScale end,
					set=function(info, x) TTPCDB.WindowScale = x; TankTotals:SetScale(TTPCDB.WindowScale); end
				},
				font=
				{
					type="select", order = 5, dialogControl = "LSM30_Font", name=L["SETTINGS_FONT"], desc=L["SETTINGS_FONT_DESC"],
					values = AceGUIWidgetLSMlists.font,
					get =	function(info) return TTDB.Font; end,
					set =	function(info, font) TTDB.Font = font; TankTotals:UpdateFont(); end
				},
				fontoutline=
				{
					type="select", order = 6, name=L["SETTINGS_FONTOUTLINE"], desc=L["SETTINGS_FONTOUTLINE_DESC"],
					values = { NONE=L["NONE"], THINOUTLINE="THINOUTLINE", THICKOUTLINE="THICKOUTLINE" },
					get =	function(info) return TTDB.FontOutline; end,
					set =	function(info, outline) TTDB.FontOutline = outline; TankTotals:UpdateFont(); end
				},
				growdir=
				{
					type="select", order = 7, name=L["SETTINGS_GROWDIR"], desc=L["SETTINGS_GROWDIR_DESC"],
					values = { UP="UP", DOWN="DOWN", LEFT="LEFT", RIGHT="RIGHT" },
					get =	function(info) return TTPCDB.GrowDir or "DOWN"; end,
					set =	function(info, gDir) TTPCDB.GrowDir = gDir; TankTotals:SetGrowthDirection(); end
				},
			},
		},

		Announce =
		{
			order = 4,
			type = "group",
			name = L["SETTINGS_ANNOUNCE"],
			desc = L["SETTINGS_ANNOUNCE_DESC"],
                        disabled = function() return (not TTPCDB.AddonActive); end,
			args =
			{
				cooldowns=
				{
					type="toggle", order = 1, name=L["SETTINGS_COOLDOWNS"], desc=L["SETTINGS_COOLDOWNS_DESC"],
					get=function() return TTPCDB.CooldownAnnounce end,
					set=function() TTPCDB.CooldownAnnounce = (not TTPCDB.CooldownAnnounce); end
				},
				tauntmiss=
				{
					type="toggle", order = 2, name=L["SETTINGS_TAUNTMISS"], desc=L["SETTINGS_TAUNTMISS_DESC"],
					get=function() return TTPCDB.TauntMissAnnounce end,
					set=function() TTPCDB.TauntMissAnnounce = (not TTPCDB.TauntMissAnnounce); end
				},
				tauntmissSound=
				{
					type="select", order = 4, dialogControl = "LSM30_Sound", name=L["SETTINGS_TAUNTMISS_SOUND"], desc=L["SETTINGS_TAUNTMISS_SOUND_DESC"],
					values = AceGUIWidgetLSMlists.sound,
					get =	function(info) return TTDB.TauntMissSound; end,
					set =	function(info, sound) TTDB.TauntMissSound = sound; end
				},
				channel=
				{
					type="select", order = 5, name=L["SETTINGS_CHANNEL"], desc=L["SETTINGS_CHANNEL_DESC"],
					values = { NONE=L["NONE"], YELL="YELL", SAY="SAY", PARTY="PARTY", RAID="RAID", RAID_WARNING="RAID_WARNING", GUILD="GUILD", OFFICER="OFFICER", BATTLEGROUND="BATTLEGROUND", EMOTE="EMOTE" },
					get =	function(info) return TTDB.AnnounceChannel; end,
					set =	function(info, channelName) TTDB.AnnounceChannel = channelName; end
				},
				instancesonly=
				{
					type="toggle", order = 6, name=L["SETTINGS_INSTANCE"], desc=L["SETTINGS_INSTANCE_DESC"],
					get=function() return TTPCDB.InstanceAnnounce end,
					set=function() TTPCDB.InstanceAnnounce = (not TTPCDB.InstanceAnnounce); end
				},
				stancesonly=
				{
					type="toggle", order = 7, name=L["SETTINGS_STANCE"], desc=L["SETTINGS_STANCE_DESC"],
					get=function() return TTPCDB.StanceAnnounce end,
					set=function() TTPCDB.StanceAnnounce = (not TTPCDB.StanceAnnounce); end
				},
				pvp=
				{
					type="toggle", order = 8, name=L["SETTINGS_PVP"], desc=L["SETTINGS_PVP_DESC"],
					get=function() return TTPCDB.PVPAnnounce end,
					set=function() TTPCDB.PVPAnnounce = (not TTPCDB.PVPAnnounce); end
				},
			},
		},

                resetpos=
                {
                        type="execute", order = 6, name=L["SETTINGS_RESETPOS"], desc=L["SETTINGS_RESETPOS_DESC"],
                        disabled = function() return (not TTPCDB.AddonActive); end,
                        func = function() TTPCDB.AnchorPos = { [0] = -1, [1] = -1 }; TankTotals:MoveAnchorPos(TTPCDB.AnchorPos[0], TTPCDB.AnchorPos[1]); end
                },
	},
}

-- console-only commands
TankTotals.ConsoleCommands=
{	name="TankTotalsCLI",
	type="group",
	args=
	{
                config=
                {
                        type="execute", order = 1, name=L["SETTINGS_GUI"], desc=L["SETTINGS_GUI_DESC"], guiHidden=true,
                        func=function() LibStub("AceConfigDialog-3.0"):Open("TankTotals"); end
                },
                removeHoP=
                {
                        type="toggle", order = 2, name=L["SETTINGS_HOP"], desc=L["SETTINGS_HOP_DESC"],
                        get=function() return TTPCDB.HoP_B_Gone end,
                        set=function() TTPCDB.HoP_B_Gone = (not TTPCDB.HoP_B_Gone); end
                },
        },
}
