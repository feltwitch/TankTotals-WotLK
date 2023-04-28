
-- cross-class module prototype table
-- defines common fields and functions
TankTotals.SuperClass =
{
    MISS_CAP = 16,
    K_MISS = 0.956,
    ParryableGCDs = 0.8, -- percentage of the class' GCD abilities that can trigger a parry
    ShowBlockInfo = true,

    GetMissParryChance =
        function(self)
            -- simply returns sum of the two
            return GetParryChance() + self:GetMissAfterDR();
        end,

    GetMissAfterDR=
        function(self)
                -- miss from defense is x' = 1/(1/c + k/x), 1/c = 1/16 = 0.0625, k = 0.956, k = 0.972 for druids
                return 1/(1/self.MISS_CAP + self.K_MISS/(floor(GetCombatRating(CR_DEFENSE_SKILL)/TankTotals.DEF_RATING_PER_SKILL) * TankTotals.MISS_PER_DEF_SKILL));
        end,

    -- returns total physical DR, including avoidance and flat mitigation
    GetTotalPhysicalDR =
        function(self)
            return TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] * self:GetFlatMitigationDR() * (1 - (TankTotals.Avoidance/100));
        end,

    -- returns effective HP, or nil for infinite health
    GetEffectiveHealth =
        function(self)
            if TankTotals.FinalMitigation[TankTotals.INDEX_MELEE] == 0 then
                    return nil;
            else
                    return TankTotals.PlayerQuickHealthMax / TankTotals.FinalMitigation[TankTotals.INDEX_MELEE];
            end
        end,

    -- EH2, i.e. EH calculated using relative percentage damage sources
    -- returns expected mitigation, EH2 (former for convenience)
    -- cannot account for WOTN, since we do not know the magnitude
    -- of incoming damage; only their relative proportions
    GetNEH =
        function(self)
            local wMit = TankTotals:GetWeightedMitigation();
    
            if wMit == 0 then
                return wMit, nil;
            else
                return wMit, TankTotals.PlayerQuickHealthMax / wMit;
            end
        end,

    -- returns expected HP including avoidance and flat mitigation, or nil for infinite health
    -- also returns effective health for convenience, since it's calculated in the process anyway
    GetExpectedHealth =
        function(self, effHealth)
            effHealth = (effHealth or self:GetEffectiveHealth());
            local extraDR = self:GetFlatMitigationDR() * (1 - (TankTotals.Avoidance/100));

            -- return [ expected HP, effective HP ]
            if effHealth == nil or extraDR == 0 then
                    return nil, effHealth;
            else
                    return (effHealth / extraDR), effHealth;
            end
        end,

    -- returns expected time-to-live, or nil for infinite time
    -- avoidance has already been treated as mitigation, don't use it to modify the swing timer
    GetExpectedTTL=
        function(self, expHealth, parryHasteEffect)
            if TTPCDB.MobHitAmount > 0 then
                    local enemyMH, enemyOH = UnitAttackSpeed("target");
                    expHealth = (expHealth or self:GetExpectedHealth());

                    -- assume 2.4 if no target
                    if enemyMH == 0 then enemyMH = 2.4; end

                    -- number of hits it takes to kill us
                    local numHits = (expHealth / TTPCDB.MobHitAmount);
                    if (not TTDB.ContinuousDmg) then numHits = ceil(numHits); end

                    if not enemyOH then
                            -- 2H boss, interval = swing timer
                            return numHits * (enemyMH * (parryHasteEffect or self:GetParryHasteEffect()));
                    else
                            -- DW boss, interval = MH/OH interval
                            return numHits * (abs(enemyMH - enemyOH) * (parryHasteEffect or self:GetParryHasteEffect()));
                    end
            end

            return nil;
        end,

-- generic parry-haste function, customised by class modules
--
-- assumptions:
-- 1. parry has an equal chance to occur at any time during the mob's swing
-- 2. X% average haste increase => X% more swings over timeframe Y => X% increased damage
--
-- http://elitistjerks.com/f31/t37032-faq_working_theories_raiding_level_80_a/
-- When a parry occurs, the target that parried the attack has a chance of having the current swing hasted, as follows:
-- * If the next attack would normally occur within 20% of your weapon speed after the parry, there is no effect.
-- * If the next attack would normally occur between 20% and 60% of your weapon speed later, it happens 20% of your weapon speed later instead.
-- * If the next attack would normally occur more than 60% of your weapon speed later, the time until your next attack is reduced by 40% of your weapon speed.
    GetParryHasteEffect=
        function(self)
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
                -- 1 - (not-parry chance per swing)^(number of swings) * (not-parry chance per swing)^(number of parryable GCD attacks)
                if OffhandHasWeapon() then
                        -- DW tanks. Yes, I know.
                        local ohParryChance = max(0, (5 + (TTDB.EnemyLevelDiff * 3) - ohPC)/100);
                        parryChance = 1 - (1-parryChance)^(parryWindow / playerMH) * (1-ohParryChance)^(parryWindow / playerOH) * (1-parryChance)^(self.ParryableGCDs * (parryWindow / 1.5));
                else
                        parryChance = 1 - (1-parryChance)^(parryWindow / playerMH) * (1-parryChance)^(self.ParryableGCDs * (parryWindow / 1.5));
                end
    
                -- parry chance * ((20% to 60%)*(20% haste) + (60% to 100%)*(40% haste))
                hasteMod = 1.0 - parryChance * (0.4*0.2 + 0.4*0.4);
            end
    
            -- returns a coefficient indicating the average reduction in swing timer
            return hasteMod;
        end,

-- Get unmitigated damage given postmitigation damage and school.
-- Calculation uses the current mitigation against the given school.
-- School can refer to melee or bleed.
--
-- Generic function; CLASSMODULE:Unmitigate add extra features.
--
-- The function operates as follows:
-- 1.  Add resist, block and absorb to dmg to get the total damage just before resistance was applied.
-- 2a. For physical damage, resist is nil and the unmitigated damage is dmg/(1-mitigation).
-- 2b. For spell damage which we partially resisted, it's a bit more complicated.
--     Divide dmg by the spell mitigation ONLY from (buffs & talents) to get the unmitigated damage.
-- 2c. Find (actual resist amount - value had we resisted the minimum guaranteed amount).
--     This is probResist, the extra resistance due to probabilistic mechanics.
-- 3.  Return [unmitDmg, probResist]
    Unmitigate=
        function(self, dmg, school, resist, block, absorb)
            local unmitDmg = 0;
            local probResist = 0;

            if school and TankTotals.FinalMitigation[school] then
                -- initialise nil variables to 0
                resist = (resist or 0); absorb = (absorb or 0); block = (block or 0);

                -- augment dmg to total just before resistance is applied
                dmg = dmg + resist + absorb + block;

                -- if it's physical damage, use the values in TankTotals.FinalMitigation
                if school == TankTotals.INDEX_MELEE or school == TankTotals.INDEX_BLEED then
                    unmitDmg = infDiv(dmg, TankTotals.FinalMitigation[school]);
                else
                    -- probResist is the resistance due to probabilistic mechanics
                    -- i.e. difference between observed resist and expected min resist
                    probResist = max(0, resist - dmg*(1-TankTotals.MinResistances[school]));

                    -- unmitigated dmg is (dmg before resist)/(mit from talents & buffs)
                    unmitDmg = infDiv(dmg, TankTotals.GuaranteedSpellMitigation);
                end
            end

            return unmitDmg, probResist;
        end,

    IsTaunt =
        function(self, spellID)
            return self:IsSingleTargetTaunt(spellID) or self:IsAoETaunt(spellID);
        end,

    GetCurrentStance=
        function(self)
            local stanceNum = GetShapeshiftForm(nil);

            if stanceNum ~= nil and stanceNum > 0 then
                    icon, name, active, castable = GetShapeshiftFormInfo(stanceNum);
                    return ((name == nil and "") or name);
            else
                    return "";
            end
        end,

};
