
local S = TankTotals.S;
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

local Warrior = TankTotals:NewModule("Warrior", TankTotals.SuperClass, "AceEvent-3.0");

Warrior.CLASS_NAME = "WARRIOR";
Warrior.ParryableGCDs = 0.825;	-- TC & Demo every 30s, SW every 20s

local CritBlock = 1.0;

Warrior.BlockTotal = 0;

function Warrior:OnEnable()
	self:RegisterBuffs();
	self:EditConfigTable();

	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function Warrior:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
	local eventType, _, _, _, destGUID, _, _ = select(2, ...);

	if destGUID == UnitGUID("player") then
		-- QuickHealth update
		TankTotals.QH:UpdateQuickHealth(...);

		-- record blocked total this fight
                if eventType == "SWING_DAMAGE" then
                    self.BlockTotal = self.BlockTotal + (select(13, ...) or 0);
		-- fully blocked attacks
                elseif eventType == "SWING_MISSED" and select(9,...) == "BLOCK" then
                    self.BlockTotal = self.BlockTotal + (select(10, ...) or 0);
		-- this is an aura gain event
		elseif(eventType == "SPELL_AURA_APPLIED") then
			-- Shield Block buff is not time-consistent
			if select(10, ...) == S["Shield Block"] then
				TankTotals:ScheduleTimer("UpdateTotals", 0.75);
			end
		-- this is an aura loss event
		elseif(eventType == "SPELL_AURA_REMOVED") then
			-- Shield Block buff is not time-consistent
			if select(10, ...) == S["Shield Block"] then
				TankTotals:ScheduleTimer("UpdateTotals", 0.75);
			end
		end
	end
end

function Warrior:PLAYER_REGEN_DISABLED()
	self.BlockTotal = 0;
        TankTotals:UpdateTotals();
end

function Warrior:ResetValues()
	-- nothing relevant
end

function Warrior:RegisterBuffs()
	TankTotals.SelfCooldowns[S["Shield Wall"]] = L["SW_YELL"];
	TankTotals.SelfCooldowns[S["Last Stand"]] = L["LS_YELL"];

	TankTotals.MitigationBuffs[S["Defensive Stance"]] = 0.9;
	TankTotals.MitigationBuffs[S["Berserker Stance"]] = 1.05;	-- 5% increased damage taken
	TankTotals.MitigationBuffs[S["Shield Wall"]] = 0.4;

	TankTotals.SpellMitigationBuffs[S["Defensive Stance"]] = 1.0;	-- this is for imp. def stance; will be obtained from talents

        -- t10 4-set bonus: 20% of max HP absorbed
	TankTotals.MitigationBuffs[S["Stoicism"]] = 1.0;		-- dummy value to trigger recalc
end

function Warrior:GetTalentInfo()
	local nameTalent, icon, tier, column, currRank, maxRank;

	-- improved spell reflect: 2/4% chance for spells to miss
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 10);
	TankTotals.PassiveProbSpellMitigation = TankTotals.PassiveProbSpellMitigation * (1 - currRank * 0.02);

	-- improved defensive stance
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 17);
	TankTotals.SpellMitigationBuffs[S["Defensive Stance"]] = 1 - 0.03 * currRank;

	-- critical block
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 24);
	CritBlock = 1.0 + (currRank * 0.2);

	-- safeguard goes on target, not self
	-- nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 21);
	-- TankTotals.MitigationBuffs["Safeguard"] = 1 - 0.15 * currRank;
end

function Warrior:CheckSetBonuses()
	local updateNeeded = false;

-- Siegebreaker Plate T8, herioc/normal itemID ranges
	-- 4-set: shield block gives 20% spell mitigation
	if TankTotals:CheckGearSetIDs({ 46162, 46169, 45424, 45428 }) > 3 then
		updateNeeded = updateNeeded or (TankTotals.SelfCooldowns[S["Shield Block"]] == nil);
		TankTotals.SpellMitigationBuffs[S["Shield Block"]] = 0.8;
		TankTotals.SelfCooldowns[S["Shield Block"]] = L["SB_YELL"];
	else
		updateNeeded = updateNeeded or (TankTotals.SelfCooldowns[S["Shield Block"]] ~= nil);
		TankTotals.SpellMitigationBuffs[S["Shield Block"]] = 1.0;
		TankTotals.SelfCooldowns[S["Shield Block"]] = nil;
	end

	return updateNeeded;
end

function Warrior:CheckEnchantsAndGlyphs()
	-- glyph of Shield Wall drops mitigation to 40%
	if TankTotals:IsGlyphActive(S["Glyph of Shield Wall"]) then
		TankTotals.MitigationBuffs[S["Shield Wall"]] = 0.6;
	else
		TankTotals.MitigationBuffs[S["Shield Wall"]] = 0.4;
	end
end

function Warrior:GetSpecialMitigation()
	-- no relevant modifiers
	return { 1.0, 1.0, 1.0, 1.0 };
end

-- returns flat mitigation as % damage after reduction
function Warrior:GetFlatMitigationDR()
	if TTPCDB.MobHitAmount > 0 then
		-- (BV as % of post-mitigated hit) * (% of hits that are blocked)
		return 1 - (min(1, (GetShieldBlock() * CritBlock) / (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE])) * min(1, GetBlockChance() / (100 - TankTotals.Avoidance)));
	end

	return 1.0;
end

function Warrior:GetFlatMitigationInfo()
	-- block value
	return L["WARR_FLATMIT"], GetShieldBlock();
end

function Warrior:IsSingleTargetTaunt(spellID)
	local spellName = GetSpellInfo(spellID);
	return (spellName == S["Taunt"] or spellName == S["Mocking Blow"]);
end

function Warrior:IsAoETaunt(spellID)
	return (GetSpellInfo(spellID) == S["Challenging Shout"]);
end

function Warrior:TankingStanceActive()
	return (UnitBuff("player", S["Defensive Stance"]) ~= nil) or (self:GetCurrentStance() == S["Defensive Stance"]);
end

function Warrior:AddCustomDisplayText(recipient)
	-- t10 4-set: 20% of max HP absorbed
	if UnitBuff("player", S["Stoicism"]) ~= nil then
		recipient:AddLine("", "");
		recipient:AddLine("|cffffff00"..S["Stoicism"]..":|r", "|cffffff00"..ttvFormat((TankTotals.PlayerQuickHealthMax * 0.2) / 1000, 2).."k|r");
	end
end

function Warrior:EditConfigTable()
	TankTotals.ConfigTable.args.Announce.args.aoetauntmisses=
	{
		type="toggle", order = 3, name=L["SETTINGS_SPECIALTAUNT"], desc=L["SETTINGS_SPECIALTAUNT_DESC"],
		get=function() return TTPCDB.SpecialTaunts end,
		set=function() TTPCDB.SpecialTaunts = (not TTPCDB.SpecialTaunts); end
	};
end

