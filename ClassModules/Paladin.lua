
local S = TankTotals.S;
local super = TankTotals.SuperClass;
local media = LibStub("LibSharedMedia-3.0");
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

local Paladin = TankTotals:NewModule("Paladin", super, "AceEvent-3.0");

Paladin.CLASS_NAME = "PALADIN";

local ADCD_Bar = nil;
local ArdentSaves = 0;
local ArdentMitigated = 0;

local GlyphOfSoV = false;
local ADMitActive = false;

Paladin.BlockTotal = 0;

-- actual percentage at which AD kicks in
Paladin.AD_THRESHOLD = 0.35;
Paladin.AD_HEALPERCENT = 0.3;

-- timestamp, HP before heal
local ArdentHealData = { 0, nil };

function Paladin:OnEnable()
	self:RegisterBuffs();
	self:EditConfigTable();
	lastHPPC = TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax;

	L["AD_YELL"] = TTPCDB.ArdentText or L["AD_YELL_ORIG"];
	L["AD_HEALYELL"] = TTPCDB.ArdentHealText or L["AD_HEALYELL_ORIG"];

	self:RegisterEvent("UNIT_HEALTH");
	self:RegisterEvent("PLAYER_REGEN_ENABLED");
	self:RegisterEvent("PLAYER_REGEN_DISABLED");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
end

function Paladin:COMBAT_LOG_EVENT_UNFILTERED(eventName, ...)
        -- extract event parameters
	local timeStamp, eventType, sourceGUID, _, _, destGUID, _, _ = select(1, ...);

	if destGUID == UnitGUID("player") then
                -- QuickHealth update
                TankTotals.QH:UpdateQuickHealth(...);

		-- record blocked total this fight
                if eventType == "SWING_DAMAGE" then
                    self.BlockTotal = self.BlockTotal + (select(13, ...) or 0);
                elseif eventType == "SWING_MISSED" and select(9,...) == "BLOCK" then
                    self.BlockTotal = self.BlockTotal + (select(10, ...) or 0);
                end

		-- Ardent Defender monitoring and announce
		-- this is a damage event, player alive but below 35%
		if TankTotals.MitigationBuffs[S["Ardent Defender"]] < 1 and (strfind(eventType, "_DAMAGE") and not strfind(eventType, "DURABILITY_DAMAGE")) then
                        -- if it's not valid damage, return immediately
                        if eventType == "ENVIRONMENTAL_DAMAGE" and not (select(9, ...) == "FIRE" or select(9, ...) == "LAVA" or select(9, ...) == "SLIME") then return; end

                        local pOff = 0; -- parameter offset

                        -- offset +1 if it's environmental, +3 if it's anything else other than a melee swing
                        if eventType == "ENVIRONMENTAL_DAMAGE" then pOff = 1; elseif eventType ~= "SWING_DAMAGE" then pOff = 3; end

                        -- AD doesn't proc on a killing blow, and absorb == 0 => AD = 0
                        if select(10+pOff, ...) > 0 or select(14+pOff,...) == 0 then return; end

                        -- damage, resist, block, absorb (including AD)
                        -- AD absorb is applied AFTER resistance is applied
                        local dmgAmount = select(9+pOff, ...), resist, absorb, block;
                        resist = (select(12+pOff,...) or 0); block = (select(13+pOff,...) or 0); absorb = (select(14+pOff,...) or 0);

                        -- get mitigation amount
                        local adMit, KBA = self:AD_MitigationAmount(dmgAmount, absorb, nil, nil, timeStamp);

                        if (not KBA) then
                            -- add mitigation to running tally
                            ArdentMitigated = ArdentMitigated + adMit;

                            -- AD's mitigation saved us, so add and announce it
                            -- don't announce if it was a KBA; wait for debuff
                            if TankTotals.PlayerQuickHealth <= adMit then
                                    self:AddADSave(L["AD_YELL"]);
                            end
                        end

                        TankTotals:UpdateTotals();
		-- this is an aura gain event
		elseif(eventType == "SPELL_AURA_APPLIED") then
			local spellName = select(10, ...);

			-- if we've gotten the AD debuff, start CD bar
			if spellName == S["Ardent Defender"] then
				self:StartADCDBar();
				self:AddADSave(L["AD_HEALYELL"]);

				TankTotals:UpdateTotals();
			-- Holy Shield, Redoubt and SoV buffs are not time-consistent
			elseif spellName == S["Holy Shield"] or spellName == S["Redoubt"] or (TTDB.ParryHaste and GlyphOfSoV and (spellName == S["Seal of Vengeance"] or spellName == S["Seal of Corruption"])) then
				TankTotals:ScheduleTimer("UpdateTotals", 0.75);
			end
		-- this is an aura loss event
		elseif(eventType == "SPELL_AURA_REMOVED") then
			local spellName = select(10, ...);

			-- Holy Shield, Redoubt and SoV buffs are not time-consistent
			if spellName == S["Holy Shield"] or spellName == S["Redoubt"] or (TTDB.ParryHaste and GlyphOfSoV and (spellName == S["Seal of Vengeance"] or spellName == S["Seal of Corruption"])) then
				TankTotals:ScheduleTimer("UpdateTotals", 0.75);
			-- if the AD debuff is gone, effective HP will change
			elseif spellName == S["Ardent Defender"] then
				if ADCD_Bar and ADCD_Bar.running then ADCD_Bar:Stop(); end

				ADCD_Bar = nil;
				TankTotals:UpdateTotals();
			end
                elseif (eventType == "SPELL_HEAL") and select(10,...) == S["Ardent Defender"] then
                        -- timeStamp, HP before heal
                        ArdentHealData = { select(1,...), TankTotals.PlayerQuickHealth-select(12,...) };
		end
	end
end

function Paladin:PLAYER_REGEN_DISABLED()
        self.BlockTotal = 0;

	if TTPCDB.ArdentPerFight then
		ArdentSaves = 0;
		ArdentMitigated = 0;
	end

        TankTotals:UpdateTotals();
end

function Paladin:PLAYER_REGEN_ENABLED()
	if TTPCDB.ArdentPerFight then
		if ArdentMitigated > 0 then
                        DEFAULT_CHAT_FRAME:AddMessage("");
			TankTotals:Print("|cffffff00["..S["Ardent Defender"].."]|r "..L["PERFIGHT_REPORT"]);
			TankTotals:Print("|cff00ff00"..L["PERFIGHT_MITIGATED"].."|r "..floor(ArdentMitigated));
			TankTotals:Print("|cff00ff00"..L["PERFIGHT_SAVES"].."|r "..ArdentSaves);
                        DEFAULT_CHAT_FRAME:AddMessage("");
		end
	end
end

local lastHPPC = 0; -- last recorded HP percentage

function Paladin:UNIT_HEALTH(eventName, unitID)
	if unitID == "player" then
		local curHPPC = TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax;

		if (lastHPPC <= self.AD_THRESHOLD and curHPPC > self.AD_THRESHOLD) or (lastHPPC > self.AD_THRESHOLD and curHPPC <= self.AD_THRESHOLD) then
			TankTotals:UpdateTotals();
		end

		lastHPPC = curHPPC;
	end
end

function Paladin:ResetValues()
	-- nothing relevant
end

-- register class-specific mitigation buffs
function Paladin:RegisterBuffs()
	TankTotals.SelfCooldowns[S["Divine Protection"]] = L["DP_YELL"];
	TankTotals.SelfCooldowns[S["Divine Guardian"]] = L["DG_YELL"];

	TankTotals.TargettedCDs[S["Lay on Hands"]] = true;
	TankTotals.TargettedCDs[S["Hand of Sacrifice"]] = true;

	TankTotals.MitigationBuffs[S["Righteous Fury"]] = 1.0;		-- correct value obtained from talents
	TankTotals.MitigationBuffs[S["Divine Protection"]] = 0.5;
	TankTotals.MitigationBuffs[S["Divine Shield"]] = 1.0;		-- dummy value to trigger a recalc
	TankTotals.MitigationBuffs[S["Divine Plea"]] = 1.0;		-- gives 3% mitigation if glyph is present
	TankTotals.MitigationBuffs[S["Hand of Salvation"]] = 1.0;	-- gives 20% mitigation if glyph is present
	TankTotals.MitigationBuffs[S["Ardent Defender"]] = 1.0;		-- special case; conditional passive mitigation

	TankTotals.PhysicalMitigationBuffs[S["Hand of Protection"]] = 1.0;	-- dummy value to trigger a recalc
end

function Paladin:GetTalentInfo()
	local nameTalent, icon, tier, column, currRank, maxRank;

	-- righteous fury
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 7);
	TankTotals.MitigationBuffs[S["Righteous Fury"]] = 1 - 0.02 * currRank;

	-- ardent defender
	local adMitFactor = { [0] = 0, [1] = 0.07, [2] = 0.13, [3] = 0.2 };
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 18);
	TankTotals.MitigationBuffs[S["Ardent Defender"]] = 1 - adMitFactor[currRank];

	-- guarded by the light
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 23);
	TankTotals.PassiveSpellMitigation = TankTotals.PassiveSpellMitigation * (1 - currRank * 0.03);

	-- shield of the templar
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(2, 24);
	TankTotals.PassiveMitigation = TankTotals.PassiveMitigation * (1 - currRank * 0.01);

	-- divine purpose: 2/4% chance for spells to miss
	nameTalent, icon, tier, column, currRank, maxRank = GetTalentInfo(3, 16);
	TankTotals.PassiveProbSpellMitigation = TankTotals.PassiveProbSpellMitigation * (1 - currRank * 0.02);
end

function Paladin:CheckSetBonuses()
	-- no relevant bonuses
	return false;
end

function Paladin:CheckEnchantsAndGlyphs()
	-- Glyphs of Divine Plea & Salvation
	if TankTotals:IsGlyphActive(S["Glyph of Divine Plea"]) then
		TankTotals.MitigationBuffs[S["Divine Plea"]] = 0.97;
	else
		TankTotals.MitigationBuffs[S["Divine Plea"]] = 1.0;
	end

	GlyphOfSoV = TankTotals:IsGlyphActive(S["Glyph of Seal of Vengeance"]);

	if TankTotals:IsGlyphActive(S["Glyph of Salvation"]) then
		TankTotals.MitigationBuffs[S["Hand of Salvation"]] = 0.8;
		TankTotals.SelfCooldowns[S["Hand of Salvation"]] = L["HSALV_YELL"];
	else
		TankTotals.MitigationBuffs[S["Hand of Salvation"]] = 1.0;
		TankTotals.SelfCooldowns[S["Hand of Salvation"]] = nil;
	end
end

-- return { universalMit, physMit, spellMit, probSpellMit }
function Paladin:GetSpecialMitigation()
	local specialMit = { 1.0, 1.0, 1.0, 1.0 };

	-- divine shield gives 100% mitigation
	if(UnitBuff("player", S["Divine Shield"]) ~= nil) then
		specialMit[1] = 0;
	elseif not UnitIsDeadOrGhost("player") then
		-- ardent defender is passive but only below 35% health
		if TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax <= self.AD_THRESHOLD then
			specialMit[1] = specialMit[1] * TankTotals.MitigationBuffs[S["Ardent Defender"]];
		end
	end

        -- explicitly track whether AD mitigation is active. This is used later in Unmitigate.
        ADMitActive = (not UnitIsDeadOrGhost("player")) and (TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax <= self.AD_THRESHOLD);

	return specialMit;
end

-- returns flat mitigation as % damage after reduction
function Paladin:GetFlatMitigationDR()
	if TTPCDB.MobHitAmount > 0 then
		-- (BV as % of post-mitigated hit) * (% of hits that are blocked)
		return 1 - (min(1, GetShieldBlock() / (TTPCDB.MobHitAmount * TankTotals.FinalMitigation[TankTotals.INDEX_MELEE])) * min(1, GetBlockChance() / (100 - TankTotals.Avoidance)));
	end

	return 1.0;
end

-- returns effective HP, or nil for infinite health
function Paladin:GetEffectiveHealth()
	if TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] == 0 then
		return nil;
	end

	local effHealth = 0;

	if TankTotals.MitigationBuffs[S["Ardent Defender"]] < 1 then
		local meleeMitNoAD = TankTotals.FinalMitigation[TankTotals.INDEX_MELEE];

		-- if player is below 35% hp, AD will already have been applied to mitigation values
		if (TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax) <= self.AD_THRESHOLD then meleeMitNoAD = meleeMitNoAD / TankTotals.MitigationBuffs[S["Ardent Defender"]]; end

                -- effective health is (standard EH)*(AD multiplication factor)
		effHealth = (TankTotals.PlayerQuickHealthMax / meleeMitNoAD) * self:GetADEHFactor();
	else
		effHealth = TankTotals.PlayerQuickHealthMax / TankTotals.FinalMitigation[TankTotals.INDEX_MELEE];
	end

	return effHealth;
end

-- EH2, i.e. EH calculated using relative percentage damage sources
-- returns expected mitigation, EH2 (former for convenience)
function Paladin:GetNEH()
        local neh = 0.0;
        local wMit = TankTotals:GetWeightedMitigation();

        if wMit == 0 then return wMit, nil; end

	if TankTotals.MitigationBuffs[S["Ardent Defender"]] < 1 then
		-- if player is below 35% hp, AD will already have been applied to mitigation values
		if (TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax) <= self.AD_THRESHOLD then wMit = wMit / TankTotals.MitigationBuffs[S["Ardent Defender"]]; end

                -- effective health is (standard NEH)*(AD multiplication factor)
		neh = (TankTotals.PlayerQuickHealthMax / wMit) * self:GetADEHFactor();
	else
		neh = TankTotals.PlayerQuickHealthMax / wMit;
	end

        return wMit, neh;
end

-- if AD is specced, return the additional EH it represents
function Paladin:GetADEHFactor()
        local adHealEH = 0.0;

        -- AD's heal adds extra effective HP; heal amount is dependent upon defense rating
        if TTPCDB.ArdentEHTTL and (not UnitDebuff("player", S["Ardent Defender"])) then adHealEH = self.AD_HEALPERCENT * min(1, GetCombatRating(CR_DEFENSE_SKILL)/689); end

        return 1 + ((self.AD_THRESHOLD + adHealEH) / TankTotals.MitigationBuffs[S["Ardent Defender"]]) - self.AD_THRESHOLD;
end

function Paladin:GetFlatMitigationInfo()
	-- block value
	return L["PALA_FLATMIT"], GetShieldBlock();
end

-- Wrapper for generic Unmitigate. Adds class-specific features.
-- The includeAD parameter indicates whether to include mitigation from
-- Ardent Defender. This can be used to avoid double-unmitigation, since
-- AD mitigation shows up in the combat log as absorbs.
function Paladin:Unmitigate(dmg, school, resist, block, absorb, timeStamp, includeAD)
        -- get generic unmitigated damage
        local unmitDmg, probResist = super.Unmitigate(self, dmg, school, resist, block, absorb);

        -- if conditions evaluate true, then the input damage already includes AD...
        if (not includeAD) and ADMitActive then
            -- ... but has also been un-mitigated by AD. We need to reduce it accordingly.
            unmitDmg = unmitDmg * TankTotals.MitigationBuffs[S["Ardent Defender"]];
        end

        -- find the amount of damage absorbed by AD
        local adAbsorb, KBA = self:AD_MitigationAmount(dmg, absorb, nil, nil, timeStamp);

        -- return results
        return unmitDmg, probResist, max(0, absorb - adAbsorb), adAbsorb, KBA;
end

-- Calculates the mitigation provided by AD given damage and absorb.
-- Can be supplied with arbitrary values of current and max HP.
-- Defaults to the player's current values of both if omitted.
-- If a timeStamp is specified, the function attempts to ascertain
-- whether the event represents a killing blow stopped by AD
-- returns a boolean as the second value indicating whether or
-- not the event was a killing-blow absorb
function Paladin:AD_MitigationAmount(damage, absorb, hp, maxHP, timeStamp)
        -- no absorb implies no AD
        if (not absorb) or absorb == 0 then return 0, false; end

        -- init params if needed
        hp = (hp or TankTotals.PlayerQuickHealth);
        maxHP = (maxHP or TankTotals.PlayerQuickHealthMax);

        -- killing blow absorbed from above 30%; absorbs only the amount needed
        if absorb >= (maxHP*self.AD_HEALPERCENT) and abs(hp - (maxHP*self.AD_HEALPERCENT)) < 2 then
                return absorb, true;
        -- absorbed killing blow; either heal-before-absorb or absorb-before-heal
        -- heal and debuff are applied simultaneously, so if it's absorb-before-heal then the debuff won't be present
        elseif timeStamp and damage == 0 and absorb >= ((timeStamp - ArdentHealData[1] <= 1 and ArdentHealData[2]) or ((not UnitDebuff("player", S["Ardent Defender"])) and hp) or (absorb+1)) then
                return absorb, true;
        -- see what HP we were at before the damage was taken
        elseif (hp + damage) / maxHP <= self.AD_THRESHOLD then
                -- we were below 35% already; all damage is mitigated
                -- (damage + absorb) is the damage remaining after resistance
                return (damage + absorb) * (1-TankTotals.MitigationBuffs[S["Ardent Defender"]]), false;
        elseif hp/maxHP <= self.AD_THRESHOLD then
                -- damage crossed 35% threshold; portion below 35% is mitigated, rest is not
                -- ([(HPmax*0.35)-HPccurrent] + absorb) is the damage >>below 35%<< remaining after resistance
                return ((maxHP * self.AD_THRESHOLD) - hp + absorb) * (1-TankTotals.MitigationBuffs[S["Ardent Defender"]]), false;
        end

        return 0, false;
end

function Paladin:AddADSave(adAnnounceText)
	ArdentSaves = ArdentSaves + 1;

	if TTPCDB.ArdentPerFight then
		TankTotals:Print("|cffffff00["..S["Ardent Defender"].."]|r "..L["SAVE_MSG1"].."|r");
	else
		TankTotals:Print("|cffffff00["..S["Ardent Defender"].."]|r "..L["SAVE_MSG1"].." |cff00ff00"..L["SAVE_MSG2"].." "..ArdentSaves.."|r");
	end

	if TTPCDB.ArdentAnnounce and UnitBuff("player", S["Guardian Spirit"]) == nil then
		TankTotals:Announce((adAnnounceText or L["AD_YELL"]), true);
	end
end

function Paladin:IsSingleTargetTaunt(spellID)
	return (GetSpellInfo(spellID) == S["Hand of Reckoning"]);
end

function Paladin:IsAoETaunt(spellID)
	return (GetSpellInfo(spellID) == S["Righteous Defense"]);
end

function Paladin:TankingStanceActive()
	return (UnitBuff("player", S["Righteous Fury"]) ~= nil) or (self:GetCurrentStance() == S["Righteous Fury"]);
end

function Paladin:StartADCDBar()
	if not (TTPCDB.ArdentCD and TTPCDB.ShowSummary) then return; end

	ADCD_Bar = LibStub("LibCandyBar-3.0"):New(media:Fetch("statusbar", TTPCDB.ArdentTexture), 100, 16);
	ADCD_Bar:AddUpdateFunction(function(bar) local name, _, _, _, _, _, expirationTime =  UnitDebuff("player", S["Ardent Defender"]); if name then bar.exp = expirationTime; end if ADCD_Bar.TTGrowDir ~= TTPCDB.GrowDir then self:SetADCDBarPos(bar); end end);

	ADCD_Bar.candyBarLabel:SetJustifyH("LEFT");
	ADCD_Bar.candyBarLabel:SetJustifyV("MIDDLE");
	ADCD_Bar.candyBarLabel:SetFont(media:Fetch("font", TTDB.Font), 10);

	ADCD_Bar.candyBarDuration:SetJustifyH("RIGHT");
	ADCD_Bar.candyBarDuration:SetJustifyV("MIDDLE");
	ADCD_Bar.candyBarDuration:SetFont(media:Fetch("font", TTDB.Font), 10);

	local _, _, icon = GetSpellInfo(31852);

	ADCD_Bar:SetIcon(icon);
	ADCD_Bar:SetColor(1.0, 0.0, 0.0, 1.0);
	ADCD_Bar:SetLabel(S["Ardent Defender"]);

	self:SetADCDBarPos(ADCD_Bar);

	ADCD_Bar:SetWidth((TankTotals.LEFT.frame:GetWidth() + TankTotals.RIGHT.frame:GetWidth()) * TTPCDB.WindowScale);
	ADCD_Bar:SetDuration(120);
	ADCD_Bar:Start();
end

function Paladin:SetADCDBarPos(adBar)
	adBar:ClearAllPoints();
	adBar.TTGrowDir = TTPCDB.GrowDir;
	adBar:SetPoint(TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][1], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"].frame(), TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][3], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][4], TankTotals.GrowOpts[TTPCDB.GrowDir]["ADCD"][5]);
end

function Paladin:AddCustomDisplayText(recipient)
	if TankTotals.MitigationBuffs[S["Ardent Defender"]] < 1 then
                recipient:AddLine("", "");

                local leftText, rightText;
                local textColor = ((TankTotals.PlayerQuickHealth / TankTotals.PlayerQuickHealthMax > self.AD_THRESHOLD and "|cff00ff00") or "|cffff0000");

                -- AD threshold
                leftText = "|cffffff00"..L["AD_ACTIVE_HEADING"].."|r";
                rightText = textColor..round(TankTotals.PlayerQuickHealthMax * self.AD_THRESHOLD).."|r";

                recipient:AddLine(leftText, rightText);

                -- AD mitigation and the number of saves
		recipient:AddLine("|cffffff00"..L["AD_TOTAL_HEADING"].."|r", "|cff00ff00"..ttvFormat(ArdentMitigated / 1000, 2).."k ("..ArdentSaves..")|r");
	end
end

function Paladin:EditConfigTable()
	TankTotals.ConfigTable.args.Announce.args.aoetauntmisses=
	{
		type="toggle", order = 3, name=L["SETTINGS_SPECIALTAUNT"], desc=L["SETTINGS_SPECIALTAUNT_DESC"],
		get=function() return TTPCDB.SpecialTaunts end,
		set=function() TTPCDB.SpecialTaunts = (not TTPCDB.SpecialTaunts); end
	};

	TankTotals.ConfigTable.args.Damage.args.stoponAD=
	{
		type="toggle", order = 3, name=L["SETTINGS_AD_STOP_NEHREC"], desc=L["SETTINGS_AD_STOP_NEHREC_DESC"],
		get=function() return TTPCDB.StopNEHOnAD end,
		set=function() TTPCDB.StopNEHOnAD = (not TTPCDB.StopNEHOnAD); end
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
			announceAD=
			{
				type="toggle", order = 1, name=L["SETTINGS_AD_ANNOUNCE"], desc=L["SETTINGS_AD_ANNOUNCE_DESC"],
				get=function() return TTPCDB.ArdentAnnounce end,
				set=function() TTPCDB.ArdentAnnounce = (not TTPCDB.ArdentAnnounce); end
			},
			announceADText=
			{
				type="input", order = 2, name="", desc=L["SETTINGS_AD_TEXT_DESC"],
				get=function() return TTPCDB.ArdentText or L["AD_YELL_ORIG"]; end,
				set=function(info, x) if x == "" then x = L["AD_YELL_ORIG"]; end TTPCDB.ArdentText = x; L["AD_YELL"] = x; end
			},
			announceADHeal=
			{
				type="toggle", order = 3, name=L["SETTINGS_AD_ANNOUNCEHEAL"], desc=L["SETTINGS_AD_ANNOUNCEHEAL_DESC"],
				get=function() return TTPCDB.ArdentHealAnnounce end,
				set=function() TTPCDB.ArdentHealAnnounce = (not TTPCDB.ArdentHealAnnounce); end
			},
			announceADHealText=
			{
				type="input", order = 4, name="", desc=L["SETTINGS_AD_HEALTEXT_DESC"],
				get=function() return TTPCDB.ArdentHealText or L["AD_HEALYELL_ORIG"]; end,
				set=function(info, x) if x == "" then x = L["AD_HEALYELL_ORIG"]; end TTPCDB.ArdentHealText = x; L["AD_HEALYELL"] = x; end
			},
			showADCD=
			{
				type="toggle", order = 5, name=L["SETTINGS_AD_CDBAR"], desc=L["SETTINGS_AD_CDBAR_DESC"],
				get=function() return TTPCDB.ArdentCD end,
				set=function() TTPCDB.ArdentCD = (not TTPCDB.ArdentCD); end
			},
			adBarTexture=
			{
				type="select", order = 6, dialogControl = "LSM30_Statusbar", name=L["SETTINGS_CDBAR_TEXTURE"], desc=L["SETTINGS_CDBAR_TEXTURE_DESC"],
				values = AceGUIWidgetLSMlists.statusbar,
				get =	function(info) return TTPCDB.ArdentTexture; end,
				set =	function(info, tex) TTPCDB.ArdentTexture = tex; if ADCD_Bar then ADCD_Bar:SetTexture(media:Fetch("statusbar", TTPCDB.ArdentTexture)); end end
			},
			adEHTTL=
			{
				type="toggle", order = 7, name=L["SETTINGS_ADHEAL_EHTTL"], desc=L["SETTINGS_ADHEAL_EHTTL_DESC"],
				get=function() return TTPCDB.ArdentEHTTL end,
				set=function() TTPCDB.ArdentEHTTL = (not TTPCDB.ArdentEHTTL); TankTotals:UpdateTotals(); end
			},
			perfight=
			{
				type="toggle", order = 8, name=L["SETTINGS_PERFIGHT"], desc=L["SETTINGS_PERFIGHT_DESC"],
				get=function() return TTPCDB.ArdentPerFight end,
				set=function() TTPCDB.ArdentPerFight = (not TTPCDB.ArdentPerFight); end
			},
			resetstats=
			{
				type="execute", order = 9, name=L["SETTINGS_STATS_RESET"], desc=L["SETTINGS_STATS_RESET_DESC"],
				func = function() ArdentSaves = 0; ArdentMitigated = 0; TankTotals:UpdateTotals(); end
			},
		},
	};
end


