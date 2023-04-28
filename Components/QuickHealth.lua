
-- Combat log messages can arrive before their effect on health is
-- reflected in UnitHealth("player"). This module ensures consistency
-- across all other modules. Every module which uses the combat log
-- should call UpdateQuickHealth as soon as they receive a message.
local QuickHealth = TankTotals:NewModule("QuickHealth", "AceEvent-3.0");

-- register for health-related events
function QuickHealth:OnEnable()
        self:RegisterEvent("UNIT_HEALTH");
        self:RegisterEvent("UNIT_MAXHEALTH");

        self:RegisterEvent("PLAYER_ALIVE", "UNIT_HEALTH");
        self:RegisterEvent("PLAYER_UNGHOST", "UNIT_HEALTH");
        self:RegisterEvent("PLAYER_ENTERING_WORLD", "UNIT_HEALTH");

        self:UNIT_HEALTH("PLAYER_ALIVE");
end

-- UNIT_HEALTH messages are authoritative
function QuickHealth:UNIT_HEALTH(eventName, unitID)
        -- set Health and HealthMax on health update, res, corpse run or login
        if eventName == "PLAYER_ALIVE" or eventName == "PLAYER_UNGHOST" or eventName == "PLAYER_ENTERING_WORLD" or unitID == "player" then
            TankTotals.PlayerQuickHealth, TankTotals.PlayerQuickHealthMax = UnitHealth("player"), UnitHealthMax("player");
        end
end

-- UNIT_MAXHEALTH messages are authoritative
function QuickHealth:UNIT_MAXHEALTH(eventName, unitID)
        if unitID == "player" then
            TankTotals.PlayerQuickHealthMax = UnitHealthMax("player");
        end
end

--------------------------------------------------------------------------------

local lastTimeStamp, lastEventType, lastSourceGUID, lastDestGUID = 0, 0, 0, 0;

-- determine damage/healing and apply
function QuickHealth:UpdateQuickHealth(...)
        -- extract info from arguments
        local timeStamp, eventType, sourceGUID, _, _, destGUID = select(1, ...);

        -- don't process the same event twice
        if timeStamp == lastTimeStamp and eventType == lastEventType and sourceGUID == lastSourceGUID and destGUID == lastDestGUID then return; end

        local dmgOrHeal = 0; -- negative for damage, positive for heals

        -- check that this event affects the player
	if destGUID == UnitGUID("player") then
		-- this is a damage event
		if strfind(eventType, "_DAMAGE") and (not strfind(eventType, "DURABILITY_DAMAGE")) then
                        local pOff = 0; -- parameter offset

                        -- offset +1 if it's environmental, +3 if it's anything else other than a melee swing
                        if eventType == "ENVIRONMENTAL_DAMAGE" then pOff = 1; elseif eventType ~= "SWING_DAMAGE" then pOff = 3; end

                        dmgOrHeal = -select(9+pOff, ...);
                -- this is a heal event
                elseif strfind(eventType, "_HEAL") then
                        dmgOrHeal = select(12, ...);
                end
        end

        -- update quickhealth variables
        TankTotals.PlayerQuickHealthMax = UnitHealthMax("player");
        TankTotals.PlayerQuickHealth = TankTotals.PlayerQuickHealth + dmgOrHeal;

        -- save details of current event to prevent double processing
        lastTimeStamp = timeStamp; lastEventType = eventType;
        lastSourceGUID = sourceGUID; lastDestGUID = destGUID;
end

