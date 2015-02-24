local _, ns = ...
local L = ns.L

local floor, format = floor, string.format
local MINUTE = 60

local function GetTimes(remaining)
	if remaining < MINUTE then
		if remaining < 3 then -- this 2.5 usually
			return format('%.1f', remaining), 0.051
		end
		local mSecLeft = remaining % 1
		return floor(remaining + .5), mSecLeft > .5 and mSecLeft - .49 or mSecLeft + 0.51

	elseif remaining < 10*MINUTE then
		local secLeft = remaining % MINUTE
		if remaining < 90 then
			return format('%dm', floor(remaining/MINUTE + 0.5)), secLeft + .51
		end
		return format('%dm', floor(remaining/MINUTE + 0.5)), secLeft > 30 and secLeft - 29 or secLeft + 31

	else -- Hide timers longer than 10 minutes
		return '', (remaining % MINUTE) + 31
	end
end

local function UpdateAura( button, elapsed )
	if not (button.timeLeft) then return; end
	button.timeLeft = button.timeLeft - elapsed

	if button.nextupdate > 0 then
		button.nextupdate = button.nextupdate - elapsed
		return;
	end

	if (button.timeLeft <= 0) then
		button.timer:SetText('')
		button:SetScript("OnUpdate", nil)
		return;
	end

	local text
	text, button.nextupdate = GetTimes(button.timeLeft)
	button.timer:SetText(text)
end

local function Aura_OnClick(self)
	if not ( IsControlKeyDown() and IsAltKeyDown() ) then return end
	local id = self.spellID
	if id then
		local db = 'general' -- fix this someday
		local name = GetSpellInfo(id)
		if oUFAbu:GetAuraSettings()[db][id] then
			ns.Print(format(L['AuraExists'], name, id))
		else
			ns.Print(format(L['AuraAdded'], name, id ))
			oUFAbu:GetAuraSettings()[db][id] = 0
		end
	end 
	oUFAbu:UpdateAuraLists()
end

local function fixCooldownFlash(self, start, duration)
	if (self.duration == duration) then return; end
	self.duration = duration
	self:_SetCooldown(start, duration)
end

function ns.PostCreateAuraIcon( element, button )
	button:SetFrameLevel(1)
	button.overlay:SetTexture(ns.config.auraBorder, 'BORDER')
	button.overlay:SetTexCoord(0, 1, 0, 1)
	button.overlay:ClearAllPoints()
	button.overlay:SetPoint('TOPRIGHT', button.icon, 1.35, 1.35)
	button.overlay:SetPoint('BOTTOMLEFT', button.icon, -1.35, -1.35)

	button.Shadow = button:CreateTexture(nil, 'BACKGROUND')
	button.Shadow:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -4, 4)
	button.Shadow:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 4, -4)
	button.Shadow:SetTexture(ns.config.auraShadow)
	button.Shadow:SetVertexColor(0, 0, 0, 1)

	if element.gap and not element.PostUpdateGapIcon then
		element.PostUpdateGapIcon = function(element, unit, icon, visibleBuffs)
			icon.Shadow:Hide()
		end
	end

	button.count:SetFont(ns.config.fontNormal, 11, 'THINOUTLINE')
	button.count:SetShadowOffset(0, 0)
	button.count:SetPoint('BOTTOMRIGHT', 2, 0)
	tinsert(ns.fontstrings, button.count)

	button.cd:SetReverse(true)
	button.cd:SetDrawEdge(true)
	button.cd:ClearAllPoints()
	button.cd:SetPoint('TOPRIGHT', button.icon, 'TOPRIGHT', -1, -1)
	button.cd:SetPoint('BOTTOMLEFT', button.icon, 'BOTTOMLEFT', 1, 1)

	if (element.__owner.onUpdateFrequency) then -- Fix the blinking cooldown on "invalid" units
		button.cd._SetCooldown = button.cd.SetCooldown
		button.cd.SetCooldown = fixCooldownFlash
	end

	if ns.config.useAuraTimer then
		button.cd.noCooldownCount = true
		if button.cd.SetHideCountdownNumbers then
			button.cd:SetHideCountdownNumbers(true)
		end
		button.timer = ns.CreateFontString(button.cd, 12, 'CENTER', 'THINOUTLINE')
		button.timer:SetPoint("CENTER", button, "TOP", 0, 0)
	end

	button:RegisterForClicks("LeftButtonUp")
	button:SetScript("OnClick", Aura_OnClick)

	element.showStealableBuffs = true
	button.stealable:SetDrawLayer("OVERLAY", 1)

	button.icon:SetTexCoord(0.03, 0.97, 0.03, 0.97)
end

function ns.PostUpdateAuraIcon( element, unit, button, index, offset )
	local name, _, texture, count, dtype, duration, expirationTime, caster, canStealOrPurge, shouldConsolidate, spellID = UnitAura(unit, index, button.filter)
	button:EnableMouse(not ns.config.clickThrough)
	button.overlay:Show()
	button.Shadow:Show()

	if (button.isDebuff) then
		local color = DebuffTypeColor[dtype] or DebuffTypeColor['none']
		button.overlay:SetVertexColor(color.r, color.g, color.b)
	else
		local color = ns.config.frameColor
		button.overlay:SetVertexColor(color[1], color[2], color[3])
	end

	button.spellID = spellID

	if ns.config.colorPlayerDebuffsOnly and unit == 'target' and button.isDebuff and not button.isPlayer then
		button.icon:SetDesaturated(true)
	else
		button.icon:SetDesaturated(false)
	end

	if ( button.cd.noCooldownCount ) then
		if ( duration and duration > 0 ) then
			if (not button.timer:IsShown()) then
				button.timer:Show()
			end
			local text
			button.timeLeft = expirationTime - GetTime()
			text, button.nextupdate = GetTimes(button.timeLeft)
			button.timer:SetText(text)
			button:SetScript('OnUpdate', UpdateAura)
		else
			if (button.timer:IsShown()) then
				button.timer:Hide()
			end
			button.timeLeft = 0
			button:SetScript('OnUpdate', nil)
		end
	end
end

function ns.PostUpdateAuras(self, unit)
	self:GetParent().Health:ForceUpdate()
end