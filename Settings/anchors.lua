--[[-----------------------------------------------------------------------------

	Anchor frames for player, targer, focus, party, raid & boss
--]]-----------------------------------------------------------------------------
local _, ns = ...

local pos = {
	player = {'CENTER', -235, -200},
	target = {'CENTER', 235, -200},
	focus = {'CENTER', -650, 80},
	party = {'TOPLEFT', 25, -240},
	boss = {'TOPRIGHT', -110, -235},
	arena = {'TOPRIGHT', -95, -230},
}

local function SetUpAnchor(frame, unit)
	frame.unit = unit

	frame:SetPoint(unpack(pos[unit]))
	frame:SetMovable(true)
	frame:SetSize(1,1)
end

local oUF_AbuPlayerAnchor = CreateFrame("Frame","oUF_AbuPlayerAnchor", UIParent)
SetUpAnchor(oUF_AbuPlayerAnchor, 'player')
local oUF_AbuTargetAnchor = CreateFrame("Frame","oUF_AbuTargetAnchor", UIParent)
SetUpAnchor(oUF_AbuTargetAnchor, 'target')
local oUF_AbuFocusAnchor = CreateFrame("Frame","oUF_AbuFocusAnchor", UIParent)
SetUpAnchor(oUF_AbuFocusAnchor, 'focus')

local oUF_AbuPartyAnchor = CreateFrame("Frame","oUF_AbuPartyAnchor", UIParent)
SetUpAnchor(oUF_AbuPartyAnchor, "party")
local oUF_AbuBossAnchor = CreateFrame("Frame","oUF_AbuBossAnchor", UIParent)
SetUpAnchor(oUF_AbuBossAnchor, "boss")
local oUF_AbuArenaAnchor = CreateFrame("Frame","oUF_AbuArenaAnchor", UIParent)
SetUpAnchor(oUF_AbuArenaAnchor, "arena")

local function ToggleUnitFrame(obj, show)
	if not show then
		obj.unit = obj.old_unit or obj.unit
		obj.old_unit = nil

		UnregisterUnitWatch(obj) -- Reset the object
		RegisterUnitWatch(obj)

		if obj.old_OnUpdate then
			obj:SetScript("OnUpdate", obj.old_OnUpdate)
			obj.old_OnUpdate = nil
		end

		obj:UpdateAllElements("OnShow")
	elseif show then
		obj.old_unit = obj.unit
		obj.unit = "player"
		obj.old_OnUpdate = obj:GetScript("OnUpdate")

		obj:SetScript("OnUpdate", nil)
		UnregisterUnitWatch(obj)
		RegisterUnitWatch(obj, true)

		obj:Show()
		if obj.CCastbar then
			obj.CCastbar:DummyCastbar()
		end
	end
end

local function DummyFrame_SetUnitScripts(frame, ...)
	local function script(self, show)
		for _, obj in pairs(oUF.objects) do
			local unit = obj:GetAttribute("unit")
			if (unit) then
				for i = 1, #self.units do
					if (unit == self.units[i]) then
						ToggleUnitFrame(obj, show)
					end
				end
			end
		end
	end

	frame.units = {...}
	frame:SetScript("OnShow", function(self)
		script(self, true)
	end)
	frame:SetScript("OnHide", function(self)
		script(self)
	end)
end

local function DummyFrame_SetHeaderScripts(frame, header)
	frame.header = header
	frame:SetScript("OnShow", function(self)
		SecureStateDriverManager:SetAttribute("setframe", self.header)
		self.oldstate_driver = SecureStateDriverManager:GetAttribute("setstate"):gsub("state%-visibility%s", "") -- i suck at string formatting
		local numMembers = math.max(GetNumSubgroupMembers(LE_PARTY_CATEGORY_HOME) or 0, GetNumSubgroupMembers(LE_PARTY_CATEGORY_INSTANCE) or 0)
		self.header:SetAttribute("startingIndex", (numMembers - 3))
		RegisterAttributeDriver(self.header, 'state-visibility', 'show')
		for i = 1, self.header:GetNumChildren() do
			local obj = select(i, self.header:GetChildren())
			ToggleUnitFrame(obj, true)
		end
	end)
	frame:SetScript("OnHide", function(self)
		self.header:SetAttribute("showParty", true)
		RegisterAttributeDriver(self.header, "state-visibility", self.oldstate_driver)
		self.oldstate_driver = nil
		self.header:SetAttribute("startingIndex", nil)
		for i = 1, self.header:GetNumChildren() do
			local obj = select(i, self.header:GetChildren())
			ToggleUnitFrame(obj)
		end
	end)
end

local DummyFrames
local function CreateDummyFrames()
	DummyFrames = {};
	--Party:
	local function createFrame(anchor)
		local f = CreateFrame("Button", anchor:GetName().."Dummy", UIParent)
		f.anchor = anchor
		f:Hide()
		f:EnableMouse(true)

		f:SetScript('OnMouseUp', function(self, button) -- reset
			if (IsAltKeyDown()) and (button == "LeftButton") then
				local anchor = self.anchor
				anchor:ClearAllPoints();
				anchor:SetPoint(unpack(pos[anchor.unit]));
				anchor:SetUserPlaced(false);
				anchor:SetClampedToScreen(false);
			end
		end)

		f:SetScript('OnDragStart', function(self)
			if IsShiftKeyDown() then
				local anchor = self.anchor
				anchor:StartMoving();
				anchor:SetUserPlaced(true);
				anchor:SetClampedToScreen(true);
			end
		end)

		f:SetScript('OnDragStop', function(self)
			local anchor = self.anchor
			anchor:StopMovingOrSizing();
		end)

		table.insert(DummyFrames, f)
		return f
	end

	local party = oUF_AbuParty
	if party then
		local p = createFrame(oUF_AbuPartyAnchor) 
		DummyFrame_SetHeaderScripts(p, party)
		p:Show()
		p:Hide() -- forcing it so we can set points
		p:SetPoint('TOPLEFT', oUF_AbuPartyAnchor)
		p:SetPoint('BOTTOMRIGHT', oUF_AbuPartyUnitButton4)
		p:SetFrameStrata("HIGH")
	end

	if oUF_AbuArenaFrame1 then
		local a = createFrame(oUF_AbuArenaAnchor)
		DummyFrame_SetUnitScripts(a, "arena1", "arena2", "arena3", "arena4", "arena5")
		a:SetPoint('TOPRIGHT', oUF_AbuArenaAnchor)
		a:SetPoint("BOTTOMLEFT", oUF_AbuArenaFrame5)
		a:SetFrameStrata("HIGH")
	end

	if oUF_AbuBossFrame1 then
		local b = createFrame(oUF_AbuBossAnchor)
		DummyFrame_SetUnitScripts(b, "boss1", "boss2", "boss3", "boss4", "boss5")
		b:SetPoint('TOPRIGHT', oUF_AbuBossAnchor)
		b:SetPoint("BOTTOMLEFT", oUF_AbuBossFrame5)
		b:SetFrameStrata("DIALOG") --above arena
	end

	local singleUnits = {"player", "target", "focus"}
	for i = 1, #singleUnits do
		local unit = singleUnits[i]
		local framename = 'oUF_Abu'..unit:gsub('^%a', string.upper)
		local a = _G[framename.."Anchor"]
		local f = createFrame(a)
		DummyFrame_SetUnitScripts(f, unit)
		f:SetAllPoints(_G[framename])
		f:SetFrameStrata("HIGH")
	end
end

function oUFAbu:PLAYER_REGEN_DISABLED()
	self:Print("Nice one, you broke it! Frames locked.")
	self:ToggleDummyFrames(true)
end

local DummyFrames_Locked = true
function oUFAbu:ToggleDummyFrames(hide)
	if (not DummyFrames) then CreateDummyFrames(); end

	if DummyFrames_Locked and not hide then
		if InCombatLockdown() then return self:Print("Can't unlock frames in combat."); end
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		for i = 1, #DummyFrames do
			local doll = DummyFrames[i]
			doll:RegisterForDrag("LeftButton")
			doll:RegisterForClicks("AnyUp")
			doll:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				local name = self:GetName():gsub('AnchorDummy', '')
				GameTooltip:AddLine(name)
				GameTooltip:AddLine("Hold down SHIFT to drag",1,1,1)
				GameTooltip:AddLine("ALT click to reset position",1,1,1)
				GameTooltip:Show()
			end)
			doll:SetScript("OnLeave", GameTooltip.Hide)
			doll:Show()
		end
		self:Print("Frame unlocked!")
		DummyFrames_Locked = false
		return true
	elseif (not DummyFrames_Locked) then
		self:UnregisterEvent("PLAYER_REGEN_DISABLED")
		for i = 1, #DummyFrames do
			local doll = DummyFrames[i]
			doll:Hide()
			doll:RegisterForDrag()
			doll:RegisterForClicks()
			doll:SetScript("OnEnter", nil)
			doll:SetScript("OnLeave", nil)
		end
		self:Print("Frame locked!")
		DummyFrames_Locked = true
		return false
	end
end