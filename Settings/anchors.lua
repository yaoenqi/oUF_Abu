--[[-----------------------------------------------------------------------------

	Anchor frames for player, targer and focus
	using blizzard's dropdown
--]]-----------------------------------------------------------------------------
local _, ns = ...

--[[ Default postions ]]
local pos = {
	player = {'CENTER', -235, -200},
	target = {'CENTER', 235, -200},
	focus = {'LEFT', 300, 80},
	party = {'TOPLEFT', 25, -240},
	boss = {'TOPRIGHT', -110, -235},
	arena = {'TOPRIGHT', -95, -230},
}

--[[	PLAYER 		]]

local oUF_AbuPlayerAnchor = CreateFrame("Frame","oUF_AbuPlayerAnchor", UIParent)
oUF_AbuPlayerAnchor:SetPoint(unpack(pos.player))
oUF_AbuPlayerAnchor:SetSize(1,1)
oUF_AbuPlayerAnchor:SetMovable(true)

function _G.PlayerFrame_OnDragStart(self)
	oUF_AbuPlayerAnchor:StartMoving();
	oUF_AbuPlayerAnchor:SetUserPlaced(true);
	oUF_AbuPlayerAnchor:SetClampedToScreen(true);
end
 
function _G.PlayerFrame_OnDragStop(self)
	oUF_AbuPlayerAnchor:StopMovingOrSizing();
end
 
function _G.PlayerFrame_SetLocked(locked)
	_G.PLAYER_FRAME_UNLOCKED = not locked;
	if (oUF_AbuPlayer) then
		if ( locked ) then
			oUF_AbuPlayer:RegisterForDrag();  --Unregister all buttons.
		else
			oUF_AbuPlayer:RegisterForDrag("LeftButton");
		end
	end
end

function _G.PlayerFrame_ResetUserPlacedPosition()
	if not InCombatLockdown() then
		oUF_AbuPlayerAnchor:ClearAllPoints();
		oUF_AbuPlayerAnchor:SetPoint(unpack(pos.player));
		oUF_AbuPlayerAnchor:SetUserPlaced(false);
		oUF_AbuPlayerAnchor:SetClampedToScreen(false);
		PlayerFrame_SetLocked(true);
	end
end

--[[	TARGET 		]]

local oUF_AbuTargetAnchor = CreateFrame("Frame","oUF_AbuTargetAnchor", UIParent)
oUF_AbuTargetAnchor:SetPoint(unpack(pos.target))
oUF_AbuTargetAnchor:SetMovable(true)
oUF_AbuTargetAnchor:SetSize(1,1)

function _G.TargetFrame_OnDragStart(self)
	oUF_AbuTargetAnchor:StartMoving();
	oUF_AbuTargetAnchor:SetUserPlaced(true);
	oUF_AbuTargetAnchor:SetClampedToScreen(true);
end
 
function _G.TargetFrame_OnDragStop(self)
	oUF_AbuTargetAnchor:StopMovingOrSizing();
end
 
function _G.TargetFrame_SetLocked(locked)
	_G.TARGET_FRAME_UNLOCKED = not locked;
	if(oUF_AbuTarget) then
		if ( locked ) then
			oUF_AbuTarget:RegisterForDrag();  --Unregister all buttons.
		else
			oUF_AbuTarget:RegisterForDrag("LeftButton");
		end
	end
end
 
function _G.TargetFrame_ResetUserPlacedPosition()
	if not InCombatLockdown() then
		oUF_AbuTargetAnchor:ClearAllPoints();
		oUF_AbuTargetAnchor:SetPoint(unpack(pos.target));
		oUF_AbuTargetAnchor:SetUserPlaced(false);
		oUF_AbuTargetAnchor:SetClampedToScreen(false);
		TargetFrame_SetLocked(true);
	end
end

--[[	FOCUS 		]]

local oUF_AbuFocusAnchor = CreateFrame("Frame","oUF_AbuFocusAnchor", UIParent)
oUF_AbuFocusAnchor:SetPoint(unpack(pos.focus))
oUF_AbuFocusAnchor:SetMovable(true)
oUF_AbuFocusAnchor:SetSize(1,1)

_G.FOCUS_FRAME_LOCKED = true;
function _G.FocusFrame_IsLocked()
	return FOCUS_FRAME_LOCKED;
end
 
function _G.FocusFrame_SetLock(locked)
	_G.FOCUS_FRAME_LOCKED = locked;
	if ( locked ) then
		oUF_AbuFocus:RegisterForDrag();
	else
		oUF_AbuFocus:RegisterForDrag("LeftButton");
	end
end
 
function _G.FocusFrame_OnDragStart(self, button)
	_G.FOCUS_FRAME_MOVING = false;
	if ( not FOCUS_FRAME_LOCKED ) then
		oUF_AbuFocusAnchor:StartMoving();
		oUF_AbuFocusAnchor:SetUserPlaced(true)
		oUF_AbuFocusAnchor:SetClampedToScreen(true)
		_G.FOCUS_FRAME_MOVING = true;
	end
end
 
function _G.FocusFrame_OnDragStop(self)
	if ( not FOCUS_FRAME_LOCKED and FOCUS_FRAME_MOVING ) then
		oUF_AbuFocusAnchor:StopMovingOrSizing();
		_G.FOCUS_FRAME_MOVING = false;
	end
end

function _G.FocusFrame_ResetUserPlacedPosition() -- Not blizzards
	if not InCombatLockdown() then
		oUF_AbuFocusAnchor:ClearAllPoints();
		oUF_AbuFocusAnchor:SetPoint(unpack(pos.focus));
		oUF_AbuFocusAnchor:SetUserPlaced(false);
		oUF_AbuFocusAnchor:SetClampedToScreen(false);
		FocusFrame_SetLock(true);
	end
end

-- [[ Custom ]]
local function SetUpAnchor(frame, posdata)
	frame:SetPoint(unpack(pos[posdata]))
	frame:SetMovable(true)
	frame:SetSize(1,1)
end

local oUF_AbuPartyAnchor = CreateFrame("Frame","oUF_AbuPartyAnchor", UIParent)
SetUpAnchor(oUF_AbuPartyAnchor, "party")

local oUF_AbuBossAnchor = CreateFrame("Frame","oUF_AbuBossAnchor", UIParent)
SetUpAnchor(oUF_AbuBossAnchor, "boss")

local oUF_AbuArenaAnchor = CreateFrame("Frame","oUF_AbuArenaAnchor", UIParent)
SetUpAnchor(oUF_AbuArenaAnchor, "arena")

local framenames = {
	["oUF_AbuBossFrameDummy"] = "Boss Frames",
	["oUF_AbuArenaFrameDummy"] = "Arena Frames",
	["oUFPartyUnitButtonDummy"] = "Party Frames",
}

local function DummyFrames_GetFrame(self)
	local name = self:GetName()
	if string.find(name,"Party") then
		return oUF_AbuPartyAnchor, "party"
	elseif string.find(name,"Arena") then
		return oUF_AbuArenaAnchor, "arena"
	elseif string.find(name,"Boss") then
		return oUF_AbuBossAnchor, "boss"
	end
end

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
	frame.units = {...}
	frame:SetScript("OnShow", function(self)
		for _, obj in pairs(oUF.objects) do
			local unit = obj:GetAttribute("unit")
			if (unit) then
				for i = 1, #self.units do
					if (unit == self.units[i]) then
						ToggleUnitFrame(obj, true)
					end
				end
			end
		end
	end)
	frame:SetScript("OnHide", function(self)
		for _, obj in pairs(oUF.objects) do
			local unit = obj:GetAttribute("unit")
			if (unit) then
				for i = 1, #self.units do
					if (unit == self.units[i]) then
						ToggleUnitFrame(obj)
					end
				end
			end
		end
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
	local function createFrame(name)
		local frame = CreateFrame("Button", name, UIParent)
		frame:Hide()
		frame:EnableMouse(true)
		frame:SetScript('OnMouseUp', function(self, button)
			if IsAltKeyDown() then
				if (button == "LeftButton") then
					local frame, posData = DummyFrames_GetFrame(self)
					frame:ClearAllPoints();
					frame:SetPoint(unpack(pos[posData]));
					frame:SetUserPlaced(false);
					frame:SetClampedToScreen(false);
				end
			end
		end)
		frame:SetScript('OnDragStart', function(self)
			if IsShiftKeyDown() then
				local frame = DummyFrames_GetFrame(self)
				frame:StartMoving();
				frame:SetUserPlaced(true);
				frame:SetClampedToScreen(true);
			end
		end)
		frame:SetScript('OnDragStop', function(self)
			local frame = DummyFrames_GetFrame(self)
			frame:StopMovingOrSizing();
		end)

		table.insert(DummyFrames, frame)
		return frame
	end
	local party = oUF_AbuParty
	if party then
		local p = createFrame("oUFPartyUnitButtonDummy") 
		DummyFrame_SetHeaderScripts(p, party)
		p:Show()
		p:Hide() -- forcing it so we can set points
		p:SetPoint('TOPLEFT', oUF_AbuPartyAnchor)
		p:SetPoint('BOTTOMRIGHT', oUF_AbuPartyUnitButton4)
		p:SetFrameStrata("HIGH")
	end
	if oUF_AbuArenaFrame1 then
		local a = createFrame("oUF_AbuArenaFrameDummy")
		DummyFrame_SetUnitScripts(a, "arena1", "arena2", "arena3", "arena4", "arena5")
		a:SetPoint('TOPRIGHT', oUF_AbuArenaAnchor)
		a:SetPoint("BOTTOMLEFT", oUF_AbuArenaFrame5)
		a:SetFrameStrata("HIGH")
	end
	if oUF_AbuBossFrame1 then
		local b = createFrame("oUF_AbuBossFrameDummy")
		DummyFrame_SetUnitScripts(b, "boss1", "boss2", "boss3", "boss4", "boss5")
		b:SetPoint('TOPRIGHT', oUF_AbuBossAnchor)
		b:SetPoint("BOTTOMLEFT", oUF_AbuBossFrame5)
		b:SetFrameStrata("DIALOG") --above arena
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
		if InCombatLockdown() then return self:Print("Can't unclock frames in combat."); end
		self:RegisterEvent("PLAYER_REGEN_DISABLED")
		for i = 1, #DummyFrames do
			local doll = DummyFrames[i]
			doll:RegisterForDrag("LeftButton")
			doll:RegisterForClicks("AnyUp")
			doll:SetScript("OnEnter", function(self)
				GameTooltip:SetOwner(self, "ANCHOR_TOP")
				GameTooltip:AddLine(framenames[self:GetName()])
				GameTooltip:AddLine("Hold down SHIFT to drag",1,1,1)
				GameTooltip:AddLine("ALT click to reset position",1,1,1)
				GameTooltip:Show()
			end)
			doll:SetScript("OnLeave", function() GameTooltip:Hide() end)
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
		DummyFrames_Locked = true
		return false
	end
end