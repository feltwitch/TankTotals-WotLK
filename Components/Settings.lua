
TankTotals = LibStub("AceAddon-3.0"):NewAddon("TankTotals", "AceEvent-3.0", "AceConsole-3.0", "AceTimer-3.0", "LibSink-2.0");
TankTotals:SetDefaultModuleState(false);

-- SavedVariable tables
TTDB = {};
TTPCDB = {};

function getSchoolTable(initValue, physical, mixed)
        local schoolTable =
        {
            [TankTotals.INDEX_HOLY] = initValue, [TankTotals.INDEX_FIRE] = initValue,
            [TankTotals.INDEX_NATURE] = initValue, [TankTotals.INDEX_FROST] = initValue,
            [TankTotals.INDEX_SHADOW] = initValue, [TankTotals.INDEX_ARCANE] = initValue,
        };

        if physical then
            schoolTable[TankTotals.INDEX_BLEED] = initValue;
            schoolTable[TankTotals.INDEX_MELEE] = initValue;
        end

        if mixed then
            schoolTable[TankTotals.INDEX_FIRESTORM] = initValue;
            schoolTable[TankTotals.INDEX_FROSTFIRE] = initValue;
            schoolTable[TankTotals.INDEX_FROSTSTORM] = initValue;
            schoolTable[TankTotals.INDEX_SHADOWSTORM] = initValue;
            schoolTable[TankTotals.INDEX_SHADOWFROST] = initValue;
            schoolTable[TankTotals.INDEX_SPELLFIRE] = initValue;
            schoolTable[TankTotals.INDEX_UNRESISTIBLE] = initValue;
        end

        return schoolTable;
end

-- init settings as necessary
function TankTotals:InitSettings()
    -- grab a copy of the translations table
    local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

-- all chars
-- general
    TTDB.EnemyLevelDiff = (TTDB.EnemyLevelDiff or 3);
    TTDB.DecimalAccuracy = (TTDB.DecimalAccuracy or 3);
    if TTDB.ShowResistances == nil then TTDB.ShowResistances = true; end

-- mob damage
    if TTDB.ShowNEH == nil then TTDB.ShowNEH = true; end
    if TTDB.AvoidsNEH == nil then TTDB.AvoidsNEH = false; end
    if TTDB.ParryHaste == nil then TTDB.ParryHaste = true; end
    if TTDB.ContinuousDmg == nil then TTDB.ContinuousDmg = true; end

    -- DB of user-defined spell schools
    if TTDB.CustomSchools == nil then TTDB.CustomSchools = {}; end

    local function getDefaultProfile() local defTable = getSchoolTable(0, true, true); defTable[TankTotals.INDEX_MELEE] = 1.0; return defTable; end
    if TTDB.SavedNEHData == nil then TTDB.SavedNEHData = { [L["NONE"]] = {}, [L["LATEST"]] = {} }; else TTDB.SavedNEHData[L["NONE"]] = {}; TTDB.SavedNEHData[L["LATEST"]] = (TTDB.SavedNEHData[L["LATEST"]] or {}); end
    if TTDB.SavedNEHProfiles == nil then TTDB.SavedNEHProfiles = { [L["DEFAULT"]] = getDefaultProfile() }; else TTDB.SavedNEHProfiles[L["DEFAULT"]] = (TTDB.SavedNEHProfiles[L["DEFAULT"]] or getDefaultProfile()); end

-- appearance
    TTDB.Font = (TTDB.Font or "TwCenMT");
    TTDB.FontOutline = (TTDB.FontOutline or "THINOUTLINE");
    if TTDB.PopUp == nil then TTDB.PopUp = false; end

-- announce
    TTDB.AnnounceChannel = (TTDB.AnnounceChannel or "YELL");
    TTDB.TauntMissSound = (TTDB.TauntMissSound or "None");

-- per-char
-- general
    if TTPCDB.AddonActive == nil then TTPCDB.AddonActive = true; end
    if TTPCDB.ActiveInSpec == nil then TTPCDB.ActiveInSpec = { true, false }; end
    if TTPCDB.ShowSummary == nil then TTPCDB.ShowSummary = true; end
    if TTPCDB.HoP_B_Gone == nil then TTPCDB.HoP_B_Gone = true; end

-- mob damage
    TTPCDB.MobHitAmount = (TTPCDB.MobHitAmount or 50000);
    if TTPCDB.RecordNEHXY == nil then TTPCDB.RecordNEHXY = true; end
    if TTPCDB.StopNEHOnAD == nil then TTPCDB.StopNEHOnAD = false; end

    if TTPCDB.SelectedNEHData == nil then TTPCDB.SelectedNEHData = L["NONE"]; end
    if TTPCDB.SelectedNEHProfile == nil then TTPCDB.SelectedNEHProfile = L["DEFAULT"]; end

    -- melee, holy, fire, nature, frost, shadow, arcane, bleed
    if TTPCDB.NEHXY == nil then TTPCDB.NEHXY = getSchoolTable(0, true, true); TTPCDB.NEHXY[TankTotals.INDEX_MELEE] = 1.0; end

    -- data recorded in combat
    if TTPCDB.NEH_DATA == nil then TTPCDB.NEH_DATA = nil; end

-- appearance
    TTPCDB.GrowDir = (TTPCDB.GrowDir or "DOWN");
    TTPCDB.WindowScale = (TTPCDB.WindowScale or 0.8);
    TTPCDB.AnchorPos = (TTPCDB.AnchorPos or { [0] = -1, [1] = -1 });
    if TTPCDB.WindowBlindsUp == nil then TTPCDB.WindowBlindsUp = false; end

-- announce
    if TTPCDB.PVPAnnounce == nil then TTPCDB.PVPAnnounce = false; end
    if TTPCDB.StanceAnnounce == nil then TTPCDB.StanceAnnounce = false; end
    if TTPCDB.InstanceAnnounce == nil then TTPCDB.InstanceAnnounce = true; end

    if TTPCDB.CooldownAnnounce == nil then TTPCDB.CooldownAnnounce = true; end
    if TTPCDB.TauntMissAnnounce == nil then TTPCDB.TauntMissAnnounce = true; end
    if TTPCDB.SpecialTaunts == nil then TTPCDB.SpecialTaunts = true; end

    TTPCDB.SinkOutput = (TTPCDB.SinkOutput or { ["sink20OutputSink"] = "None" });

-- class
    if TTPCDB.ArdentPerFight == nil then TTPCDB.ArdentPerFight = true; end
    if TTPCDB.ArdentAnnounce == nil then TTPCDB.ArdentAnnounce = true; end
    if TTPCDB.ArdentHealAnnounce == nil then TTPCDB.ArdentHealAnnounce = true; end
    if TTPCDB.ArdentEHTTL == nil then TTPCDB.ArdentEHTTL = false; end

    TTPCDB.ArdentText = (TTPCDB.ArdentText or nil);
    TTPCDB.ArdentHealText = (TTPCDB.ArdentHealText or nil);
    if TTPCDB.ArdentCD == nil then TTPCDB.ArdentCD = true; end
    TTPCDB.ArdentTexture = (TTPCDB.ArdentTexture or "Minimalist");
end

