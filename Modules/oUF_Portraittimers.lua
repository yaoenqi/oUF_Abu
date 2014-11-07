
local _, ns = ...
local oUF = ns.oUF or oUF

local PortraitTimerDB = { }

do
	local c = 1
	local function add(list)
		for i = 1, #list do
			PortraitTimerDB[c] = list[i]
			c = c + 1
		end
	end
	local l = ns.AuraList
	add(l.Immunity)
	add(l.Stun)
	add(l.CC)
	add(l.CCImmunity)
	add(l.Defensive)
	add(l.Offensive)
	add(l.Helpful)
	add(l.Silence)
	add(l.Misc)
end

local GetTime = GetTime
local floor, fmod = floor, math.fmod
local day, hour, minute = 86400, 3600, 60

local function ExactTime(time)
	return format("%.1f", time), (time * 100 - floor(time * 100))/100
end

local function FormatTime(s)
	if (s >= day) then
		return format('%dd', floor(s/day + 0.5))
	elseif (s >= hour) then
		return format('%dh', floor(s/hour + 0.5))
	elseif (s >= minute) then
		return format('%dm', floor(s/minute + 0.5))
	end

	return format('%d', fmod(s, minute))
end

local function AuraTimer(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed

	if (self.elapsed < 0.1) then 
		return 
	end

	self.elapsed = 0

	local timeLeft = self.expires - GetTime()
	if (timeLeft <= 0) then
		self.Remaining:SetText(nil)
	else
		if (timeLeft <= 5) then
			self.Remaining:SetText('|cffff0000'..ExactTime(timeLeft)..'|r')
		else
			self.Remaining:SetText(FormatTime(timeLeft))
		end
	end
end

local function UpdateIcon(self, texture, duration, expires)
	SetPortraitToTexture(self.Icon, texture)

	self.expires = expires
	self.duration = duration
	self:SetScript('OnUpdate', AuraTimer)
end

local Update = function(self, event, unit)
	if (self.unit ~= unit) then 
		return 
	end

	local pt = self.PortraitTimer
	for i = 1, #PortraitTimerDB do
		local spell, rank = GetSpellInfo(PortraitTimerDB[i])
		local name, _, texture, _, _, duration, expires
		if spell then
			name, _, texture, _, _, duration, expires = UnitBuff(unit, spell)
			if not name then
				name, _, texture, _, _, duration, expires = UnitDebuff(unit, spell)
			end
		end
		if name then
			UpdateIcon(pt, texture, duration, expires)

			pt:Show()

			if (self.CombatFeedbackText) then
				self.CombatFeedbackText.maxAlpha = 0
			end

			return
		else
			if (pt:IsShown()) then
				pt:Hide()
			end

			if (self.CombatFeedbackText) then
				self.CombatFeedbackText.maxAlpha = 1
			end
		end
	end
end

local Enable = function(self)
	local pt = self.PortraitTimer
	if (pt) then
		self:RegisterEvent('UNIT_AURA', Update)
		return true
	end
end

local Disable = function(self)
	local pt = self.PortraitTimer
	if (pt) then
		self:UnregisterEvent('UNIT_AURA', Update)
	end
end

oUF:AddElement('PortraitTimer', Update, Enable, Disable)