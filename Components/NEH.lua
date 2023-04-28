
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

local NEH = TankTotals:NewModule("NEH", "AceEvent-3.0", "AceHook-3.0");

-- data currently being recorded
local currentData, inCombat = {}, false;

-- Must record each missable ability separately so that accurate
-- averages can be ascertained later. Must index by type of damage
-- so that averages aren't calculated across e.g. direct attacks
-- and DoT damage with the same name (Fusion Punch etc)
currentData.missStats =
{
  --[[
  [SOURCENAME] =
  {
    ["ATTACK_TYPE1"] =
    {
      ["AttackName1"] =
      {
        ["school"] = U, ["dmg"] = V, ["minabsorb"] = W, ["numhit"] = X, ["nummiss"] = Y, ["numabsorb"] = Z,
      },
      ["AttackName2"] =
      {
        ["school"] = U, ["dmg"] = V, ["minabsorb"] = W, ["numhit"] = X, ["nummiss"] = Y, ["numabsorb"] = Z,
      },
    },
  },
  --]]
};

function NEH:OnEnable()
  -- init/reset values
  self:ResetValues();

  -- register for events
  self:RegisterEvent("PLAYER_REGEN_ENABLED");
  self:RegisterEvent("PLAYER_REGEN_DISABLED");
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

  -- hook into the default chat frame for hyperlinks
  self:HookScript(DEFAULT_CHAT_FRAME, "OnHyperlinkClick", function(frame, linkData, link, button) if strfind(linkData, "TankTotals:AdoptNEH") then NEH:AdoptData(); elseif strfind(linkData, "TankTotals:SaveNEH") then NEH:AdoptData(); NEH:SaveDataSegment(); end end);
end

function NEH:OnDisable()
  self:UnhookAll(); -- unhook from chat frame
end

function NEH:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
  -- QuickHealth update
  TankTotals.QH:UpdateQuickHealth(...);

  if UnitIsDeadOrGhost("player") or (not inCombat) then return; end

  local pOff, schoolIndex, spellID = 0, nil, nil;
  local unmitigated, probResist, excessAbsorb, KBA;

  -- extract event parameters
  local timeStamp, eventType, sourceGUID, sourceName, _, destGUID, _, _ = select(1, ...);

  -- offset +3 entries if it's anything but a melee swing
  if strfind(eventType, "SWING_") then pOff = 0; else pOff = 3; end

  -- verify that the player is the target, don't include environmental or building damage
  if destGUID == UnitGUID("player") and not (strfind(eventType, "ENVIRONMENTAL_") or strfind(eventType, "SPELL_BUILDING_")) then
    -- reset damage variables each event
    local dmgAmt, resist, absorb, block, fullDmg;

    -- some kind of damage event
    if strfind(eventType, "_DAMAGE") then
      -- extract damage and absorption numbers
      dmgAmt, resist, block, absorb = select(9+pOff, ...), (select(12+pOff,...) or 0), (select(13+pOff,...) or 0), (select(14+pOff,...) or 0);

      -- get spell ID, or nil if SWING
      spellID = ((pOff > 0 and select(9, ...)) or nil);

      -- get spell school and adjust if needed, eg MELEE => BLEED, FROST => UNRESISTIBLE
      schoolIndex = self:ResolveSchool(eventType, spellID, select(11,...), ((pOff > 0 and resist) or nil));

      -- check whether the school is defined
      if (not TankTotals.FinalMitigation[schoolIndex]) then return; end

      -- overkill
      if select(10+pOff,...) > 0 then
        currentData.timeDeath = timeStamp;
        currentData.killer = (currentData.killer or sourceName);
        dmgAmt = dmgAmt + select(10+pOff, ...); -- overkill damage is still damage
      end

      -- get unmitigated damage, resistance due to probabilistic mechanics, excess absorb (e.g absorb NOT due to AD/WOTN)
      unmitigated, probResist, excessAbsorb = TankTotals.ClassModule:Unmitigate(dmgAmt, schoolIndex, resist, block, absorb, timeStamp);

      -- post-mit damage without absorbs, blocks or probabilistic resists
      fullDmg = dmgAmt + probResist + (excessAbsorb or absorb) + block;

      -- we must record the misses-to-hits ratio of each attack for later
      -- pass ability name if it's spell damage, SWING if melee
      if eventType == "SWING_DAMAGE" then
        self:UpdateMissStats(sourceName, "SWING", "SWING", schoolIndex, fullDmg, unmitigated);
      else
        -- remove "_DAMAGE" from attack type
        self:UpdateMissStats(sourceName, strsub(eventType, 1, strlen(eventType)-7), select(10, ...), schoolIndex, fullDmg, unmitigated);
      end

      -- add new data to record
      currentData.damage[schoolIndex] = currentData.damage[schoolIndex] + fullDmg;
      currentData.absorb[schoolIndex] = currentData.absorb[schoolIndex] + probResist + (excessAbsorb or absorb) + block;

      -- upper and lower EH2 bounds
      currentData.eh2bounds[2] = currentData.eh2bounds[2] + unmitigated; -- EH2 upper bound
      currentData.eh2bounds[1] = currentData.eh2bounds[1] + unmitigated - (probResist + (excessAbsorb or absorb) + block); -- EH2 lower bound

      -- record time of first damage if not already done
      if not currentData.timeMaxHP then currentData.timeMaxHP = timeStamp; currentData.maxHP = TankTotals.PlayerQuickHealthMax; end

      -- try to determine whether we're fighting a boss, and if so, record its name
      if (not currentData.killer) and UnitClassification("target") == "worldboss" then currentData.killer = UnitName("target"); end
      -- fully absorbed, resisted, blocked or avoided attacks
    elseif currentData.timeMaxHP and strfind(eventType, "_MISSED") and not (select(9+pOff,...) == "IMMUNE" or select(9+pOff,...) == "EVADE") then
      -- get spell ID, or nil if SWING
      spellID = ((pOff == 0 and nil) or select(9, ...));

      -- get spell school and adjust if needed, eg MELEE => BLEED etc
      -- swing miss event has no second school entry in the log, check for it
      -- resisted magic damage is obviously not un-resistible, set param to nil
      schoolIndex = self:ResolveSchool(eventType, spellID, ((eventType == "SWING_MISSED" and TankTotals.INDEX_MELEE) or select(11,...)), nil);

      -- check whether the school is defined
      if (not TankTotals.FinalMitigation[schoolIndex]) then return; end

      -- event type and amount, where appropriate
      local missType, missAmt = select(9+pOff,...), select(13, ...);

      -- populate damage variables; resist doesn't provide a number
      dmgAmt, resist, absorb, block = 0, nil, ((missType == "ABSORB" and missAmt) or nil), ((missType == "BLOCK" and missAmt) or nil);

      -- if resist, then "amount" is always 0, i.e. not given
      -- if absorb, then it was preceded by an unknown resist amount
      -- if block, it was preceded by both resist and absorb
      -- => more accurate to rely on post-fight averages

      -- however, if there's an absorption number, we can use this data to
      -- determine a minimum absorption amount in case no hits are recorded
      -- pass ability name, or SWING if nil; remove "_MISSED" from attack type
      if missAmt and missAmt > 0 then unmitigated, _, excessAbsorb, _, KBA = TankTotals.ClassModule:Unmitigate(0, schoolIndex, 0, (block or 0), (absorb or 0), timeStamp); end

      if KBA then -- killing blow was absorbed by AD; no "real" absorb, treat as damage
        currentData.eh2bounds[1] = currentData.eh2bounds[1] + unmitigated; -- EH2 lower bound
        currentData.eh2bounds[2] = currentData.eh2bounds[2] + unmitigated; -- EH2 upper bound
        currentData.damage[schoolIndex] = currentData.damage[schoolIndex] + absorb;
      else
        -- UpdateMissStats(sourceName, attackType, attackName, schoolIndex, damage, unmitigated, absorb, unmitAbsorb)
        self:UpdateMissStats(sourceName, strsub(eventType, 1, strlen(eventType)-7), ((eventType == "SWING_MISSED" and "SWING") or select(10, ...)), schoolIndex, nil, nil, ((absorb and (excessAbsorb or absorb)) or block), unmitigated);
      end
      -- record healing taken, except AD
    elseif strfind(eventType, "_HEAL") then
      -- overhealing means we're back to 100%
      if select(13, ...) > 0 and select(12,...) > 0 then self:ResetValues(true);
        -- exclude AD since it's accounted for via EH
      elseif select(10, ...) ~= S["Ardent Defender"] then
        currentData.healing = currentData.healing + select(12,...);
      end
      -- stop recording on AD proc, if the relevant option is enabled
    elseif TTPCDB.StopNEHOnAD and eventType == "SPELL_AURA_APPLIED" and select(10,...) == S["Ardent Defender"] then
      self:ForceStop(timeStamp, "|cffffff00["..S["Ardent Defender"].."]|r");
    end
  end
end

function NEH:PLAYER_REGEN_DISABLED()
  inCombat = true;
  self:ResetValues();
end

function NEH:PLAYER_REGEN_ENABLED()
  inCombat = false;

  -- finalise data and print combat report
  if currentData.timeDeath then
    self:FinaliseCurrentData();
    self:ProcessData();

    -- print the post-combat report
    self:PrintReport();
  else
    wipe(currentData);
  end
end

-- resolve the true school index
function NEH:ResolveSchool(eventType, spellID, naiveSchool, resist)
  -- user-defined spell schools take precedence
  if spellID and TTDB.CustomSchools[spellID] then
    return TTDB.CustomSchools[spellID];
    -- physical periodic damage = bleeds and similar effects
  elseif naiveSchool == TankTotals.INDEX_MELEE and strfind(eventType, "SPELL_PERIODIC_") then
    return TankTotals.INDEX_BLEED;
    -- no resist even though there should be guaranteed minimum resistance
    -- return INDEX_UNRESISTIBLE and add the spellID to the list of custom schools
  elseif resist and resist == 0 and TankTotals.MinResistances[naiveSchool] and TankTotals.MinResistances[naiveSchool] < 1 then
    self:AddCustomSpell(spellID, TankTotals.INDEX_UNRESISTIBLE);
    return TankTotals.INDEX_UNRESISTIBLE;
    -- no adjustment necessary
  else
    return naiveSchool;
  end
end

-- force recording to stop early if an AN proc is caught
function NEH:ForceStop(timeStamp, reason)
  -- print notification
  TankTotals:Print(reason.." |cffff0000"..L["REC_SUSPENDED"].."|r");

  -- set EOF values
  currentData.killer = (currentData.killer or UnitName("target") or L["UNKNOWN"]);
  currentData.timeDeath = timeStamp;
  inCombat = false;
end

-- compute avoided/absorbed damage
function NEH:FinaliseCurrentData()
  -- calculate the average hit and use it to account for avoided damage
  -- [2] is the upper EH2 bound, i.e. EH2 needed to survive with NO avoidance or healing

  -- pairs(missStats) => [sourceName],attackData
  for _, attackData in pairs(currentData.missStats) do
    -- pairs(attackData) => [attackType],attackList
    for _,attackList in pairs(attackData) do
      -- pairs(attackList) => [attackName],values
      for _, v in pairs(attackList) do
        -- if this attack missed up at least once, then...
        if v["nummiss"] > 0 then
          local avoided, unmitAvoided = 0, 0;

          if v["numhit"] > 0 then
            -- ... if we recorded some hits for it, use them to determine the amount of avoided damage
            avoided = infDiv(v["nummiss"], v["numhit"]) * v["dmg"];
            unmitAvoided = infDiv(v["nummiss"], v["numhit"]) * v["unmitDmg"];
          elseif v["minabsorb"] then
            -- ... otherwise, if we were never hit by it, use total number of misses * max(minimum absorbed damage)
            avoided = v["nummiss"] * v["minabsorb"];
            unmitAvoided = v["nummiss"] * v["minunmitabsorb"];
          end

          currentData.avoid[v.school] = currentData.avoid[v.school] + avoided;
          currentData.eh2bounds[2] = currentData.eh2bounds[2] + unmitAvoided; -- upper EH2 bound
        end

        -- do similarly for absorbs/blocks
        if v["numabsorb"] > 0 then
          local absorbed, unmitAbsorbed = 0, 0;

          if v["numhit"] > 0 then
            -- ... if we recorded some hits for it, use them to determine the amount of absorbed damage
            absorbed = infDiv(v["numabsorb"], v["numhit"]) * v["dmg"];
            unmitAbsorbed = infDiv(v["numabsorb"], v["numhit"]) * v["unmitDmg"];
          else
            -- ... otherwise, if we were never hit by it, use total number of absorbs * max(minimum absorbed damage)
            absorbed = v["numabsorb"] * v["minabsorb"];
            unmitAbsorbed = v["numabsorb"] * v["minunmitabsorb"];
          end

          -- add to both damage and absorption counts
          currentData.damage[v.school] = currentData.damage[v.school] + absorbed;
          currentData.absorb[v.school] = currentData.absorb[v.school] + absorbed;
          currentData.eh2bounds[2] = currentData.eh2bounds[2] + unmitAbsorbed; -- upper EH2 bound
        end
      end
    end
  end

  -- format start and end timestamps with the mob who killed you to produce report title
  currentData.fightTitle = currentData.killer..", "..date("%m/%d/%y %H:%M:%S", currentData.timeMaxHP).." - "..date("%H:%M:%S", currentData.timeDeath);

  -- [1] is the lower EH2 bound needed to survive assuming the same avoids, resists, absorbs, blocks and healing
  currentData.eh2bounds[1] = currentData.eh2bounds[1] * (currentData.maxHP / (currentData.maxHP+currentData.healing));

  -- delete missStats to save memory
  currentData.missStats = nil;
end

-- compute percentages and EH2 bounds
function NEH:ProcessData(segmentName)
  -- get data from saved segements if supplied, otherwise default to currentData
  local data = ((segmentName == nil and currentData) or TTDB.SavedNEHData[segmentName]);

  -- sum of all damage and avoided damage
  local damageSum, avoidedSum = tablesum(data.damage), tablesum(data.avoid);

  -- figures used to calculate percentages depend on option TTDB.AvoidsNEH
  local totalSum = ((TTDB.AvoidsNEH and (damageSum+avoidedSum)) or damageSum);
  local damageTable = ((TTDB.AvoidsNEH and tableadd(data.damage, data.avoid)) or data.damage);

  -- calculate percentages
  for k,v in pairs(damageTable) do
    data.percent[k] = v/totalSum;
  end
end

-- record full avoidance together with damage dealt by each attack
-- this will later be used to determine the amount of avoided damage
-- also store physical abilities that can miss in separate table entries
-- in the case of full absorbs or blocks, absorb is the minimum
-- amount of damage that the attack did
function NEH:UpdateMissStats(sourceName, attackType, attackName, schoolIndex, damage, unmitigated, absorb, unmitAbsorb)
  -- if source is nil, add it to a default collection
  sourceName = (sourceName or "TANKTOTALS_NOSOURCE");

  if (not currentData.missStats[sourceName]) then
    currentData.missStats[sourceName] = {};
  end

  if (not currentData.missStats[sourceName][attackType]) then
    currentData.missStats[sourceName][attackType] = {};
  end

  if (not currentData.missStats[sourceName][attackType][attackName]) then
    -- currentData.missStats[sourceName]["SPELL_DAMAGE"]["Fireball"] = { school, damage from hits, unmitigated damage from hits, damage from full absorbs/blocks, unmitigated absorb damage, number of hits, total number of misses, number of full absorbs/blocks
    currentData.missStats[sourceName][attackType][attackName] = { ["school"] = schoolIndex, ["dmg"] = 0, ["unmitDmg"] = 0, ["minabsorb"] = 0, ["minunmitabsorb"] = 0, ["numhit"] = 0, ["nummiss"] = 0, ["numabsorb"] = 0 };
  end

  if damage then -- hit
    currentData.missStats[sourceName][attackType][attackName]["dmg"] = currentData.missStats[sourceName][attackType][attackName]["dmg"] + damage;
    currentData.missStats[sourceName][attackType][attackName]["numhit"] = currentData.missStats[sourceName][attackType][attackName]["numhit"] + 1;
    currentData.missStats[sourceName][attackType][attackName]["unmitDmg"] = currentData.missStats[sourceName][attackType][attackName]["unmitDmg"] + unmitigated;
  else -- miss/absorb
    if absorb then -- absorb/block
      currentData.missStats[sourceName][attackType][attackName]["numabsorb"] = currentData.missStats[sourceName][attackType][attackName]["numabsorb"] + 1;
      currentData.missStats[sourceName][attackType][attackName]["minabsorb"] = max(currentData.missStats[sourceName][attackType][attackName]["minabsorb"], absorb);
      currentData.missStats[sourceName][attackType][attackName]["minunmitabsorb"] = max(currentData.missStats[sourceName][attackType][attackName]["minunmitabsorb"], unmitAbsorb);
    else -- miss
      currentData.missStats[sourceName][attackType][attackName]["nummiss"] = currentData.missStats[sourceName][attackType][attackName]["nummiss"] + 1;
    end
  end
end

local function buildOutputString(inTable, heading, unitDiv, suffix)
  local outputString = heading;

  for i,v in pairs(inTable) do
    -- if i == TankTotals.INDEX_NATURE then outputString = outputString.."\n"..heading; end

    if v > 0 then
      outputString = outputString..TankTotals.SchoolColors[i]..TankTotals.SchoolNames[i]..": "..ttvFormat(v/unitDiv,1)..suffix.."|r ";
    end
  end

  return outputString;
end

function NEH:PrintReport(data)
  local printHL = (data == nil);
  data = (data or currentData);

  DEFAULT_CHAT_FRAME:AddMessage("");

  -- print summary heading
  TankTotals:Print("|cffffff00[EH2 "..L["NEH_REPORT"].."]|r: "..data.fightTitle);

  -- damage, absorption, percentages
  TankTotals:Print(buildOutputString(data.damage, L["NEH_DAMAGE"].."|r ", 1000, "k"));
  TankTotals:Print(buildOutputString(data.absorb, L["NEH_ABSORB"].."|r ", 1000, "k"));
  TankTotals:Print(buildOutputString(data.avoid, L["NEH_AVOID"].."|r ", 1000, "k"));
  TankTotals:Print(buildOutputString(data.percent, L["NEH_PERCENT"].."|r ", 1/100, "%"));
  TankTotals:Print(L["NEH_HEALING"].."|r "..ttvFormat(data.healing/1000,1).."k");

  -- print clickable hyperlink
  if printHL then self:PrintHyperLink(); end

  DEFAULT_CHAT_FRAME:AddMessage("");
end

function NEH:PrintHyperLink()
  -- print clickable hyperlink
  TankTotals:Print("|cff0066cc\124HTankTotals:AdoptNEH:nil|h["..L["NEH_CLICK"].."]|h |cff0066cc|HTankTotals:SaveNEH:nil|h["..L["NEH_CLICKSAVE"].."]|h|r");
end

-- addition of a custom spell/school pairing
function NEH:AddCustomSpell(spellID, school)
  if GetSpellInfo(spellID) then
    TTDB.CustomSchools[spellID] = school;
  else
    TankTotals:Print(L["NEH_NOSPELL"]);
  end
end

-- print the list of custom spells
function NEH:PrintCustomSpells()
  for spellID,school in pairs(TTDB.CustomSchools) do
    TankTotals:Print(GetSpellLink(spellID).." ("..spellID..") : "..TankTotals.SchoolColors[school]..TankTotals.SchoolNames[school].."|r");
  end
end

-- safe setting of XY values from options
function NEH:SetPercentage(school, val)
  TTPCDB.NEHXY[school] = min(val, 1 + (TTPCDB.NEHXY[school] or 0) + TTPCDB.NEHXY[TankTotals.INDEX_MELEE] - tablesum(TTPCDB.NEHXY));
  TTPCDB.NEHXY[TankTotals.INDEX_MELEE] = 1 + TTPCDB.NEHXY[TankTotals.INDEX_MELEE] - tablesum(TTPCDB.NEHXY);
end

function NEH:ResetValues(preserveHits)
  -- retain the name of the boss
  local attackingBoss = currentData.killer;

  -- init table
  currentData.damage = getSchoolTable(0, true, true); -- total post-mit damage
  currentData.killer = attackingBoss;

  -- set default values
  currentData.avoid = getSchoolTable(0, true, true); -- full avoidance
  currentData.absorb = getSchoolTable(0, true, true); -- absorbed, resisted, blocked
  currentData.percent = getSchoolTable(0, true, true); -- damage[i]/sum(damage)

  currentData.timeMaxHP = nil;
  currentData.timeDeath = nil;

  currentData.eh2bounds = { 0, 0 }; -- lower and upper EH2 bounds
  currentData.healing = 0; -- take a guess
  currentData.maxHP = 0; -- ditto

  -- selectively reset miss stats
  self:ResetMissStats(preserveHits);
end

-- when we are healed to 100%, we want to reset the
-- number of misses of each attack, but NOT the hits
-- or the overall damage - gives more accurate averages
function NEH:ResetMissStats(preserveHits)
  if not preserveHits then
    if currentData.missStats then wipe(currentData.missStats); else currentData.missStats = {}; end
  else
    -- pairs(missStats) => [sourceName],attackData
    for sourceName,attackData in pairs(currentData.missStats) do
      -- pairs(attackData) => [attackType],attackList
      for attackType,attackList in pairs(attackData) do
        -- pairs(attackList) => [attackName],values
        for attackName,_ in pairs(attackList) do
          currentData.missStats[sourceName][attackType][attackName]["nummiss"] = 0;
          currentData.missStats[sourceName][attackType][attackName]["numabsorb"] = 0;
        end
      end
    end
  end
end

--------------------------------------------------------
-- Data can be saved and used one of two ways: segments
-- and profiles. The former is data recorded from combat
-- and uses the relative damage amounts to set the NEH
-- percentages. The latter are saved configurations of
-- the EH2 slider bars. They are mutually exclusive,
-- i.e. selecting a segment resets the profile and
-- vice versa.
--------------------------------------------------------
-- Management of EH2 Data Segments and recording
--------------------------------------------------------

-- adopt damage totals and percentage contributions
function NEH:AdoptData(segmentName)
  -- don't print message if we're calling internally
  local data = ((segmentName == nil and currentData) or TTDB.SavedNEHData[segmentName]);

  -- always process data before adopting it as current
  self:ProcessData(segmentName);

  -- set NEH_DATA to the supplied
  if data.timeDeath then
    TTPCDB.NEH_DATA = tabledeepcopy(data);
    TTPCDB.NEHXY = tablecopy(data.percent);

    -- if no supplied data, print report
    if segmentName == nil then
      TTPCDB.SelectedNEHData = L["LATEST"];
      TTDB.SavedNEHData[L["LATEST"]] = tabledeepcopy(data);
      TankTotals:Print("|cff00ff00"..L["NEH_ACCEPTED"]);
    else
      TTPCDB.SelectedNEHData = segmentName;
    end
  else
    TankTotals:Print("|cffff0000"..L["NEH_NODATA"]);
    return false;
  end

  TankTotals:UpdateTotals();
  return true;
end

-- save data segment
function NEH:SaveDataSegment()
  if not TTPCDB.NEH_DATA then return; end
  TTDB.SavedNEHData[TTPCDB.NEH_DATA.fightTitle] = tabledeepcopy(TTPCDB.NEH_DATA);
  TTPCDB.SelectedNEHData = TTPCDB.NEH_DATA.fightTitle;
  TankTotals:Print("|cff00ff00"..L["NEH_SAVED"].."|r");
end

-- delete data segment
function NEH:DeleteDataSegment()
  if TTPCDB.SelectedNEHData ~= L["NONE"] and TTPCDB.SelectedNEHData ~= L["LATEST"] then
    TTDB.SavedNEHData[TTPCDB.SelectedNEHData] = nil;
    TTPCDB.SelectedNEHData = L["NONE"];
    TTPCDB.NEH_DATA = nil;

    -- confirmation message
    TankTotals:Print("|cffffff00"..L["NEH_DELETED"].."|r");
    TankTotals:UpdateTotals();
  end
end

-- discard saved combat data, but NOT most recent
function NEH:ResetRecordedData()
  -- set saved data to nil
  TTPCDB.NEH_DATA = nil;
  TTPCDB.SelectedNEHData = L["NONE"];

  -- switch to the currently-selected slider profile
  self:AdoptProfile(TTPCDB.SelectedNEHProfile);

  -- confirmation message
  TankTotals:Print("|cffffff00"..L["NEH_RESET"].."|r");
end

--------------------------------------------------------
-- Management of EH2 Sliders and profiles
--------------------------------------------------------

function NEH:AdoptProfile(profileName)
  if not profileName then return; end

  TTPCDB.NEHXY = tablecopy(TTDB.SavedNEHProfiles[profileName]);
  TTPCDB.SelectedNEHProfile = profileName;

  TankTotals:UpdateTotals();
end

function NEH:SaveProfile(profileName)
  if profileName and profileName ~= "" then
    TTDB.SavedNEHProfiles[profileName] = tablecopy(TTPCDB.NEHXY);
    TTPCDB.SelectedNEHProfile = profileName;
  end
end

function NEH:DeleteProfile(profileName)
  if profileName and profileName ~= L["DEFAULT"] then
    TTDB.SavedNEHProfiles[TTPCDB.SelectedNEHProfile] = nil;
    TTPCDB.SelectedNEHProfile = L["DEFAULT"];
    TankTotals.NEH:ResetPercentages();
  end
end

function NEH:ResetPercentages()
  self:AdoptProfile(L["DEFAULT"]);
end

-- import and export complete profile sets
-- each profile is delimited by { and |}; each school by |
-- school/percent pairs are delimited by ,

-- Bleed Only{0,1|1,0|2,0...127,0|}Half Melee{0,0|1,0.5|2,0|4,0.25...|127,0|}

-- if called with no string, show dialog
function NEH:ImportProfileSet(importString)
  if (not importString) then
    StaticPopup_Show("TANKTOTALS_IMPORT");
    -- do the actual import
  elseif strlen(importString) > 0 then
    for _,profile in pairs( { strsplit("}", importString) } ) do
      -- separate profile name and data
      local profileName, profileData = strsplit("{", profile);

      -- check string integrity before proceeding
      if profileName and strlen(profileName) > 0 and profileData then
        -- initialise the new profile table before reconstruction
        TTDB.SavedNEHProfiles[profileName] = getSchoolTable(0, true, true);

        -- extract each school/percentage pairing
        for _,schoolPerc in pairs( { strsplit("|", profileData) } ) do
          -- split school from percentage
          local school, perc = strsplit(",", schoolPerc);

          -- check for integrity and add the profile
          if school and perc and tonumber(school) and tonumber(perc) then
            TTDB.SavedNEHProfiles[profileName][tonumber(school)] = tonumber(perc);
          end
        end
      end
    end
  end
end

-- string representation of profile set
local exportString = "";

-- build and show export string
function NEH:ExportProfileSet()
  exportString = "";

  -- iterate through saved profiles
  for k,v in pairs(TTDB.SavedNEHProfiles) do
    -- don't export DEFAULT
    if k ~= L["DEFAULT"] then
      -- delimite start-of-profile
      exportString = exportString..k.."{";

      -- add non-zero school/percentages
      for school,perc in pairs(v) do
        if perc > 0 then
          exportString = exportString..school..","..perc.."||";
        end
      end

      -- delimit end-of-profile
      exportString = exportString.."}";
    end
  end

  -- show the string for copying
  StaticPopup_Show("TANKTOTALS_EXPORT");
end

-- create popup frames for import/export
StaticPopupDialogs["TANKTOTALS_IMPORT"] =
{
  text = L["NEH_IMPORT_INSTRUCTIONS"],
  button1 = L["NEH_IMPORT"],
  button2 = L["NEH_CLOSE"],
  OnAccept = function(self)
    TankTotals.NEH:ImportProfileSet(self.wideEditBox:GetText());
  end,
  timeout = 0,
  whileDead = true,
  hasEditBox = true,
  maxLetters = 16384,
  hideOnEscape = true,
  hasWideEditBox = true,
};

-- create popup frames for import/export
StaticPopupDialogs["TANKTOTALS_EXPORT"] =
{
  text = L["NEH_EXPORT_INSTRUCTIONS"],
  button2 = L["NEH_CLOSE"],
  OnShow = function(self)
    self.wideEditBox:SetMaxLetters(strlen(exportString) + 10);
    self.wideEditBox:SetText(exportString);
    self.wideEditBox:SetFocus();
    self.wideEditBox:HighlightText();
  end,
  timeout = 0,
  whileDead = true,
  hasEditBox = true,
  hideOnEscape = true,
  hasWideEditBox = true,
};

