
local _, ns = ...

ns.fontstrings = {} -- For fonstrings
ns.fontstringsB = {}-- For big fonstrings
ns.statusbars = {}  -- For statusbars
ns.paintframes = {} -- For coloring frames

local L = {
	OptionsNotLoaded = 'Options could not be loaded because it is %s.',
	OptionsLoadAfterCB = 'Options will be loaded after combat!',
}

------------------------------------------------------------------------
--  Colors
oUF.colors.uninterruptible = { 1, 0.7, 0 }
oUF.colors.fallback = { 1, 1, 1 }

------------------------------------------------------------------------
--  Event handler
local oUFAbu = CreateFrame("Frame", 'oUFAbu')
oUFAbu:RegisterEvent("ADDON_LOADED")
oUFAbu:SetScript("OnEvent", function(self, event, ...)
	return self[event] and self[event](self, event, ...)
end)

function oUFAbu:ADDON_LOADED(event, addon)
	if addon == "oUF_Abu" then
		local SharedMedia = LibStub("LibSharedMedia-3.0", true)
		if SharedMedia then
			SharedMedia:Register("font", "Accidental Presidency",   [[Interface\AddOns\oUF_Abu\Media\Font\fontNumber.ttf]])
			SharedMedia:Register("font", "Expressway Free",         [[Interface\AddOns\oUF_Abu\Media\Font\fontSmall.ttf]])
			SharedMedia:Register("font", "Expressway RG",           [[Interface\AddOns\oUF_Abu\Media\Font\fontThick.ttf]])

			SharedMedia:Register("statusbar", "Flat", [[Interface\BUTTONS\WHITE8X8]])
			SharedMedia:Register("statusbar", "Neal", [[Interface\AddOns\oUF_Abu\Media\Texture\statusbarNeal]])
			SharedMedia:Register("statusbar", "Neal Dark", [[Interface\AddOns\oUF_Abu\Media\Texture\statusbarNealDark]])
			SharedMedia:Register("statusbar", "Flat Dark", [[Interface\AddOns\oUF_Abu\Media\Texture\Raid-Bar-Hp-Fill]])
		end
		
		self:SetupSettings()

		-- Focus Key
		if (ns.config.focBut ~= 'NONE') then
			--Blizzard raid frame
			hooksecurefunc("CompactUnitFrame_SetUpFrame", function(frame, ...)
				if frame then
					frame:SetAttribute(ns.config.focMod.."type"..ns.config.focBut, "focus")
				end
			end)
			-- World Models
			local foc = CreateFrame("CheckButton", "Focuser", UIParent, "SecureActionButtonTemplate")
			foc:SetAttribute("type1", "macro")
			foc:SetAttribute("macrotext", "/focus mouseover")
			SetOverrideBindingClick(Focuser, true, ns.config.focMod.."BUTTON"..ns.config.focBut, "Focuser")
		end

		self:UnregisterEvent(event)
		self:RegisterEvent("PLAYER_LOGOUT") -- For cleaning DB on logout

		self:RegisterEvent("MODIFIER_STATE_CHANGED") -- Showing auras
		self:RegisterEvent("PLAYER_TARGET_CHANGED") --  Target sounds
		self:RegisterEvent("PLAYER_FOCUS_CHANGED") -- Focus Sounds

		-- Setup Options
		self:SetupOptions()

		-- Skin the Countdown/BG timers:
		self:RegisterEvent("START_TIMER")

		self.ADDON_LOADED = nil
	end
end
----------------------------------------------------------------------
-- Target changed sounds
local memory = { }
local function PlayTargetSounds(unit)
	if ( UnitExists(unit) ) then
		memory[unit] = true
		if ( UnitIsEnemy(unit, "player") ) then
			PlaySound("igCreatureAggroSelect");
		elseif ( UnitIsFriend("player", unit) ) then
			PlaySound("igCharacterNPCSelect");
		else
			PlaySound("igCreatureNeutralSelect");
		end
	elseif memory[unit] then
		memory[unit] = false
		PlaySound("INTERFACESOUND_LOSTTARGETUNIT");
	end
end

function oUFAbu:PLAYER_TARGET_CHANGED(self, event, ...)
	CloseDropDownMenus()
	PlayTargetSounds('target')
end

function oUFAbu:PLAYER_FOCUS_CHANGED(self, event, ...)
	PlayTargetSounds('focus')
end

----------------------------------------------------------------------
--	Skin the blizzard Countdown Timers
function oUFAbu:START_TIMER(event)
	for _, b in pairs(TimerTracker.timerList) do
		local bar = b['bar']
		if (not bar.borderTextures) then
			bar:SetScale(1.132)
			bar:SetSize(220, 18)

			for i = 1, select('#', bar:GetRegions()) do
				local region = select(i, bar:GetRegions())

				if (region and region:GetObjectType() == 'Texture') then
					region:SetTexture(nil)
				end

				if (region and region:GetObjectType() == 'FontString') then
					region:ClearAllPoints()
					region:SetPoint('CENTER', bar)
				end
			end

			ns.CreateBorder(bar, 11, 3)

			local backdrop = select(1, bar:GetRegions())
			backdrop:SetTexture('Interface\\Buttons\\WHITE8x8')
			backdrop:SetVertexColor(0, 0, 0, 0.5)
			backdrop:SetAllPoints(bar)
		end

		bar:SetStatusBarTexture(ns.config.statusbar)
		for i = 1, select('#', bar:GetRegions()) do
			local region = select(i, bar:GetRegions())
			if (region and region:GetObjectType() == 'FontString') then
				region:SetFont(ns.config.fontNormal, 13*ns.config.fontNormalSize, ns.config.fontNormalOutline)
			end
		end
	end
end
----------------------[[	View Auras      ]]-------------------------
function oUFAbu:MODIFIER_STATE_CHANGED(event, key, state)
	if ( IsControlKeyDown() and (key == 'LALT' or key == 'RALT')) or
	   ( IsAltKeyDown() and (key == 'LCTRL' or key == 'RCTRL')) then
	   local a, b
		if state == 1 then
			a, b = "CustomFilter", "__CustomFilter"
		else
			a, b = "__CustomFilter", "CustomFilter"
		end
		for i = 1, #oUF.objects do
			local object = oUF.objects[i]
			local buffs = object.Auras or object.Buffs
			local debuffs = object.Debuffs
			if buffs and buffs[a] then
				buffs[b] = buffs[a]
				buffs[a] = nil
				buffs:ForceUpdate()
			end
			if debuffs and debuffs[a] then
				debuffs[b] = debuffs[a]
				debuffs[a] = nil
				debuffs:ForceUpdate()
			end
		end
	end
end

----------------------[[	Setup Options   ]]-------------------------
function oUFAbu:SetupOptions()
	local options = CreateFrame('Frame', 'oUFAbuOptions')
	options:Hide()
	options.name = 'oUF Abu'

	local auras = CreateFrame("Frame", 'AuraFilters', options)
	auras.name = 'Aura Filters'
	auras.parent = options.name

	options:SetScript("OnShow", function(self)
		oUFAbu:LoadOptions()
		options:SetScript("OnShow", nil)
	end)

	InterfaceOptions_AddCategory(options)
	InterfaceOptions_AddCategory(auras)

	-- Nuke cancel button - prevents taint
	InterfaceOptionsFrameCancel:Hide()
	InterfaceOptionsFrameOkay:SetAllPoints(InterfaceOptionsFrameCancel)
	InterfaceOptionsFrameCancel:SetScript("OnClick", function()
		InterfaceOptionsFrameOkay:Click()
	end)

	InterfaceOptionsUnitFramePanelPartyPets:Disable()
	InterfaceOptionsUnitFramePanelArenaEnemyFrames:Disable()
	InterfaceOptionsUnitFramePanelArenaEnemyCastBar:Disable()
	InterfaceOptionsUnitFramePanelArenaEnemyPets:Disable()
	InterfaceOptionsUnitFramePanelFullSizeFocusFrame:Disable()

	_G.SLASH_OUFABU1 = "/ouf"
	_G.SLASH_OUFABU2 = "/oufabu"
	SlashCmdList['OUFABU'] = function(...)
		self:OnSlashCommand(...)
	end
end

function oUFAbu:LoadOptions()
	if IsAddOnLoaded("oUF_AbuOptions") then return true; end

	if InCombatLockdown() then
		ns.Print(L['OptionsLoadAfterCB'])
		self:RegisterEvent("PLAYER_REGEN_ENABLED")
		return false
	end
	self:PLAYER_REGEN_ENABLED()
end

function oUFAbu:PLAYER_REGEN_ENABLED(event)
	if event then
		self:UnregisterEvent(event)
	end
	local loaded, reason = LoadAddOn('oUF_AbuOptions')
	if not loaded then
		if reason == "DISABLED" then
			EnableAddOn('oUF_AbuOptions')
			LoadAddOn('oUF_AbuOptions')
		else
			ns.Print(L['OptionsNotLoaded'], _G['ADDON_'..reason]:lower())
		end
	end
	InterfaceOptionsFrame_OpenToCategory('oUF Abu')
	InterfaceOptionsFrame_OpenToCategory('oUF Abu')
end

function oUFAbu:OnSlashCommand(command)
	if (command == "lock" or command == "unlock") then
		self:ToggleDummyFrames()
	elseif self:LoadOptions() then
		InterfaceOptionsFrame_OpenToCategory('oUF Abu')
		InterfaceOptionsFrame_OpenToCategory('oUF Abu')
	end
end

function ns.Print(...)
	if (...) then
		return print("|cffffcf00oUF_Abu: |r"..select(1, ...), select(2, ...))
	end
end
--i hate you effort
function oUFAbu:Print(...)
	return ns.Print(...)
end