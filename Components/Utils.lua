
local S = TankTotals.S;

-- Theck's formula is of the form
--
-- EH = E*H, E = D/d
--
-- But,
--
-- d = D*(1-M)
-- => M = 1 - d/D
--
-- thus, weighted mitigation across all damage sources is
--
-- M = 1 - (1/E)
--
-- where
--
-- E = (1-X-Y)/(1-Ma)(1-Mt) + X/(1-Mt) + sumi[Yi/(1-Mgi)(1-Mri)]

-- return the expected overall mitigation, given relative
-- percentages of bleed and magic damage in TTPCDB.NEHXY
function TankTotals:GetWeightedMitigation()
  local wMit = 0.0;

  -- iterate over melee (1-X-Y)/(1-Ma)(1-Mt)
  -- spell schools sumi[Yi/(1-Mgi)(1-Mri)]
  -- bleeds X/(1-Mt)
  for i,v in pairs(TTPCDB.NEHXY) do
    wMit = wMit + infDiv(v, self.FinalMitigation[i]);
  end

  -- wMit is E, return 1/E
  return infDiv(1, wMit);
end

-- spell mitigation from resistances occurs in increments of 10%.
-- Average mitigation is given by A = R / (R + C). For every 10%
-- average mitigation, the increment 2 steps previously is
-- eliminated from the list of potential resists; thus, minimum
-- guaranteed mitigation from resistance is (X-10)%. For instance,
-- at 20% average mitigation, 0% mitigation is no longer possible;
-- therefore, 10% mitigation is the minimum. At 30% average, 10%
-- resists are no longer possible, and 20% becomes the minimum.
function TankTotals:GetResistanceMinAvg(resValue)
  -- avgRes = resValue / (resValue + 400 for lvl80s, 510 for bosses)
  avgRes = resValue / (resValue + 400 + TTDB.EnemyLevelDiff * (110/3));
  minRes = max(0, floor(avgRes/0.1 - 1)) / 10;

  -- returns 0 <= x <= 1, not percentages
  return (1-minRes), (1-avgRes);
end

-- mixed-school resistances are the minimum of their component
-- schools (or the max, given that we are working in 1-X format)
function TankTotals:UpdateMixedResistances()
  for mixed, bases in pairs(self.MixedMagicMap) do
    self.MinResistances[mixed] = max(self.MinResistances[bases[1]], self.MinResistances[bases[2]]);
    self.AvgResistances[mixed] = max(self.AvgResistances[bases[1]], self.AvgResistances[bases[2]]);
  end
end

-- determines whether the average spell mitigation for any school
-- differs from the guaranteed minimum mitigation across all
-- schools. This is used to hide the resistance figures when they
-- are irrelevant (i.e. no probabilistic spell mitigation talents
-- and no active resistances).
function TankTotals:ResMinNotEqualToAvg()
  for rIndex, rVal in pairs(self.AvgResistances) do
    if rVal ~= self.GuaranteedSpellMitigation then
      return true;
    end
  end

  return false;
end

-- returns groupings of magic schools whose minimum mitigations
-- are equal to each other AND greater than the cross-school minimum
function TankTotals:GetSpecialMinResGroups()
  local minResGroups = nil;

  for rIndex, rVal in pairs(self.FinalMitigation) do
    -- ignore physical and mixed schools
    if self:IsBaseMagicSchool(rIndex) then
      if rVal ~= self.GuaranteedSpellMitigation then
        if minResGroups == nil then minResGroups = { {} }; end

        for gIndex, gVal in pairs(minResGroups) do
          -- empty group or group matches current minres
          if getn(gVal) == 0 or (rVal == self.FinalMitigation[gVal[1]] and rIndex ~= gVal[1]) then
            tinsert(minResGroups[gIndex], rIndex);
          elseif gIndex == getn(minResGroups) then -- last group checked, need to create new
            tinsert(minResGroups, { rIndex });
            break;
          end
        end
      end
    end
  end

  return minResGroups;
end

function TankTotals:IsGlyphActive(glyphName)
  for i = 1, GetNumGlyphSockets() do
    local _, _, glyphSpellID = GetGlyphSocketInfo(i);

    if(glyphSpellID and glyphName == GetSpellInfo(glyphSpellID)) then
      return true;
    end
  end

  return false;
end

function TankTotals:CheckGemOrEnchant(slotName, goeID)
  local itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4 = self:GetItemInfo(slotName);
  return (goeID == abs(enchantID) or goeID == abs(jewelID1) or goeID == abs(jewelID2) or goeID == abs(jewelID3) or goeID == abs(jewelID4));
end

local setBonusSlots = { "HeadSlot", "ShoulderSlot", "ChestSlot", "HandsSlot", "LegsSlot" };

-- find the number of pieces of a given set which the player is wearing
function TankTotals:CheckGearSetIDs(itemIDRanges)
  local numPieces = 0;

  for i = 1, getn(setBonusSlots) do
    local itemID = abs(self:GetItemInfo(setBonusSlots[i]));

    if (itemID >= itemIDRanges[1] and itemID <= itemIDRanges[2]) or (itemID >= itemIDRanges[3] and itemID <= itemIDRanges[4]) then
      numPieces = numPieces + 1;
    end
  end

  return numPieces;
end

-- returns itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4
function TankTotals:GetItemInfo(slotName)
  local slotID, textureName = GetInventorySlotInfo(slotName);
  local itemLink = GetInventoryItemLink("player", slotID);

  if itemLink == nil then return 0, 0, 0, 0, 0, 0; end

  local found, _, itemString = string.find(itemLink, "^|c%x+|H(.+)|h%[.*%]");
  local _, itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4, _, _, _ = strsplit(":", itemString);

  return itemID, enchantID, jewelID1, jewelID2, jewelID3, jewelID4;
end

function TankTotals:IsMeleeSlowDebuff(debuffName)
  return (debuffName == S["Judgements of the Just"] or debuffName == S["Thunder Clap"] or debuffName == S["Infected Wounds"] or debuffName == S["Frost Fever"] or debuffName == S["Earth Shock"]);
end

function TankTotals:InstanceStanceOrPVP()
  local inInstance, instanceType = IsInInstance();

  if(TTPCDB.StanceAnnounce and (not self.ClassModule:TankingStanceActive())) then return false; end

  if(not inInstance) then
    return (not TTPCDB.InstanceAnnounce);
  elseif(instanceType == "pvp" or instanceType == "arena") then
    return TTPCDB.PVPAnnounce;
  else
    return true;
  end
end

-- if announces are set to an invalid channel for your
-- current setup, then change it to the nearest equivalent
-- if you're in a party:
-- RAID => PARTY, RAID_WARNING => YELL
-- if you're in a raid but not promoted:
-- RAID_WARNING => YELL
function TankTotals:CheckChannel(channel)
  channel = (channel or TTDB.AnnounceChannel);

  -- 0 if we're not in a raid
  if GetNumRaidMembers() == 0 then
    if channel == "RAID" then -- RAID => PARTY
      return "PARTY";
    elseif channel == "RAID_WARNING" then -- RAID_WARNING => YELL
      return "YELL";
    end
    -- it's set to RAID_WARNING, we're in a raid but not promoted
  elseif channel == "RAID_WARNING" and not (IsRaidLeader() or IsRaidOfficer()) then
    return "YELL"; -- RAID_WARNING => YELL
  end

  -- no change needed
  return channel;
end

function TankTotals:IsBaseMagicSchool(schoolIndex)
  if schoolIndex <= TankTotals.INDEX_MELEE then return false; end

  local logIndex = log10(schoolIndex)/log10(2);
  return (logIndex == floor(logIndex));
end

function ttvFormat(fullValue, decPlaces)
  if fullValue == nil then return nil; end
  if decPlaces == nil then decPlaces = TTDB.DecimalAccuracy; end

  return ((fullValue == 0 and 0) or format("%."..decPlaces.."f", fullValue));
end

function round(inValue)
  return floor(inValue + 0.5);
end

-- sums the contents of a table
function tablesum(inTable)
  sum = 0;

  for k,v in pairs(inTable) do
    sum = sum + v;
  end

  return sum;
end

-- adds the corresponding elements of two tables
-- if an element in table2 doesn't exist in table1,
-- the value from table2 will be adopted
function tableadd(inTable1, inTable2)
  local outTable = {};

  for k,v in pairs(inTable1) do
    outTable[k] = v + (inTable2[k] or 0);
  end

  for k,v in pairs(inTable2) do
    if not inTable1[k] then outTable[k] = v; end
  end

  return outTable;
end

-- subtracts the corresponding elements of two tables
-- if an element in table2 doesn't exist in table1, the
-- negative of the value from table2 will be adopted
function tablesubtract(inTable1, inTable2)
  local outTable = {};

  for k,v in pairs(inTable1) do
    outTable[k] = v - (inTable2[k] or 0);
  end

  for k,v in pairs(inTable2) do
    if not inTable1[k] then outTable[k] = -v; end
  end

  return outTable;
end

-- single-level copy
function tablecopy(inTable)
  local outTable = {};

  for k,v in pairs(inTable) do
    outTable[k] = v;
  end

  return outTable;
end

-- deep table copy
function tabledeepcopy(inTable)
  local lookup_table = {};

  local function _copy(object)
    if type(object) ~= "table" then
      return object;
    elseif lookup_table[object] then
      return lookup_table[object];
    end

    local new_table = {};
    lookup_table[object] = new_table;

    for index, value in pairs(object) do
      new_table[_copy(index)] = _copy(value);
    end

    return setmetatable(new_table, _copy(getmetatable(object)));
  end

  return _copy(inTable);
end

function infDiv(num, denom, fallback)
  if (not denom) or denom == 0 then
    return (fallback or 0.0);
  else
    return num/denom;
  end
end
