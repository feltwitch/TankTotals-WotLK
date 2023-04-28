
local S = TankTotals.S;
local super = TankTotals.SuperClass;
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

local Druid = TankTotals:NewModule("Druid", super, "AceEvent-3.0");

Druid.CLASS_NAME = "DRUID";
Druid.ParryableGCDs = 0.95;	-- demo roar every 30s

Druid.K_MISS = 0.972;

local SavageMits = 0;
local SavageHits = 0;

local SavageMitigated = 0;
local SavageActive = false;

local HeroicPresence = 0;

Druid.ShowBlockInfo = false;

-- results of GetFlatMitigationDR(), GetSavageDefenseUptime() and GetParryHasteEffect() are
-- cached on each Update to avoid repetition of expensive calls. In the normal UpdateDisplayText
-- cycle, the order of caching and usage runs as follows:
--
-- GetTotalPhysicalDR() is called from UI.lua:65 -> calls GetFlatMitigationDR() -> sets cachedFlatDR
--								 -> calls GetSavageDefenseUptime() -> sets cachedSDUptime
--										-> calls GetParryHasteEffect() -> sets cachedParryHasteEffect
-- AddCustomDisplayText() is called from UI.lua:88 -> uses cachedSDUptime
-- GetExpectedHealth() is called from UI.lua:SetEffectiveHealthText:233 -> uses cachedFlatDR
-- GetExpectedTTL() is called from UI.lua:SetEffectiveHealthText:240 -> uses cachedParryHasteEffect
--
-- Call the latter three functions with their last argument (refreshCache) set to TRUE to force
-- recalculation of the values from scratch.

local cachedFlatDR = 0;
local cachedSDUptime = 0;
local cachedParryHasteEffect = 1.0;

function Druid:OnEnable()
  self:RegisterBuffs();
  self:EditConfigTable();

  -- check heroic presence for SD uptime calculation
  if UnitBuff("player", S["Heroic Presence"]) then HeroicPresence = 1; else HeroicPresence = 0; end

  self:RegisterEvent("PLAYER_REGEN_ENABLED");
  self:RegisterEvent("PLAYER_REGEN_DISABLED");

  self:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

local curSD = 0;
local lastSDTime = 0;

function Druid:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
  local eventType, sourceGUID, _, _, destGUID, _, _ = select(2, ...);

  if destGUID == UnitGUID("player") then
    -- QuickHealth update
    TankTotals.QH:UpdateQuickHealth(...);

    -- check for melee hits, melee absorbs, special physical hits, special physical absorbs
    if eventType == "SWING_DAMAGE" or (eventType == "SWING_MISSED" and select(9,...) == "ABSORB") or (eventType == "SPELL_DAMAGE" and select(11,...) == 0x01) or (eventType == "SPELL_MISSED" and select(11,...) == 0x01 and select(12,...) == "ABSORB") then
      -- increment hit counter
      SavageHits = SavageHits + 1;

      -- if SD is active or it faded at the same instant as this event, proceed
      if (SavageActive or select(1,...) == lastSDTime) then
        local absorbAmt = 0;

        -- melee swing damage
        if eventType == "SWING_DAMAGE" then
          absorbAmt = min(curSD, (select(14,...) or 0));
          -- melee swing absorption
        elseif eventType == "SWING_MISSED" then
          absorbAmt = min(curSD, (select(10,...) or 0));
          -- special physical attack damage
        elseif eventType == "SPELL_DAMAGE" then
          absorbAmt = min(curSD, (select(17,...) or 0));
          -- special physical attack absorption
        elseif eventType == "SPELL_MISSED" then
          absorbAmt = min(curSD, (select(13,...) or 0));
        end

        if absorbAmt > 0 then
          SavageMits = SavageMits + 1;
          SavageMitigated = SavageMitigated + absorbAmt;
        end
      end
      -- this is an aura gain event
    elseif(eventType == "SPELL_AURA_APPLIED") or (eventType == "SPELL_AURA_REFRESH") then
      local spellName = select(10, ...);

      -- if we've gained SD, record amount
      if spellName == S["Savage Defense"] then
        SavageActive = true;
        _, curSD = self:GetFlatMitigationInfo();
      elseif spellName == S["Heroic Presence"] then
        HeroicPresence = 1;
        TankTotals:UpdateTotals();
      end
      -- this is an aura loss event
    elseif(eventType == "SPELL_AURA_REMOVED") then
      local spellName = select(10, ...);

      -- indicate that SD has faded and save timestamp
      if spellName == S["Savage Defense"] then
        SavageActive = false;
        lastSDTime = select(1,...);
      elseif spellName == S["Heroic Presence"] then
        HeroicPresence = 0;
        TankTotals:UpdateTotals();
      end
    end
  elseif destGUID == UnitGUID("target") then
    if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REMOVED") then
      local spellName = select(10, ...);

      -- HOTC, MP and ToW affect crit chance, and therefore Savage Defense
      if spellName == S["Heart of the Crusader"] or spellName == S["Master Poisoner"] or spellName == S["Totem of Wrath"] then
        TankTotals:UpdateTotals();
      end
    end
  end
end

function Druid:PLAYER_REGEN_DISABLED()
  if TTPCDB.ArdentPerFight then
    SavageMits = 0;
    SavageHits = 0;
    SavageMitigated = 0;

    TankTotals:UpdateTotals();
  end
end

function Druid:PLAYER_REGEN_ENABLED()
  if TTPCDB.ArdentPerFight then
    if SavageHits > 0 then
      DEFAULT_CHAT_FRAME:AddMessage("");
      TankTotals:Print("|cffffff00["..S["Savage Defense"].."]|r "..L["PERFIGHT_REPORT"]);
      TankTotals:Print("|cff00ff00"..L["PERFIGHT_MITIGATED"].."|r "..floor(SavageMitigated));
      TankTotals:Print("|cff00ff00"..S["Savage Defense"]..L["PERFIGHT_UPTIME"].."|r "..ttvFormat((SavageMits/SavageHits)*100, 2).."% ("..SavageMits.."/"..SavageHits..")");
      DEFAULT_CHAT_FRAME:AddMessage("");
    end
  end
end

-- force delayed update on form shift
function Druid:UPDATE_SHAPESHIFT_FORM()
  TankTotals:ScheduleTimer("UpdateTotals", 0.75);
end

function Druid:ResetValues()
  -- nothing relevant
end

function Druid:RegisterBuffs()
  TankTotals.SelfCooldowns[S["Barkskin"]] = L["BSKIN_YELL"];
  TankTotals.SelfCooldowns[S["Survival Instincts"]] = L["SI_YELL"];

  -- t10 4-set announce
  TankTotals.SelfCooldowns[S["Enraged Defense"]] = strupper(S["Enraged Defense"]);

  TankTotals.MitigationBuffs[S["Dire Bear Form"]] = 1.0;	-- correct value obtained from talents
  TankTotals.MitigationBuffs[S["Barkskin"]] = 0.8;
  TankTotals.MitigationBuffs[S["Savage Defense"]] = 1.0;	-- dummy value to indicate that the ability is accounted for; must be calculated on the fly

  -- t10 4-set bonus: 12% damage reduction
  TankTotals.MitigationBuffs[S["Enraged Defense"]] = 0.88;
end

function Druid:GetTalentInfo()
  local nameTalent, icon, tier, column, currRank, maxRank;

  -- protector of the pack
  nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 22);
  TankTotals.MitigationBuffs[S["Dire Bear Form"]] = 1 - currRank * 0.04;
end

function Druid:CheckSetBonuses()
  -- no relevant bonuses
  return false;
end

function Druid:CheckEnchantsAndGlyphs()
  -- glyph of FR gives +20% healing taken, so announce
  if TankTotals:IsGlyphActive(S["Glyph of Frenzied Regeneration"]) then
    TankTotals.SelfCooldowns[S["Frenzied Regeneration"]] = L["FR_YELL"];
  else
    TankTotals.SelfCooldowns[S["Frenzied Regeneration"]] = nil;
  end
end

function Druid:GetMissParryChance()
  -- miss from defense is x' = 1/(1/c + k/x), 1/c = 1/16 = 0.0625, k = 0.972
  -- add (0.2 * EnemyLevelDiff) to compensate for the boss-level reduction in parry in TankTotals.lua:168
  return (0.2 * TTDB.EnemyLevelDiff) + self:GetMissAfterDR();
end

function Druid:GetSpecialMitigation()
  -- no relevant modifiers
  return { 1.0, 1.0, 1.0, 1.0 };
end

-- returns flat mitigation as % damage after reduction
function Druid:GetFlatMitigationDR()
  cachedFlatDR = 1.0;

  if TTPCDB.MobHitAmount > 0 then
    -- Savage Defense as % of post-mitigated hit
    _, cachedFlatDR = self:GetFlatMitigationInfo();
    cachedFlatDR = 1 - (min(1, cachedFlatDR / (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE])) * self:GetSavageDefenseUptime());
  end

  return cachedFlatDR;
end

-- get the expected uptime of Savage Defense
function Druid:GetSavageDefenseUptime()
  local playerMH = UnitAttackSpeed("player");
  local enemyMH, enemyOH = UnitAttackSpeed("target");

  -- assume 2.4 if no target
  if enemyMH == 0 then enemyMH = 2.4; end

  local critWindow = 0.0;

  if not enemyOH then
    -- 2H boss, crit window is swing timer / avoidance
    critWindow = enemyMH / (1 - (TankTotals.Avoidance/100));
  else
    -- DW boss, crit window is swing interval / avoidance
    critWindow = abs(enemyMH - enemyOH) / (1 - (TankTotals.Avoidance/100));
  end

  -- account for parry haste effect on mob swing timer
  critWindow = critWindow * self:GetParryHasteEffect();

  -- overall hit chance
  local hitChance = 100;

  -- expertise: 5%/6.5% dodge, 5%/14% parry
  local expEffect = GetExpertisePercent();
  hitChance = hitChance - max(0, 5 + (TTDB.EnemyLevelDiff * 0.5) - expEffect) - max(0, 5 + (TTDB.EnemyLevelDiff * 3) - expEffect);

  -- hit: 5%/8% miss
  hitChance = hitChance - max(0, (5 + TTDB.EnemyLevelDiff) - (GetCombatRating(CR_HIT_MELEE)/TankTotals.HIT_RATING_PERCENT));
  hitChance = min(100, hitChance + HeroicPresence);

  local critChance = GetCritChance();

  -- HOTC, MP & ToW give +3% crit
  if UnitDebuff("target", S["Heart of the Crusader"]) or UnitDebuff("target", S["Master Poisoner"]) or UnitDebuff("target", S["Totem of Wrath"]) then
    critChance = critChance + 3;
  end

  -- chance of NOT getting a crit, with white and yellow attacks
  local notWCritChance = 1 - min(critChance/100, hitChance/100);
  local notYCritChance = 1 - ((critChance/100) * (hitChance/100));

  -- lacerate every 3s, autoattack, GCD abilities
  cachedSDUptime = 1 - notWCritChance^(critWindow/3) * notWCritChance^(critWindow/playerMH) * notYCritChance^(critWindow/1.5);

  return cachedSDUptime;
end

-- returns expected HP including avoidance and flat mitigation, or nil for infinite health
-- also returns effective health for convenience, since it's calculated in the process anyway
function Druid:GetExpectedHealth(effHealth, refreshCache)
  effHealth = (effHealth or self:GetEffectiveHealth());

  -- determine whether to use cached values or refresh
  if refreshCache then self:GetFlatMitigationDR(); end

  -- calculate extra damage reduction from flat mit and avoidance
  local extraDR = cachedFlatDR * (1 - (TankTotals.Avoidance/100));

  -- return [ expected HP, effective HP ]
  if effHealth == nil or extraDR == 0 then
    return nil, effHealth;
  else
    return (effHealth / extraDR), effHealth;
  end
end

-- returns expected time-to-live, or nil for infinite time
-- avoidance has already been treated as mitigation, don't use it to modify the swing timer
function Druid:GetExpectedTTL(expHealth, refreshCache)
  if TTPCDB.MobHitAmount > 0 then
    if not expHealth then
      expHealth = self:GetExpectedHealth(nil, refreshCache);
      -- if expHealth is nil and refreshCache is true, then parry haste will
      -- already have been re-cached from the call to GetExpectedHealth above
    elseif refreshCache then
      self:GetParryHasteEffect();
    end

    return super.GetExpectedTTL(self, expHealth, cachedParryHasteEffect);
  end

  return nil;
end

function Druid:GetParryHasteEffect()
  -- use generic function with class-appropriate GCD parry rate
  cachedParryHasteEffect = super.GetParryHasteEffect(self);
  return cachedParryHasteEffect;
end

function Druid:GetFlatMitigationInfo()
  -- savage defense provides flat damage mitigation of (AP * 0.25)
  local base, posBuff, negBuff = UnitAttackPower("player");
  return L["DRUID_FLATMIT"], ((base + posBuff + negBuff) * 0.25);
end

function Druid:IsSingleTargetTaunt(spellID)
  return (GetSpellInfo(spellID) == S["Growl"]);
end

function Druid:IsAoETaunt(spellID)
  return (GetSpellInfo(spellID) == S["Challenging Roar"]);
end

function Druid:TankingStanceActive()
  return (UnitBuff("player", S["Dire Bear Form"]) ~= nil) or (self:GetCurrentStance() == S["Dire Bear Form"]);
end

-- add Savage Defense uptime estimate and total mitigated
function Druid:AddCustomDisplayText(recipient, refreshCache)
  recipient:AddLine("", "");

  -- determine whether to use cached values or refresh
  if refreshCache then self:GetSavageDefenseUptime(); end

  recipient:AddLine("|cffffff00"..L["SD_UPTIME_HEADING"].."|r", "|cff00ff00"..ttvFormat(cachedSDUptime*100).."%|r");
  recipient:AddLine("|cffffff00"..L["SD_TOTAL_HEADING"].."|r", "|cff00ff00"..ttvFormat(SavageMitigated/1000, 2).."k|r");
end

function Druid:EditConfigTable()
  TankTotals.ConfigTable.args.Announce.args.aoetauntmisses=
  {
    type="toggle", order = 3, name=L["SETTINGS_SPECIALTAUNT"], desc=L["SETTINGS_SPECIALTAUNT_DESC"],
    get=function() return TTPCDB.SpecialTaunts end,
    set=function() TTPCDB.SpecialTaunts = (not TTPCDB.SpecialTaunts); end
  };

  TankTotals.ConfigTable.args.Class =
  {
    order = 5,
    type = "group",
    name = L["SETTINGS_CLASS"],
    desc = L["SETTINGS_CLASS_DESC"],
    disabled = function() return (not TTPCDB.AddonActive); end,
    args =
    {
      perfight=
      {
        type="toggle", order = 1, name=L["SETTINGS_PERFIGHT"], desc=L["SETTINGS_PERFIGHT_DESC"],
        get=function() return TTPCDB.ArdentPerFight end,
        set=function() TTPCDB.ArdentPerFight = (not TTPCDB.ArdentPerFight); end
      },
      resetstats=
      {
        type="execute", order = 2, name=L["SETTINGS_STATS_RESET"], desc=L["SETTINGS_STATS_RESET_DESC"],
        func = function() SavageMitigated = 0; TankTotals:UpdateTotals(); end
      },
    },
  };
end

