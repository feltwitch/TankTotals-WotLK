
local S = TankTotals.S;
local media = LibStub("LibSharedMedia-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

-- stub to control enabling/disabling TankTotals on spec change,
-- and changes in mitigation talents and/or buffs when respeccing
local TankTotalsStub = LibStub("AceAddon-3.0"):NewAddon("TankTotalsSpecChangeStub", "AceEvent-3.0");

function TankTotals:OnInitialize()
	local playerClass, englishClass = UnitClass("player");

        -- if this is not a tanking class, disable the addon immediately
	if not (englishClass == "PALADIN" or englishClass == "WARRIOR" or englishClass == "DEATHKNIGHT" or englishClass == "DRUID") then
            self:Print("|cffffff00"..L["NONTANK_MSG"].."|r");
            self:SetEnabledState(false);
            return;
	end

        self:InitSettings();
        self:RegisterConfigTable();

        -- enable spec-change stub
        TankTotalsStub:Enable();
end

function TankTotals:OnEnable()
	-- if talents etc are not yet available, delay
	if GetNumSkillLines() == 0 then
		self:ScheduleTimer("OnEnable", 1.5);
		return;
	end

        self:SetupUI();

        if TTPCDB.AddonActive then
            self:SetClassModule();
            self:FindMitigators();

            self:RegisterEvent("UNIT_MAXHEALTH");
            self:RegisterEvent("PLAYER_ENTERING_WORLD");
            self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateTotals");

            self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
            self:RegisterEvent("COMBAT_RATING_UPDATE", "UpdateTotals");

            self:RegisterEvent("UNIT_STATS");
            self:RegisterEvent("UNIT_RESISTANCES");
            self:RegisterEvent("UNIT_INVENTORY_CHANGED");
            self:RegisterEvent("SOCKET_INFO_UPDATE", "UNIT_INVENTORY_CHANGED");

            -- let the spec change stub handle this; see end of TankTotals.lua
--          self:RegisterEvent("PLAYER_TALENT_UPDATE", function() if self.ActiveSpec ~= GetActiveTalentGroup(false, false) then self:FindMitigators(); end end);
--          self:RegisterEvent("CHARACTER_POINTS_CHANGED", function() if self.ActiveSpec == GetActiveTalentGroup(false, false) then self:FindMitigators(); end end);

            self:RegisterEvent("GLYPH_ADDED", function() self.ClassModule:CheckEnchantsAndGlyphs(); self:UpdateTotals(); end);
            self:RegisterEvent("GLYPH_REMOVED", function() self.ClassModule:CheckEnchantsAndGlyphs(); self:UpdateTotals(); end);

            self.NEH = self:GetModule("NEH");
            if TTPCDB.RecordNEHXY then self.NEH:Enable(); end

            self.QH = self:GetModule("QuickHealth");
            self.QH:Enable();
        else
            self:Disable();
        end
end

function TankTotals:OnDisable()
        self.LDB.text = "|cffff0000"..L["ADDON_DISABLED"].."|r";
        self:SetShown(false);
end

function TankTotals:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
        local eventType, sourceGUID, _, _, destGUID, destName, _ = select(2, ...);

        -- perform event checks common to all classes. If the event does
        -- not match any of these, leave it to the specific class module.
        if destGUID == UnitGUID("player") then
                -- QuickHealth update
                self.QH:UpdateQuickHealth(...);

                if(eventType == "SPELL_AURA_APPLIED") and select(12, ...) == "BUFF" then
                        local spellID, spellName = select(9, ...);

                        -- check for HoP and remove if present
                        if(TTPCDB.HoP_B_Gone and spellName == S["Hand of Protection"]) then
                                CancelUnitBuff("player", S["Hand of Protection"]);
                        -- divine sacrifice only gives mitigation if it's not you that cast it
                        elseif(spellName == S["Divine Sacrifice"] and sourceGUID ~= UnitGUID("player")) then
                                self.PassiveMitigation = self.PassiveMitigation * 0.7;
                        -- cooldown announcements
                        elseif TTPCDB.CooldownAnnounce and sourceGUID == UnitGUID("player") and self.SelfCooldowns[spellName] ~= nil then
                                self:Announce(self.SelfCooldowns[spellName].. L["CD_ACTIVE"], 0, 1, 0);
                        end

                        self:SPELL_AURA_APPLIED(spellName);

                elseif(eventType == "SPELL_AURA_REMOVED") and select(12, ...) == "BUFF" then
                        local spellID, spellName = select(9, ...);

                        -- cooldown such as shield wall has faded
                        if TTPCDB.CooldownAnnounce and sourceGUID == UnitGUID("player") and self.SelfCooldowns[spellName] ~= nil then
                                self:Announce(self.SelfCooldowns[spellName].. L["CD_FADED"]);
                        elseif(spellName == S["Divine Sacrifice"] and sourceGUID ~= UnitGUID("player")) then
                                self.PassiveMitigation = self.PassiveMitigation / 0.7;
                        end

                        self:SPELL_AURA_REMOVED(spellName);
                end
        elseif sourceGUID == UnitGUID("player") and eventType == "SPELL_MISSED" then
                local spellID, spellName, _, missType = select(9, ...);

                if self.ClassModule:IsTaunt(spellID) then
                        if TTPCDB.TauntMissAnnounce and (TTPCDB.SpecialTaunts or self.ClassModule:IsSingleTargetTaunt(spellID)) then
                                if missType == "IMMUNE" then
                                        self:Announce(L["TAUNT_IMMUNE"]..destName.."!");
                                else
                                        self:Announce(L["TAUNT_MISSED"]..destName.."! ("..spellName..")");
                                end
                        end

                        -- play an alert sound if the option is enabled
                        if TTDB.TauntMissSound and TTDB.TauntMissSound ~= "None" then PlaySoundFile(media:Fetch("sound", TTDB.TauntMissSound)); end
                end
        elseif destGUID == UnitGUID("target") then
                if (eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REMOVED") and select(12, ...) == "DEBUFF" then
                        if self:IsMeleeSlowDebuff(select(10, ...)) then
                                -- attack speed effect is not time-consistent, so delay
                                self:ScheduleTimer("UpdateTotals", 0.75);
                        end
                end
        end

        -- targetted CDs; Sacrifice, LoH, etc
        if(TTPCDB.CooldownAnnounce and sourceGUID == UnitGUID("player") and eventType == "SPELL_CAST_SUCCESS") then
                local spellName = select(10, ...);

                if self.TargettedCDs[spellName] then
                        self:Announce(strupper(spellName).. L["CD_ONTARGET"]..destName.."!", 0, 1, 0);
                end
        end
end

function TankTotals:PLAYER_ENTERING_WORLD()
    -- entering an instance causes values e.g. block to go to 0
    -- schedule an update to correct the display after zoning
    -- updates via UNIT_RESISTANCES because auras persist
    -- through death, and the buff is gained mid-zonein
    self:ScheduleTimer("UNIT_RESISTANCES", 1.5, nil);
end

function TankTotals:UNIT_MAXHEALTH(eventName, unitID)
    if unitID == "player" then self:UpdateTotals(); end
end

function TankTotals:UNIT_STATS(eventName, unitID)
    if unitID == "player" then self:UpdateTotals(); end
end

function TankTotals:SPELL_AURA_APPLIED(spellName)
    if self.MitigationBuffs[spellName] or self.SpellMitigationBuffs[spellName] or self.PhysicalMitigationBuffs[spellName] then
        self.MitigationFromBuffs = self.MitigationFromBuffs * (self.MitigationBuffs[spellName] or 1.0);
        self.SpellMitigationFromBuffs = self.SpellMitigationFromBuffs * (self.SpellMitigationBuffs[spellName] or 1.0);
        self.PhysicalMitigationFromBuffs = self.PhysicalMitigationFromBuffs * (self.PhysicalMitigationBuffs[spellName] or 1.0);

        self:UpdateTotals();
    end
end

function TankTotals:SPELL_AURA_REMOVED(spellName)
    if self.MitigationBuffs[spellName] or self.SpellMitigationBuffs[spellName] or self.PhysicalMitigationBuffs[spellName] then
        self.MitigationFromBuffs = self.MitigationFromBuffs / (self.MitigationBuffs[spellName] or 1.0);
        self.SpellMitigationFromBuffs = self.SpellMitigationFromBuffs / (self.SpellMitigationBuffs[spellName] or 1.0);
        self.PhysicalMitigationFromBuffs = self.PhysicalMitigationFromBuffs / (self.PhysicalMitigationBuffs[spellName] or 1.0);

        self:UpdateTotals();
    end
end

function TankTotals:UNIT_RESISTANCES(eventName, unitID)
    -- eventName == nil implies calling of function via ScheduleTimer
    if (not eventName) or unitID == "player" then
        -- calculate min/avg spell mitigation from resistances
        -- get minimum and average resistance values, 0 <= x <= 1
        for resIndex = 1, 6 do
                _, curRes, _, _ = UnitResistance("player", resIndex);
                self.MinResistances[2^resIndex], self.AvgResistances[2^resIndex] = self:GetResistanceMinAvg(curRes);
        end

        self:UpdateMixedResistances();
        self:UpdateTotals();
    end
end

-- effulgent skyflare diamond gives 2% spell mitigation
function TankTotals:UNIT_INVENTORY_CHANGED(eventName, unitID)
    local updateNeeded = false;

    -- ClassModule:CheckSetBonuses returns true if update needed
    if eventName == "UNIT_INVENTORY_CHANGED" and unitID == "player" then
        updateNeeded = self.ClassModule:CheckSetBonuses();
    end

    if eventName == "SOCKET_INFO_UPDATE" or unitID == "player" then
	if self:CheckGemOrEnchant("HeadSlot", 3634) then
            if self.ESFD == 1.0 then self.ESFD = 0.98; updateNeeded = true; end
        else
            if self.ESFD < 1.0 then self.ESFD = 1.0; updateNeeded = true; end
        end
    end

    if updateNeeded then
        self:UpdateTotals();
    end
end

-- composite function which finds all categories of
-- general and spell mitigation
function TankTotals:FindMitigators()
        self:ResetValues();

	self.ActiveSpec = GetActiveTalentGroup(false, false);
        if self:CheckGemOrEnchant("HeadSlot", 3634) then self.ESFD = 0.98 else self.ESFD = 1.0; end

	self:CheckRace();

	self.ClassModule:GetTalentInfo();
	self.ClassModule:CheckSetBonuses();
	self.ClassModule:CheckEnchantsAndGlyphs();

        self:CheckAllBuffs();
end

function TankTotals:SetClassModule()
	playerClass, englishClass = UnitClass("player");

	if englishClass == "PALADIN" then
		self.ClassModule = self:GetModule("Paladin");
	elseif englishClass == "WARRIOR" then
		self.ClassModule = self:GetModule("Warrior");
	elseif englishClass == "DEATHKNIGHT" then
		self.ClassModule = self:GetModule("DeathKnight");
	elseif englishClass == "DRUID" then
		self.ClassModule = self:GetModule("Druid");
	end

        self.ClassModule:Enable();
end

function TankTotals:CheckRace()
	race, englishRace = UnitRace("player");

	-- holy, fire, nature, frost, shadow, arcane
	if englishRace == "NightElf" then
		self.NonDRMiss = 7;	-- 2% bonus miss
		self.RacialResistances[3] = 0.98;	-- 2% nature resist
	elseif englishRace == "Gnome" then
		self.RacialResistances[6] = 0.98;	-- 2% arcane resist
	elseif englishRace == "Dwarf" then
		self.RacialResistances[4] = 0.98;	-- 2% frost resist
	elseif englishRace == "Tauren" then
		self.RacialResistances[3] = 0.98;	-- 2% nature resist
	elseif englishRace == "Draeni" then
		self.RacialResistances[5] = 0.98;	-- 2% shadow resist
	elseif englishRace == "Undead" then
		self.RacialResistances[5] = 0.98;	-- 2% shadow resist
	elseif englishRace == "BloodElf" then
		self.PassiveProbSpellMitigation = 0.98; -- 2% all resist
	end
end

function TankTotals:UpdateTotals()
	if TTPCDB.AddonActive then
            local _, effectiveArmor, _, _, _ = UnitArmor("player");

            self.BlockChance = max(0, GetBlockChance() - (0.2 * TTDB.EnemyLevelDiff));
            self.Avoidance = self.NonDRMiss - (0.6 * TTDB.EnemyLevelDiff) + GetDodgeChance() + self.ClassModule:GetMissParryChance();

            self.BlockCap = self.Avoidance + self.BlockChance;

            -- call class module for effects euch as Spell Deflection and Ardent Defender
            -- return { universalMit, physMit, spellMit, probSpellMit }
            local specialMit = self.ClassModule:GetSpecialMitigation();
            specialMit[3] = specialMit[3] * self.ESFD; -- account for Effulgent Skyflare Diamond

            local universalMitigation = specialMit[1] * self.PassiveMitigation * self.MitigationFromBuffs;

            self.GuaranteedSpellMitigation = specialMit[3] * universalMitigation * self.PassiveSpellMitigation * self.SpellMitigationFromBuffs;
            self.ProbSpellMitigation = specialMit[4] * self.GuaranteedSpellMitigation * self.PassiveProbSpellMitigation * self.ProbSpellMitigationFromBuffs;

            -- calculate total physical mitigation (armor * universal mitigation talents/buffs * physical mitigation buffs)
            -- separate armor mitigation from this, since it does not affect specific physical effects (i.e. bleed damage)
            -- hand of protection gives 100% physical mitigation
            if(UnitBuff("player", S["Hand of Protection"]) ~= nil) then
                    self.ArmorMitigation = 0.0;
                    self.PhysicalMitigation = 0.0;
            else
                    self.ArmorMitigation = 1 - effectiveArmor / (effectiveArmor + (467.5 * (80 + TTDB.EnemyLevelDiff) - 22167.5));
                    self.PhysicalMitigation = specialMit[2] * universalMitigation * self.PassivePhysicalMitigation * self.PhysicalMitigationFromBuffs;
            end

            -- melee and bleed mitigation
            self.FinalMitigation[self.INDEX_BLEED] = self.PhysicalMitigation;
            self.FinalMitigation[self.INDEX_MELEE] = self.ArmorMitigation * self.PhysicalMitigation;

            for resIndex, _ in pairs(self.MinResistances) do  -- compute overall minimum and average per-school spell mitigation
                    self.FinalMitigation[resIndex] = self.MinResistances[resIndex] * self.GuaranteedSpellMitigation;
                    self.AverageSpellMitigation[resIndex] = self.AvgResistances[resIndex] * self.ProbSpellMitigation * self.RacialResistances[resIndex];
            end

            self.FinalMitigation[self.INDEX_UNRESISTIBLE] = self.GuaranteedSpellMitigation;

            self:UpdateDisplayText();
	end
end

function TankTotals:CheckAllBuffs()
        local currentStance = self.ClassModule:GetCurrentStance();

	-- universal mitigation buffs (physical and spell)
	for bKey, bValue in pairs(self.MitigationBuffs) do
		if(UnitBuff("player", bKey) ~= nil or bKey == currentStance) then
			self.MitigationFromBuffs = self.MitigationFromBuffs * bValue;
		end
	end

	-- physical mitigation buffs (physical only)
        -- omit previous self.MitigationBuffs[bKey] == nil check for e.g. Imp Defensive Stance
	for bKey, bValue in pairs(self.PhysicalMitigationBuffs) do
		if (UnitBuff("player", bKey) ~= nil or bKey == currentStance) then
			self.PhysicalMitigationFromBuffs = self.PhysicalMitigationFromBuffs * bValue;
		end
	end

	-- spell mitigation buffs
	for bKey, bValue in pairs(self.SpellMitigationBuffs) do
		if (UnitBuff("player", bKey) ~= nil or bKey == currentStance) then
			self.SpellMitigationFromBuffs = self.SpellMitigationFromBuffs * bValue;
		end
	end

        -- check resistances
        self:UNIT_RESISTANCES("UNIT_RESISTANCES", "player");
end

function TankTotals:ResetValues()
        self.ESFD = 1.0;
	self.NonDRMiss = 5;

        -- mitigation due to stance/buffs/etc.
        self.PassiveMitigation = 1.0;	-- shield of the templar, etc
        self.MitigationFromBuffs = 1.0;	-- righteous fury, etc

        self.PassivePhysicalMitigation = 1.0;   -- nothing yet
        self.PhysicalMitigationFromBuffs = 1.0;   -- DK t8 4-set, post-3.2 Imp LoH, etc

        self.PassiveSpellMitigation = 1.0;	-- guarded by the light, etc
        self.SpellMitigationFromBuffs = 1.0;	-- improved defensive stance, etc

        self.PassiveProbSpellMitigation = 1.0;	-- divine purpose, improved spell reflection, etc
        self.ProbSpellMitigationFromBuffs = 1.0;	-- spell deflection is a bitch

        self.ProbSpellMitigation = 1.0;	        -- general mitigation * guaranteed spell mitigation * prob spell mitigation
        self.GuaranteedSpellMitigation = 1.0;	-- general mitigation * guaranteed spell mitigation

        self.ClassModule:ResetValues();
end

------------------------------------------------------------------------------------------------------------

-- start disabled
TankTotalsStub:SetEnabledState(false);

-- register for spec/talent change events
function TankTotalsStub:OnEnable()
        self:RegisterEvent("PLAYER_TALENT_UPDATE");
        self:RegisterEvent("CHARACTER_POINTS_CHANGED", "PLAYER_TALENT_UPDATE");
end

-- spec changed, or points were changed in current spec
function TankTotalsStub:PLAYER_TALENT_UPDATE(eventName)
        -- get the current active spec
        local currentSpec = GetActiveTalentGroup(false, false);

        -- spec changed
        if TankTotals.ActiveSpec ~= currentSpec then
            if (not TTPCDB.ActiveInSpec[currentSpec]) and TankTotals:IsEnabled() then
                TankTotals:Print(L["SPEC_DISABLED"]);
                TankTotals.ActiveSpec = currentSpec;
                TTPCDB.AddonActive = false;
                TankTotals:Disable();
            elseif TTPCDB.ActiveInSpec[currentSpec] and (not TankTotals:IsEnabled()) then
                TankTotals:Print(L["SPEC_ENABLED"]);
                TTPCDB.AddonActive = true;
                TankTotals:Enable();
            elseif TankTotals.ActiveSpec ~= 0 then
                -- both specs enabled
                TankTotals:FindMitigators();
            end
        -- points changed in current spec
        elseif eventName == "CHARACTER_POINTS_CHANGED" and TankTotals:IsEnabled() then
            TankTotals:FindMitigators();
        end
end

