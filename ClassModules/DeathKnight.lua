
local S = TankTotals.S;
local super = TankTotals.SuperClass;
local media = LibStub("LibSharedMedia-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

local DeathKnight = TankTotals:NewModule("DeathKnight", super, "AceEvent-3.0");

DeathKnight.CLASS_NAME = "DEATHKNIGHT";
DeathKnight.ShowBlockInfo = false;

local BloodCakedBlade = 0.0;

local WillSaves = 0;
local WillMitigated = 0;

-- local WOTN_Bar = nil;

local GlyphOfUA, GlyphOfIBF = false, false;
local RuneOfNC, RuneOfSB, RuneOfSSG, RuneOfSSh = 0, 0, 0, 0;

local Thassarian = 1.0;
local MagicSuppression = 0;
local DarkrunedBonus = false;	-- AMS gives 10% physical mitigation

-- not needed in 3.2.2; keep in case it changes again
local UnbreakableArmor = false;

-- WOTN constants
DeathKnight.WOTN_THRESHOLD = 0.35;

--DeathKnight.WOTN_CD = 15;
--DeathKnight.WOTN_MIN_DAMAGE = 0.05;

function DeathKnight:OnEnable()
	self:RegisterBuffs();
	self:EditConfigTable();

	L["WOTN_YELL"] = TTPCDB.ArdentText or L["WOTN_YELL_ORIG"];

	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("UNIT_INVENTORY_CHANGED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function DeathKnight:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
        -- QuickHealth update
        TankTotals.QH:UpdateQuickHealth(...);

	local timeStamp, eventType, _, _, _, destGUID, _, _ = select(1, ...);

	if destGUID == UnitGUID("player") then
                -- Will of the Necropolis monitoring and announce
                if TankTotals.MitigationBuffs[S["Will of the Necropolis"]] < 1 and (strfind(eventType, "_DAMAGE") and not strfind(eventType, "DURABILITY_DAMAGE")) then
                            -- if it's not valid damage, return immediately
                        if eventType == "ENVIRONMENTAL_DAMAGE" and not (select(9, ...) == "FIRE" or select(9, ...) == "LAVA" or select(9, ...) == "SLIME") then return; end

                        local pOff = 0; -- parameter offset

                        -- offset +1 if it's environmental, +3 if it's anything else other than a melee swing
                        if eventType == "ENVIRONMENTAL_DAMAGE" then pOff = 1; elseif eventType ~= "SWING_DAMAGE" then pOff = 3; end

                        -- WOTN doesn't proc on a killing blow, and absorb == 0 => WOTN = 0
                        if select(10+pOff, ...) > 0 or select(14+pOff,...) == 0 then return; end

                        -- damage, resist, block, absorb (including WOTN)
                        -- WOTN absorb is applied AFTER resistance is applied
                        local dmgAmount = select(9+pOff, ...), resist, absorb, block;
                        resist = (select(12+pOff,...) or 0); block = (select(13+pOff,...) or 0); absorb = (select(14+pOff,...) or 0);

                        -- get mitigation amount
                        local wotnMit = self:WOTN_MitigationAmount(dmgAmount, absorb, nil, nil, timeStamp);

                        -- add mitigation to running tally
                        if wotnMit > 0 then
        		    -- self:StartWOTNCDBar(); -- no ICD after 3.3.3
                            WillMitigated = WillMitigated + wotnMit;

                            -- WOTN's mitigation saved us, so add and announce it
                            if TankTotals.PlayerQuickHealth <= wotnMit then
                                    self:AddWOTNSave(L["WOTN_YELL"]);
                            end
    
                            TankTotals:UpdateTotals();
                        end
                end
	end
end

function DeathKnight:PLAYER_REGEN_DISABLED()
	if TTPCDB.ArdentPerFight then
		WillSaves = 0;
		WillMitigated = 0; 
	end
end

function DeathKnight:PLAYER_REGEN_ENABLED()
	if TTPCDB.ArdentPerFight then
		if WillMitigated > 0 then
                        DEFAULT_CHAT_FRAME:AddMessage("");
			TankTotals:Print("|cffffff00["..S["Will of the Necropolis"].."]|r "..L["PERFIGHT_REPORT"]);
			TankTotals:Print("|cff00ff00"..L["PERFIGHT_MITIGATED"].."|r "..floor(WillMitigated));
			TankTotals:Print("|cff00ff00"..L["PERFIGHT_SAVES"].."|r "..WillSaves);
                        DEFAULT_CHAT_FRAME:AddMessage("");
		end
	end
end

function DeathKnight:UNIT_INVENTORY_CHANGED(eventName, unitID)
	if unitID == "player" then
		if self:CheckEnchantsAndGlyphs() then
		        TankTotals:UpdateTotals();
		end
	end
end

function DeathKnight:ResetValues()
	GlyphOfUA = false;
	GlyphOfIBF = false;

	RuneOfSB = 0;
        RuneOfNC = 0;
	RuneOfSSG = 0;
	RuneOfSSh = 0;

	DarkrunedBonus = false;	-- AMS gives 10% physical mitigation
	UnbreakableArmor = false;
end

function DeathKnight:RegisterBuffs()
	TankTotals.SelfCooldowns[S["Icebound Fortitude"]] = L["IBF_YELL"];
	TankTotals.SelfCooldowns[S["Unbreakable Armor"]] = L["UA_YELL"];
	TankTotals.SelfCooldowns[S["Vampiric Blood"]] = L["VB_YELL"];
	TankTotals.SelfCooldowns[S["Bone Shield"]] = L["BS_YELL"];

        -- t10 4-set announce
	TankTotals.SelfCooldowns[S["Blood Armor"]] = strupper(S["Blood Armor"]);

	-- icebound fortitude, AOTD and UA are included to
        -- trigger a recalc when they appear on the player
	TankTotals.MitigationBuffs[S["Bone Shield"]] = 0.8;
	TankTotals.MitigationBuffs[S["Army of the Dead"]] = 1.0;	-- dummy value to indicate that the ability is accounted for; must be calculated on the fly
--	TankTotals.MitigationBuffs[S["Unbreakable Armor"]] = 1.0;	-- dummy value to indicate that the ability is accounted for; must be calculated on the fly
	TankTotals.MitigationBuffs[S["Icebound Fortitude"]] = 1.0;	-- icebound fortitude is variable and must be calculated in the custom GetSpecialMitigation function
	TankTotals.MitigationBuffs[S["Frost Presence"]] = 0.92;		-- modified by talents
	TankTotals.MitigationBuffs[S["Blade Barrier"]] = 1.0;		-- depends on talents
	TankTotals.MitigationBuffs[S["Will of the Necropolis"]] = 1.0;	-- depends on talents

	TankTotals.SpellMitigationBuffs[S["Anti-Magic Shell"]] = 1.0;	-- dummy value to trigger recalc; modified from talents
	TankTotals.SpellMitigationBuffs[S["Spell Deflection"]] = 1.0;	-- special case; conditional passive mitigation

        -- t10 4-set bonus: 12% damage reduction
	TankTotals.MitigationBuffs[S["Blood Armor"]] = 0.88;
end

function DeathKnight:GetTalentInfo()
	local nameTalent, icon, tier, column, currRank, maxRank;

	-- blade barrier
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(1, 3);
	TankTotals.MitigationBuffs[S["Blade Barrier"]] = 1.0 - (0.01 * currRank);

	-- spell deflection (special case; get reduction X rather than postmitigated damage 1-X)
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(1, 11);
	TankTotals.SpellMitigationBuffs[S["Spell Deflection"]] = 0.15 * currRank;

	-- will of the necropolis
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(1, 24);
	TankTotals.MitigationBuffs[S["Will of the Necropolis"]] = 1 - (0.05 * currRank);

	-- frigid dreadplate
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 13);
	TankTotals.NonDRMiss = TankTotals.NonDRMiss + currRank;

	-- improved frost presence
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 21);
	TankTotals.MitigationBuffs[S["Frost Presence"]] = 0.92 - (0.01 * currRank);

	-- unbreakable armor
--	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 23);
--	UnbreakableArmor = (currRank > 0);

	-- magic suppression
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 18);
	TankTotals.PassiveSpellMitigation = TankTotals.PassiveSpellMitigation * (1 - currRank * 0.02);
	MagicSuppression = currRank;

-- primarily for parry-haste considerations
	-- vampiric blood: if specced for it, then we're a blood tank
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(1, 23);
	if currRank > 0 then self.ParryableGCDs = 10/12; else self.ParryableGCDs = 8/10; end

	-- threat of thassarian applies rune strike to OH attacks
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 22);
	Thassarian = 1.0 - (currRank * 0.3) - (floor(currRank/3) * 0.1);

	-- blood caked blade: X% chance to proc a parryable attack
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 12);
	BloodCakedBlade = (currRank/10);

--	TankTotals.SpellMitigationBuffs[S["Anti-Magic Shell"]] = 0.25 - (0.08 * currRank + floor(currRank/3) / 100.0);
end

function DeathKnight:CheckSetBonuses()
	local updateNeeded = false;

-- Darkrune Plate T8, heroic/normal itemID ranges
	-- 4-set: AMS gives 10% physical mitigation
	if (TankTotals:CheckGearSetIDs({ 46118, 46122, 45335, 45339 }) > 3) then
		if not DarkrunedBonus then DarkrunedBonus = true; updateNeeded = true; end
	else
		if DarkrunedBonus then DarkrunedBonus = false; updateNeeded = true; end
	end

	return updateNeeded;
end

function DeathKnight:CheckEnchantsAndGlyphs()
	local oldVals = { RuneOfSB, RuneOfSSh, RuneOfSSG, RuneOfNC, GlyphOfUA, GlyphOfIBF };

	-- check weapon for Rune of SpellBreaking / Spellshattering / Gargoyle / Nerubian Carapce
	if TankTotals:CheckGemOrEnchant("MainHandSlot", 3595) then RuneOfSB = 1 else RuneOfSB = 0; end -- Rune of Spellbreaking (MH)
	if TankTotals:CheckGemOrEnchant("SecondaryHandSlot", 3595) then RuneOfSB = (RuneOfSB + 1); end -- Rune of Spellbreaking (OH)

	if TankTotals:CheckGemOrEnchant("MainHandSlot", 3883) then RuneOfNC = (13/25) else RuneOfNC = 0; end -- Rune of the Nerubian Carapace (MH)
	if TankTotals:CheckGemOrEnchant("SecondaryHandSlot", 3883) then RuneOfNC = (RuneOfNC + (13/25)); end -- Rune of the Nerubian Carapace (OH)

	if TankTotals:CheckGemOrEnchant("MainHandSlot", 3367) then RuneOfSSh = 1 else RuneOfSSh = 0; end -- Rune of Spellshattering
	if TankTotals:CheckGemOrEnchant("MainHandSlot", 3847) then RuneOfSSG = 1 else RuneOfSSG = 0; end -- Rune of the Stoneskin Gargoyle

--	GlyphOfUA = TankTotals:IsGlyphActive(S["Glyph of Unbreakable Armor"]);
	GlyphOfIBF = TankTotals:IsGlyphActive(S["Glyph of Icebound Fortitude"]);

	return not(RuneOfSB == oldVals[1] and RuneOfSSh == oldVals[2] and RuneOfSSG == oldVals[3] and RuneOfNC == oldVals[4] and GlyphOfUA == oldVals[5] and GlyphOfIBF == oldVals[6]);
end

function DeathKnight:GetMissParryChance()
	-- miss from defense is x' = 1/(1/c + k/x), 1/c = 1/16 = 0.0625, k = 0.956
	return RuneOfSSG + RuneOfNC + GetParryChance() + self:GetMissAfterDR();
end

-- return { universalMit, physMit, spellMit, probSpellMit }
function DeathKnight:GetSpecialMitigation()
	local specialMit = { 1.0, 1.0, 1.0, 1.0 };

	-- anti-magic shell gives 100% spell mitigation with 3 talent points
	if(UnitBuff("player", S["Anti-Magic Shell"]) ~= nil) then
		specialMit[3] = specialMit[3] * (0.25 - (0.08 * MagicSuppression + floor(MagicSuppression/3) / 100.0));
	end

	-- spell deflection is a passive talent, but it varies with parry; must include it with dynamic mitigation buffs
	specialMit[4] = specialMit[4] * (1 - TankTotals.SpellMitigationBuffs[S["Spell Deflection"]] * (GetParryChance() / 100.0));

	-- army of the dead reduces damage by (dodge + parry)%
	if(UnitBuff("player", S["Army of the Dead"]) ~= nil) then
		specialMit[1] = specialMit[1] * (1 - (GetDodgeChance() + GetParryChance())/100);
	end

	-- IBF is unique among shield walls in that its effect is variable with defense skill
	if(UnitBuff("player", S["Icebound Fortitude"]) ~= nil) then
		local ibfMitigation = (0.7 - (GetCombatRating(CR_DEFENSE_SKILL)/TankTotals.DEF_RATING_PER_SKILL) * 0.0015);

		-- glyph of IBF gives minimum 40% mitigation
		if GlyphOfIBF then
			ibfMitigation = min(ibfMitigation, 0.6);
		end

		specialMit[1] = specialMit[1] * ibfMitigation;
	end

	-- apply runeweapon effects
        specialMit[3] = specialMit[3] * (0.98^RuneOfSB);    -- Rune of Spellbreaking (MH/OH)
        specialMit[3] = specialMit[3] * (0.96^RuneOfSSh);   -- Rune of Spellshattering (2H)

	-- darkruned 4-set bonus: AMS gives 10% physical mitigation.
	if DarkrunedBonus and UnitBuff("player", S["Anti-Magic Shell"]) ~= nil then
		specialMit[2] = specialMit[2] * 0.9;
	end

	return specialMit;
end

-- returns flat mitigation as % damage after reduction
function DeathKnight:GetFlatMitigationDR()
	local flatMitigation = 1.0;

-- reverted in 3.2.2 to give +25% armor. Keep this in case they change their minds again.
--	if TTPCDB.MobHitAmount > 0 and UnitBuff("player", S["Unbreakable Armor"]) ~= nil then
--		-- UA as % of post-mitigated hit
--		_, flatMitigation = self:GetFlatMitigationInfo();
--		return 1 - (min(1, flatMitigation / (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE])));
--	end

	return flatMitigation;
end

-- returns effective HP, or nil for infinite health
function DeathKnight:GetEffectiveHealth()
	if TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] == 0 then
		return nil;
	end

	-- unbreakable armor is passive damage mitigation, so it contributes to EH when active
        -- changed to armor bonus in 3.2.2; keep this in case they change their minds again
--	local flatDR = self:GetFlatMitigationDR(); if flatDR == 0 then return nil; end
--	local effHealth = TankTotals.PlayerQuickHealthMax / (TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] * flatDR);

	local effHealth = TankTotals.PlayerQuickHealthMax / TankTotals.FinalMitigation[TankTotals.INDEX_MELEE];

	-- if specced for WOTN, it will mitigate one of the incoming hits
	if TTPCDB.ArdentEHTTL and TTPCDB.MobHitAmount > 0 then
		if TankTotals.MitigationBuffs[S["Will of the Necropolis"]] < 1 and (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE]) / TankTotals.PlayerQuickHealthMax >= 0.05 then
			effHealth = effHealth + (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] * (1 - TankTotals.MitigationBuffs[S["Will of the Necropolis"]]));
		end
	end

	return effHealth;
end

-- ahhh, DKs. Always got to be fucking different.
function DeathKnight:GetParryHasteEffect()
        local hasteMod = 1.0;

        if TTDB.ParryHaste then
            -- mh and oh parry reduction %
            local mhPC, ohPC = GetExpertisePercent();

            -- how many times do we attack between boss swings?
            local playerMH, playerOH = UnitAttackSpeed("player");
            local parryWindow, enemyOH = UnitAttackSpeed("target");

            -- assume 2.4 if no target
            if parryWindow == 0 then parryWindow = 2.4; end

            -- DW boss, parry window is swing interval
            if enemyOH then parryWindow = abs(parryWindow - enemyOH); end

            -- per-attack chance of getting a parry: 5% vs 80s (+ 9% vs 83s) - expReduction
            local parryChance = max(0, (5 + (TTDB.EnemyLevelDiff * 3) - mhPC)/100);

            -- chance to get at least 1 parry between boss swings
	    -- MH hits are assumed to be converted to Rune Strikes, so ignore them unless specced for Blood Caked Blade
	    -- BCB can proc from offhand hits, but offhand hits are not converted to Rune Strikes; rate is therefore 1+BCB
	    -- if specced for Threat of Thassarian, OH hits are converted to Rune Strikes but BCB can still proc from them; rate is therefore ThTh+BCB
            -- 1 - (not-parry chance per swing)^(number of swings) * (not-parry chance per swing)^(number of parryable GCD attacks)
            if OffhandHasWeapon() then
                    -- rogue wannabes
                    local ohParryChance = max(0, (5 + (TTDB.EnemyLevelDiff * 3) - ohPC)/100);
                    parryChance = 1 - (1-parryChance)^(BloodCakedBlade * (parryWindow / playerMH)) * (1-ohParryChance)^((Thassarian+BloodCakedBlade) * (parryWindow / playerOH)) * (1-parryChance)^(self.ParryableGCDs * (parryWindow / 1.5));
            else
                    parryChance = 1 - (1-parryChance)^(BloodCakedBlade * (parryWindow / playerMH)) * (1-parryChance)^(self.ParryableGCDs * (parryWindow / 1.5));
            end

            -- parry chance * ((20% to 60%)*(20% haste) + (60% to 100%)*(40% haste))
            hasteMod = 1.0 - parryChance * (0.4*0.2 + 0.4*0.4);
        end

        -- returns a coefficient indicating the average reduction in swing timer
        return hasteMod;
end

function DeathKnight:GetFlatMitigationInfo()
	-- unbreakable armor changed in 3.2.2 from flat mit to armor boost
        -- this code is kept for legacy purposes, in case they reintroduce it
	if UnbreakableArmor == false then
		return nil, nil;
	else
--		local _, effectiveArmor, _, _, _ = UnitArmor("player");

--		if GlyphOfUA then
--			return L["DK_FLATMIT"], (effectiveArmor * 0.06);
--		else
--			return L["DK_FLATMIT"], (effectiveArmor * 0.05);
--		end
	end
end

-- Wrapper for generic Unmitigate. Adds class-specific features, i.e. WOTN.
function DeathKnight:Unmitigate(dmg, school, resist, block, absorb, timeStamp)
        -- get generic unmitigated damage
        local unmitDmg, probResist = super.Unmitigate(self, dmg, school, resist, block, absorb);

        -- find the amount of damage absorbed by WOTN
        local wotnAbsorb = self:WOTN_MitigationAmount(dmg, absorb, nil, nil, timeStamp);

        -- return results
        return unmitDmg, probResist, max(0, absorb - wotnAbsorb), wotnAbsorb;
end

-- local lastWOTNTime = 0; -- WOTN has an ICD -- 3.3.3: not any more it doesn't

-- Calculates the mitigation provided by WOTN given damage, absorb and
-- timestamp. Can be supplied with arbitrary values of time, current HP
-- and max HP. Defaults to current values of each if omitted.
function DeathKnight:WOTN_MitigationAmount(damage, absorb, hp, maxHP, timeStamp)
        -- no absorb implies no WOTN
        if (not absorb) or absorb == 0 then return 0; end

        -- need timeStamp to check CD -- 3.3.3: not any more you don't
        -- timeStamp = (timeStamp or time());

        -- WOTN has an internal cooldown; test against zero in case we're processing the same event from two calls
        -- if (timeStamp - lastWOTNTime) > 0 and (timeStamp - lastWOTNTime) < self.WOTN_CD then return 0; end

        -- init params if needed
        hp = (hp or TankTotals.PlayerQuickHealth);
        maxHP = (maxHP or TankTotals.PlayerQuickHealthMax);

        -- WOTN is applied between resists and flat absorption; therefore
        -- (damage + absorb) is the number that WOTN considers. From this
        -- we should be able to come up with an accurate approach.

        -- check if the hit would have crossed 35%. (hp+damage) is previous HP,
        -- (hp-absorb) is what we would have been at if we'd taken the full hit.
        -- 3.3.3: not constrained to 5% of max HP, all damage crossing or below 35% is reduced
        if (hp-absorb) / maxHP < self.WOTN_THRESHOLD then -- and (hp+damage) / maxHP >= self.WOTN_THRESHOLD and (damage+absorb) / maxHP >= self.WOTN_MIN_DAMAGE then
                -- set last WOTN time
                -- lastWOTNTime = timeStamp;

                -- (damage + absorb) is the damage remaining after resistance
                return (damage + absorb) * (1-TankTotals.MitigationBuffs[S["Will of the Necropolis"]]);
        end

        return 0;
end

function DeathKnight:AddWOTNSave(wotnAnnounceText)
        WillSaves = WillSaves + 1;

        if TTPCDB.ArdentPerFight then
                TankTotals:Print("|cffffff00["..S["Will of the Necropolis"].."]|r "..L["SAVE_MSG1"].."|r");
        else
                TankTotals:Print("|cffffff00["..S["Will of the Necropolis"].."]|r "..L["SAVE_MSG1"].." |cff00ff00"..L["SAVE_MSG2"].." "..WillSaves.."|r");
        end

        if TTPCDB.ArdentAnnounce and UnitBuff("player", S["Guardian Spirit"]) == nil then
                TankTotals:Announce((wotnAnnounceText or L["WOTN_YELL"]));
        end
end

function DeathKnight:IsSingleTargetTaunt(spellID)
	-- need to ignore death grip pullback immunity and check the taunt debuff
	return (GetSpellInfo(spellID) == S["Dark Command"] or spellID == 49560 or spellID == 51399);
end

function DeathKnight:IsAoETaunt(spellID)
	return false;
end

function DeathKnight:TankingStanceActive()
	return (UnitBuff("player", S["Frost Presence"]) ~= nil) or (self:GetCurrentStance() == S["Frost Presence"]);
end

--[[
function DeathKnight:StartWOTNCDBar()
	if not (TTPCDB.ArdentCD and TTPCDB.ShowSummary) then return; end

	WOTN_Bar = LibStub("LibCandyBar-3.0"):New(media:Fetch("statusbar", TTPCDB.ArdentTexture), 100, 16);

	WOTN_Bar.candyBarLabel:SetJustifyH("LEFT");
	WOTN_Bar.candyBarLabel:SetJustifyV("MIDDLE");
	WOTN_Bar.candyBarLabel:SetFont(media:Fetch("font", TTDB.Font), 10);

	WOTN_Bar.candyBarDuration:SetJustifyH("RIGHT");
	WOTN_Bar.candyBarDuration:SetJustifyV("MIDDLE");
	WOTN_Bar.candyBarDuration:SetFont(media:Fetch("font", TTDB.Font), 10);

	local _, _, icon = GetSpellInfo(50150);

	WOTN_Bar:SetIcon(icon);
	WOTN_Bar:SetColor(1.0, 0.0, 0.0, 1.0);
	WOTN_Bar:SetLabel(S["Will of the Necropolis"]);

	self:SetWOTNCDBarPos(WOTN_Bar);

	WOTN_Bar:SetWidth((TankTotals.LEFT.frame:GetWidth() + TankTotals.RIGHT.frame:GetWidth()) * TTPCDB.WindowScale);
	WOTN_Bar:SetDuration(self.WOTN_CD);
	WOTN_Bar:Start();
end

function DeathKnight:SetWOTNCDBarPos(wotnBar)
	wotnBar:ClearAllPoints();
	wotnBar.TTGrowDir = TTPCDB.GrowDir;
	wotnBar:SetPoint(TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][1], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"].frame(), TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][3], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][4], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][5]);
end
--]]

function DeathKnight:AddCustomDisplayText(recipient)
	if TankTotals.MitigationBuffs[S["Will of the Necropolis"]] < 1 then
                recipient:AddLine("", "");

                local leftText, rightText;
                local textColor = ((TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax > self.WOTN_THRESHOLD and "|cff00ff00") or "|cffff0000");

                -- WOTN threshold
                leftText = "|cffffff00"..L["WOTN_ACTIVE_HEADING"].."|r";
                rightText = textColor..round(TankTotals.PlayerQuickHealthMax * self.WOTN_THRESHOLD).."|r";

                recipient:AddLine(leftText, rightText);

                -- WOTN mitigation and the number of saves
		recipient:AddLine("|cffffff00"..L["WOTN_TOTAL_HEADING"].."|r", "|cff00ff00"..ttvFormat(WillMitigated / 1000, 2).."k ("..WillSaves..")|r");
	end
end

function DeathKnight:EditConfigTable()
	TankTotals.ConfigTable.args.Class =
	{
		order = 5,
		type = "group",
		name = L["SETTINGS_CLASS"],
		desc = L["SETTINGS_CLASS_DESC"],
                disabled = function() return (not TTPCDB.AddonActive); end,
		args =
		{
			announceWN=
			{
				type="toggle", order = 1, name=L["SETTINGS_WOTN_ANNOUNCE"], desc=L["SETTINGS_WOTN_ANNOUNCE_DESC"],
				get=function() return TTPCDB.ArdentAnnounce end,
				set=function() TTPCDB.ArdentAnnounce = (not TTPCDB.ArdentAnnounce); end
			},
			announceWNText=
			{
				type="input", order = 2, name=L["SETTINGS_WOTN_TEXT"], desc=L["SETTINGS_WOTN_TEXT_DESC"],
				get=function() return TTPCDB.ArdentText or L["WOTN_YELL_ORIG"]; end,
				set=function(info, x) if x == "" then x = L["WOTN_YELL_ORIG"]; end TTPCDB.ArdentText = x; L["WOTN_YELL"] = x; end
			},
--[[			showWOTNCD=
			{
				type="toggle", order = 3, name=L["SETTINGS_WOTN_CDBAR"], desc=L["SETTINGS_WOTN_CDBAR_DESC"],
				get=function() return TTPCDB.ArdentCD end,
				set=function() TTPCDB.ArdentCD = (not TTPCDB.ArdentCD); end
			},
			wotnBarTexture=
			{
				type="select", order = 4, dialogControl = "LSM30_Statusbar", name=L["SETTINGS_CDBAR_TEXTURE"], desc=L["SETTINGS_CDBAR_TEXTURE_DESC"],
				values = AceGUIWidgetLSMlists.statusbar,
				get =	function(info) return TTPCDB.ArdentTexture; end,
				set =	function(info, tex) TTPCDB.ArdentTexture = tex; if WOTN_Bar then WOTN_Bar:SetTexture(media:Fetch("statusbar", TTPCDB.ArdentTexture)); end end
			},
--]]
			wnEHTTL=
			{
				type="toggle", order = 5, name=L["SETTINGS_WOTN_EHTTL"], desc=L["SETTINGS_WOTN_EHTTL_DESC"],
				get=function() return TTPCDB.ArdentEHTTL end,
				set=function() TTPCDB.ArdentEHTTL = (not TTPCDB.ArdentEHTTL); TankTotals:UpdateTotals(); end
			},
			perfight=
			{
				type="toggle", order = 6, name=L["SETTINGS_PERFIGHT"], desc=L["SETTINGS_PERFIGHT_DESC"],
				get=function() return TTPCDB.ArdentPerFight end,
				set=function() TTPCDB.ArdentPerFight = (not TTPCDB.ArdentPerFight); end
			},
			resetstats=
			{
				type="execute", order = 7, name=L["SETTINGS_STATS_RESET"], desc=L["SETTINGS_STATS_RESET_DESC"],
				func = function() WillSaves = 0; WillMitigated = 0; TankTotals:UpdateTotals(); end
			},
		},
	};
end

