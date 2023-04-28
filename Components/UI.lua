
local growOpts = TankTotals.GrowOpts;
local media = LibStub("LibSharedMedia-3.0");

local qTip = LibStub("LibQTip-1.0");
local L = LibStub("AceLocale-3.0"):GetLocale("TankTotals", false);

-- create the LDB feed and its QTip
local ttQTip = nil;
TankTotals.LDB = LibStub:GetLibrary("LibDataBroker-1.1"):NewDataObject("TankTotals", {type = "data source", text = "TankTotals", icon = "Interface\\Icons\\Spell_Holy_ArdentDefender"});

-- LDB/QTip events
function TankTotals.LDB:OnEnter()
    -- acquire a 2-column tooltip
    ttQTip = qTip:Acquire("TankTotalsQTip", 2, "LEFT", "RIGHT")

    -- set fonts
    local headerFont = CreateFont("TankTotalsTooltipHeaderFont");
    headerFont:SetFont(media:Fetch("font", TTDB.Font), 16);

    if TTPCDB.AddonActive then
        local normalFont = CreateFont("TankTotalsTooltipFont");
        normalFont:SetFont(media:Fetch("font", TTDB.Font), 12);

        ttQTip:SetFont(normalFont);
        ttQTip:SetHeaderFont(headerFont);

        -- populate the tooltip
        TankTotals:SendSummaryTo(ttQTip);
    else
        ttQTip:AddHeader("|cffff0000"..L["ADDON_DISABLED"].."|r", "");
    end

    -- anchor and display the tooltip
    ttQTip:SmartAnchorTo(self);
    ttQTip:Show();
end

function TankTotals.LDB:OnLeave()
    qTip:Release(ttQTip);
    ttQTip = nil;
end

-- left-click toggles standalone display, right-click opens config GUI
function TankTotals.LDB:OnClick(button, down)
    if button == "LeftButton" and TTPCDB.AddonActive then
        TTPCDB.ShowSummary = (not TTPCDB.ShowSummary);
        if TTPCDB.ShowSummary then TankTotals:UpdateDisplayText(); else TankTotals:SetShown(false); end
    elseif button == "RightButton" then
        LibStub("AceConfigDialog-3.0"):Open("TankTotals");
    end
end

function TankTotals:UpdateDisplayText()
        -- if the standalone display is visible, push the data to it
        if TTPCDB.ShowSummary then self:SendSummaryTo(self); self:SetShown(true); end

        -- if there's a tooltip active, send update there as well
        if ttQTip then self:SendSummaryTo(ttQTip); end

        -- set the LDB label...
        local title1, title2 = self:CreateHeaderText("DOWN");
        if self.LDB.label ~= title1..title2 then self.LDB.label = title1..title2; end

        -- ... and stats text
        self.LDB.text = "A: "..ttvFormat(TankTotals.Avoidance, 1).."% M: "..ttvFormat(100 * (1-self.FinalMitigation[self.INDEX_MELEE]), 1).."% ";
        self.LDB.text = self.LDB.text..self.SchoolColors[self.INDEX_BLEED].."B: "..ttvFormat(100 * (1-self.FinalMitigation[self.INDEX_BLEED]), 1).."%|r "..self.SchoolColors[self.INDEX_HOLY].."S: "..ttvFormat(100 * (1-self.GuaranteedSpellMitigation), 1).."%|r";
end

function TankTotals:SetupUI()
    self:BuildLayout();
    self:RegisterConfigTable();
    self:MoveAnchorPos(TTPCDB.AnchorPos[0], TTPCDB.AnchorPos[1]);
end

function TankTotals:RegisterConfigTable()
        self.ConfigTable.args.Announce.args.sink = self:GetSinkAce3OptionsDataTable();
        self.ConfigTable.args.Announce.args.sink.desc = L["SETTINGS_SECONDARY_OUTPUT_DESC"];
        self.ConfigTable.args.Announce.args.sink.name = L["SETTINGS_SECONDARY_OUTPUT"];
        self:SetSinkStorage(TTPCDB.SinkOutput);

        -- register GUI and console tables
	LibStub("AceConfig-3.0"):RegisterOptionsTable("TankTotals", self.ConfigTable);
	LibStub("AceConfig-3.0"):RegisterOptionsTable("TankTotalsCLI", self.ConsoleCommands, "tanktotals");

        -- set GUI config parameters
	LibStub("AceConfigDialog-3.0"):SetDefaultSize("TankTotals", 430, 385);
	pcall(function() LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TankTotals") end);
end

-- announcements of CDs, taunt misses, etc
function TankTotals:Announce(announceText, r, g, b)
        if self:InstanceStanceOrPVP() then
            if TTDB.AnnounceChannel ~= L["NONE"] then
                SendChatMessage(announceText, self:CheckChannel());
            end

            -- secondary output via LibSink
            self:Pour(announceText, (r or 1), (g or 0), (b or 0));
        end
end

function TankTotals:BuildLayout()
    -- anchor frame
    self.AnchorFrame = CreateFrame("Frame", "TankTotalsAnchorFrame", UIParent);
    self.AnchorFrame:SetWidth(1); self.AnchorFrame:SetHeight(1);
    self.AnchorFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    self.AnchorFrame:Hide();

    -- for dragging
    self.AnchorFrame:SetScript("OnUpdate", function() self:OnAnchorDrag(); end);

    -- title bar
    self.TitleBar = self:SpawnFrame("Button", "TOPLEFT", self.AnchorFrame, "TOPLEFT", 0, 0, UIParent, 18);

    -- right-click to open config, left to roll up/down
    self.TitleBar.frame:RegisterForDrag("LeftButton");
    self.TitleBar.frame:RegisterForClicks("LeftButtonUp", "RightButtonUp");

    self.TitleBar.frame:SetScript("OnEnter", function() if(TTDB.PopUp and not self.LEFT.text:IsVisible()) then self:WindowBlinds(); end end);
    self.TitleBar.frame:SetScript("OnLeave", function() if(TTDB.PopUp and self.LEFT.text:IsVisible()) then self:WindowBlinds(); end end);
    self.TitleBar.frame:SetScript("OnMouseUp", function(self, button, down) if(button=="LeftButton") then if IsControlKeyDown() then TTDB.PopUp = (not TTDB.PopUp); elseif not TTDB.PopUp then TankTotals:WindowBlinds(); end elseif(button=="RightButton") then LibStub("AceConfigDialog-3.0"):Open("TankTotals"); end end);
    self.TitleBar.frame:SetScript("OnDragStart", function() if IsAltKeyDown() then self.AnchorFrame:Show(); end end);
    self.TitleBar.frame:SetScript("OnDragStop", function() self.AnchorFrame:Hide(); end);

    -- left and right table columns
    self:SpawnDisplayColumns();

    self:SetScale(TTPCDB.WindowScale);
    self:SetShown(TTPCDB.AddonActive and TTPCDB.ShowSummary);

    -- restore WindowBlinds state from previous session
    if TTPCDB.AddonActive and TTPCDB.WindowBlindsUp and self.LEFT.text:IsVisible() then self:WindowBlinds(); end
end

function TankTotals:SpawnDisplayColumns()
    if TTPCDB.GrowDir == "LEFT" then
        self.RIGHT = self:SpawnFrame("Frame", growOpts[TTPCDB.GrowDir]["RIGHT"][1], growOpts[TTPCDB.GrowDir]["RIGHT"].frame(), growOpts[TTPCDB.GrowDir]["RIGHT"][3], growOpts[TTPCDB.GrowDir]["RIGHT"][4], growOpts[TTPCDB.GrowDir]["RIGHT"][5], self.TitleBar.frame, 14);
        self.LEFT = self:SpawnFrame("Frame", growOpts[TTPCDB.GrowDir]["LEFT"][1], growOpts[TTPCDB.GrowDir]["LEFT"].frame(), growOpts[TTPCDB.GrowDir]["LEFT"][3], growOpts[TTPCDB.GrowDir]["LEFT"][4], growOpts[TTPCDB.GrowDir]["LEFT"][5], self.TitleBar.frame, 14);
    else
        self.LEFT = self:SpawnFrame("Frame", growOpts[TTPCDB.GrowDir]["LEFT"][1], growOpts[TTPCDB.GrowDir]["LEFT"].frame(), growOpts[TTPCDB.GrowDir]["LEFT"][3], growOpts[TTPCDB.GrowDir]["LEFT"][4], growOpts[TTPCDB.GrowDir]["LEFT"][5], self.TitleBar.frame, 14);
        self.RIGHT = self:SpawnFrame("Frame", growOpts[TTPCDB.GrowDir]["RIGHT"][1], growOpts[TTPCDB.GrowDir]["RIGHT"].frame(), growOpts[TTPCDB.GrowDir]["RIGHT"][3], growOpts[TTPCDB.GrowDir]["RIGHT"][4], growOpts[TTPCDB.GrowDir]["RIGHT"][5], self.TitleBar.frame, 14);
    end
end

function TankTotals:SendSummaryTo(recipient)
        -- if nil, recipient is TankTotals itself
        recipient = (recipient or self);

        -- clear the current contents
        recipient:Clear();

	-- add title bar text
        self:SetHeaderText(recipient);

	-- avoidance and mitigation %
        recipient:AddLine(L["AVOID_HEADING"], ttvFormat(self.Avoidance).."%");
        recipient:AddLine(L["MIT_HEADING"], ttvFormat(100 * (1-self.FinalMitigation[self.INDEX_MELEE])).."%");
        recipient:AddLine(L["TOTAL_PDR_HEADING"], ttvFormat(100 * (1-self.ClassModule:GetTotalPhysicalDR())).."%");

	-- spell mitigation
	self:SetGuaranteedSpellMitigationText(recipient);

	-- flat mitigation info (plus block where relevant)
	self:SetBlockFlatMitigationText(recipient);

	-- show minimum and average mitigation per school, if relevant
	if TTDB.ShowResistances and self:ResMinNotEqualToAvg() then
                recipient:AddLine("", "");

                local leftText = "";
                local rightText = "";

                for mSchool = 1, 5, 2 do
                    leftText = self.SchoolColors[2^mSchool]..ttvFormat(100 * (1-self.FinalMitigation[2^mSchool]),1).."/"..ttvFormat(100 * (1-self.AverageSpellMitigation[2^mSchool]),1).."%|r";
                    rightText = self.SchoolColors[2^(mSchool+1)]..ttvFormat(100 * (1-self.FinalMitigation[2^(mSchool+1)]),1).."/"..ttvFormat(100 * (1-self.AverageSpellMitigation[2^(mSchool+1)]),1).."%|r";
                    recipient:AddLine(leftText, rightText);
                end
	end

	-- custom text, e.g. ardent defender / will of the necropolis
	self.ClassModule:AddCustomDisplayText(recipient);

        -- effective and expected health
        self:SetEffectiveHealthText(recipient);

	-- block cap info and formatting
	if self.ClassModule.ShowBlockInfo then
                recipient:AddLine("", "");

		local blockCapNum = nil;

		if self.BlockCap < 100 then
			blockCapNum = "|cffff0000"..ttvFormat(self.BlockCap).."%|r";
		else
			-- show the 1 in green to indicate 100%, and the excess block in orange
			blockCapNum = "|cff00ff001|cffff9933"..strsub(tostring(ttvFormat(self.BlockCap)), 2).."|cff00ff00%|r";
		end

		recipient:AddLine(L["BLOCK_CAP"], blockCapNum);
	end
end

function TankTotals:AddHeader(leftText, rightText)
        self.TitleBar.text:SetText(leftText..rightText);
end

function TankTotals:AddLine(leftText, rightText)
        self:AddLeft(leftText.."\n");
        self:AddRight(rightText.."\n");
end

function TankTotals:Clear()
        self.LEFT.text:SetText("");
        self.RIGHT.text:SetText("");
end

function TankTotals:AddLeft(newText)
        self.LEFT.text:SetText((self.LEFT.text:GetText() or "")..newText);
end

function TankTotals:AddRight(newText)
        self.RIGHT.text:SetText((self.RIGHT.text:GetText() or "")..newText);
end

function TankTotals:SetShown(show)
        if(show and TTPCDB.AddonActive) then
                self.TitleBar.frame:Show();
                if(TTDB.PopUp and self.LEFT.text:IsVisible() and not MouseIsOver(self.TitleBar.frame)) then self:WindowBlinds(); end
        else
                self.TitleBar.frame:Hide();
        end
end

function TankTotals:WindowBlinds()
        if(self.LEFT.text:IsVisible()) then
                self.LEFT.text:Hide();
                self.RIGHT.text:Hide();
                TTPCDB.WindowBlindsUp = true;
        else
                self.LEFT.text:Show();
                self.RIGHT.text:Show();
                TTPCDB.WindowBlindsUp = false;
        end
end

function TankTotals:SetScale(scale)
        self.TitleBar.frame:SetScale(scale);
end

function TankTotals:UpdateFont()
        local leftText = self.LEFT.text:GetText();
        local rightText = self.RIGHT.text:GetText();
        local titleText = self.TitleBar.text:GetText();

        local displayVisible = self.LEFT.text:IsVisible();
        local titleVisible = self.TitleBar.text:IsVisible()

        self.TitleBar.text:Hide();
        self.TitleBar.text = self:SpawnFontString(self.TitleBar.frame, "TOPLEFT", self.AnchorFrame, "TOPLEFT", 0, 0, 18);

        self.LEFT.text:Hide();
        self.LEFT.text = self:SpawnFontString(self.LEFT.frame, growOpts[TTPCDB.GrowDir]["LEFT"][1], growOpts[TTPCDB.GrowDir]["LEFT"].frame(), growOpts[TTPCDB.GrowDir]["LEFT"][3], growOpts[TTPCDB.GrowDir]["LEFT"][4], growOpts[TTPCDB.GrowDir]["LEFT"][5], 14);

        self.RIGHT.text:Hide();
        self.RIGHT.text = self:SpawnFontString(self.RIGHT.frame, growOpts[TTPCDB.GrowDir]["RIGHT"][1], growOpts[TTPCDB.GrowDir]["RIGHT"].frame(), growOpts[TTPCDB.GrowDir]["RIGHT"][3], growOpts[TTPCDB.GrowDir]["RIGHT"][4], growOpts[TTPCDB.GrowDir]["RIGHT"][5], 14);

        self.LEFT.text:SetText(leftText);
        self.RIGHT.text:SetText(rightText);
        self.TitleBar.text:SetText(titleText);

        if not titleVisible then
            self.TitleBar.text:Hide();
        elseif not displayVisible then
            self:WindowBlinds();
        end
end

-- add spell & bleed mitigation info
function TankTotals:SetGuaranteedSpellMitigationText(recipient)
        -- bleed and guaranteed cross-school mitigation
        recipient:AddLine("    |cffff0000"..L["BLEED"].."|r", "|cffff0000"..ttvFormat(100 * (1-self.FinalMitigation[self.INDEX_BLEED])).."%|r");
        recipient:AddLine("    |cffffff00"..L["ALLSPELL_HEADING"].."|r", "|cffffff00"..ttvFormat(100 * (1-self.GuaranteedSpellMitigation)).."%|r");

        -- get groupings of which schools are at which levels of mitigation
	local minResGroups = self:GetSpecialMinResGroups();

	if minResGroups ~= nil then
		for gIndex, gVal in pairs(minResGroups) do
			if getn(gVal) == 1 then
				local leftText = "    "..self.SchoolColors[gVal[1]]..self.SchoolNames[gVal[1]]..":|r";
				local rightText = self.SchoolColors[gVal[1]]..ttvFormat(100 * (1-self.FinalMitigation[gVal[1]])).."%|r";

                                recipient:AddLine(leftText, rightText);
			elseif getn(gVal) > 0 then
				local spellHeadings = "    ";

				for sgIndex, sgVal in pairs(gVal) do
					spellHeadings = spellHeadings..self.SchoolColors[sgVal]..strsub(self.SchoolNames[sgVal], 1, 1);
				end

                                -- add the list of magic schools at the current mitigation level
				recipient:AddLine(spellHeadings..":|r", "|r|cffffff00"..ttvFormat(100 * (1-self.FinalMitigation[gVal[1]])).."%|r");
			end
		end
	end
end

function TankTotals:SetBlockFlatMitigationText(recipient)
	local flatMitText, flatMitAmt = self.ClassModule:GetFlatMitigationInfo();

	if flatMitText ~= nil then
		recipient:AddLine("", "");

                flatMitAmt = round(flatMitAmt);

		if self.ClassModule.ShowBlockInfo then
                        recipient:AddLine(L["BLOCK"], ttvFormat(self.BlockChance).."%");
                        recipient:AddLine("", "");
		end

		recipient:AddLine(flatMitText, round(flatMitAmt));

                if self.ClassModule.BlockTotal then
                        recipient:AddLine(L["BLOCK_TOTAL"], ttvFormat(self.ClassModule.BlockTotal/1000, 1).."k");
                end
	end
end

function TankTotals:SetEffectiveHealthText(recipient)
        -- get expected and effective HP
        local expHealth, effHealth = self.ClassModule:GetExpectedHealth();

        -- convert expected health to expected TTL
        if effHealth then effHealth = ttvFormat(effHealth/1000).."k"; end
        if expHealth then expHealth = self.ClassModule:GetExpectedTTL(expHealth); if expHealth then expHealth = ttvFormat(expHealth).."s"; end end

        -- add effective HP & expected TTL text
        recipient:AddLine("", "");
	recipient:AddLine("|cff00ff00"..L["EFF_HP_HEADING"].."|r", "|cff00ff00"..(effHealth or "∞").."|r");
	recipient:AddLine("|cff00ff00"..L["EXP_TL_HEADING"].."|r", "|cff00ff00"..(expHealth or "∞").."|r");

        if TTDB.ShowNEH then
            recipient:AddLine("", "");
            local EH2Color = "|cffffff00";

            -- compute EH2 based on class
            local wMit, neh = self.ClassModule:GetNEH();

            -- if there's recorded data, change the colour
            -- of actual EH2 in relation to upper/lower
            if TTPCDB.NEH_DATA then
                -- if current EH2 >= upper EH2 bound, colour it green
                if neh and neh >= TTPCDB.NEH_DATA.eh2bounds[2] then
                    EH2Color = "|cff00ff00";
                -- if current EH2 < lower EH2 bound, colour it red
                elseif neh and neh < TTPCDB.NEH_DATA.eh2bounds[1] then
                    EH2Color = "|cffff0000";
                end
            end

            -- print current NEH
            recipient:AddLine("|cffffff00"..L["NEH_HEADING"].."|r", EH2Color..((neh and ttvFormat(neh/1000).."k") or "∞").."|r");

            -- print lower and upper bounds
            if TTPCDB.NEH_DATA then
                recipient:AddLine("|cffffff00"..L["NEH_LOWER_HEADING"].."|r", "|cffffff00"..ttvFormat(TTPCDB.NEH_DATA.eh2bounds[1]/1000).."k|r");
                recipient:AddLine("|cffffff00"..L["NEH_UPPER_HEADING"].."|r", "|cffffff00"..ttvFormat(TTPCDB.NEH_DATA.eh2bounds[2]/1000).."k|r");
            end

            -- weighted mitigation
            recipient:AddLine("|cffffff00"..L["SURVIVAL_HEADING"].."|r", EH2Color..ttvFormat(100 * (1-wMit)).."%|r");
        end
end

function TankTotals:SpawnFrame(frameType, point, relFrame, relPoint, xOff, yOff, parent, fontSize)
	local newFrame = {};

	newFrame.frame = CreateFrame(frameType, nil, parent);
	newFrame.text = self:SpawnFontString(newFrame.frame, point, relFrame, relPoint, xOff, yOff, fontSize);

	return newFrame;
end

function TankTotals:SpawnFontString(frame, point, relFrame, relPoint, xOff, yOff, fontSize)
	newText = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal");
	newText:SetPoint(point, relFrame, relPoint, xOff, yOff);

	newText:SetFont(media:Fetch("font", TTDB.Font), fontSize, TTDB.FontOutline);
	newText:SetTextColor(1.0, 1.0, 1.0);
	newText:SetJustifyH("LEFT");
	newText:SetText("");

	frame:ClearAllPoints();
	frame:SetAllPoints(newText);

	return newText;
end

function TankTotals:SetGrowthDirection()
        self:SetHeaderText(self);

        self.LEFT.text:ClearAllPoints();
        self.RIGHT.text:ClearAllPoints();

        self.LEFT.text:SetPoint(growOpts[TTPCDB.GrowDir]["LEFT"][1], growOpts[TTPCDB.GrowDir]["LEFT"].frame(), growOpts[TTPCDB.GrowDir]["LEFT"][3], growOpts[TTPCDB.GrowDir]["LEFT"][4], growOpts[TTPCDB.GrowDir]["LEFT"][5]);
        self.RIGHT.text:SetPoint(growOpts[TTPCDB.GrowDir]["RIGHT"][1], growOpts[TTPCDB.GrowDir]["RIGHT"].frame(), growOpts[TTPCDB.GrowDir]["RIGHT"][3], growOpts[TTPCDB.GrowDir]["RIGHT"][4], growOpts[TTPCDB.GrowDir]["RIGHT"][5]);
end

function TankTotals:SetHeaderText(recipient)
        -- add the text as the header
        -- if we're populating the tooltip, simulate growth direction as down
        recipient:AddHeader(self:CreateHeaderText((recipient == self and TTPCDB.GrowDir) or "DOWN"));
end

-- separate this function so that the LDB text can be set independently
function TankTotals:CreateHeaderText(growDir)
        local headerColor = ((self.ClassModule:TankingStanceActive() and "|cffffff00") or "|cffff0000");
        return headerColor..growOpts[growDir]["TITLETEXT"].."|r", headerColor..growOpts[growDir][TTDB.EnemyLevelDiff].."|r";
end

function TankTotals:OnAnchorDrag()
	TTPCDB.AnchorPos[0], TTPCDB.AnchorPos[1] = GetCursorPosition();
	self:MoveAnchorPos(TTPCDB.AnchorPos[0], TTPCDB.AnchorPos[1]);
end

function TankTotals:MoveAnchorPos(xpos, ypos)
        self.AnchorFrame:ClearAllPoints();

	if xpos == -1 and ypos == -1 then
		self.AnchorFrame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0);
	else
		local xmin,ymin = UIParent:GetLeft(), UIParent:GetBottom();

		xposRel = -(xmin-xpos/UIParent:GetScale());
		yposRel = ypos/UIParent:GetScale()-ymin;

		self.AnchorFrame:SetPoint("CENTER", "UIParent", "BOTTOMLEFT", xposRel, yposRel);
	end
end

