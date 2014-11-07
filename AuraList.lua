local _, ns = ...
local AuraList = {}

AuraList.Immunity = {
	'1022',     -- Hand of Protection
	'642',  	-- Divine Shield (Paladin)
	'47585',   	-- Dispersion (Priest)
	'45438',    -- Ice Block
	'46924',    -- Bladestorm
}

AuraList.CCImmunity = {
	'1044',     -- Hand of Freedom
	'115018',   -- Desecrated Ground
	'31224',    -- Cloak of Shadows
	'31821',    -- Aura Mastery
	'49039',    -- Lichborne
	'51271',    -- Pillar of Frost
	'53271',    -- Master's Call
}

AuraList.Defensive = {
	'122470',   --Touch of Karma
	'110913',   -- Dark Bagrain
	'115176',   -- Zen Meditation
	'115203',   -- Fortifying Brew
	'115610',   -- Temporal Shield
	'116888',   -- Shroud of Purgatory
	'122278',   -- Dampen Harm
	'122783',   -- Diffuse Magic
	'22812',    -- Barkskin
	'30823',    -- Shamanistic Rage 
	'33206',    -- Pain Suppression
	'47788',    -- Guardian Spirit
	'48707',    -- Anti-Magic Shell
	'48792',    -- Icebound Fortitude
	'498',      -- Divine Protection
	'5277',     -- Evasion
	'61336',    -- Survival Instincts   
	'74001',    -- Combat Readiness
	'871',      -- Shield Wall
}

AuraList.Offensive = {
	'31884',    -- Avenging Wrath
	'51713',    -- Shadow Dance
	'1719',		-- Recklessness
	'12472',	-- Icy Veins
	'102342',	-- Ironbark
	'6940',     -- Hand of Sacrifice
}

AuraList.Helpful = {
	'77606',	-- Dark Simulacrum
	'106898',	-- Stampeding Roar
	'108212',	-- Burst of Speed
	'108843', 	-- Blazing Speed
	'112833',	-- Spectral Guise
	'114028',   -- Mass Spell Reflection
	'116841',	-- Tiger's Lust
	'118922',	-- Posthaste
	'1850', 	-- Dash
	'23920',    -- Spell Reflection (warrior)
	'2983',     -- Sprint
	'3411',     -- Intervene
	'66',		-- Invisibility
	'68992',    -- Darkflight (Worgen racial)
	'740',		-- Tranquility
	'77761',	-- Stampeding Roar (bear)
	'77764',	-- Stampeding Roar (cat)
	'85499',	-- Speed of Light
	'96268',	-- Death's Advance
}

AuraList.Misc = {
	'118358',	-- Drinking
}

AuraList.Stun = {
	'105593',   -- Fist of Justice
	'107570',   -- Storm Bolt
	'108194',   -- Asphyxiate
	'117526',   -- Binding Shot
	'119381',   -- Leg Sweep
	'119392',   -- Charging Ox Wave
	'1776',     -- Gouge
	'1833',     -- Cheap Shot
	'22570',    -- Maim
	'24394',    -- Intimidation
	'30283',    -- Shadowfury
	'408',      -- Kidney Shot
	'44572',    -- Deep Freeze
	'46968',    -- Shockwave
	'47481',    -- Gnaw
	'5211',     -- Bash
	'65929',    -- Charge Stun
	'6770',     -- Sap
	'853',      -- Hammer of Justice
	'87195',    -- Paralysis 
	'88625',    -- Holy Word: Chastise   
	'89766',    -- Axe Toss 
	'91797',    -- Monstrous Blow (Gnaw with DT)
}

AuraList.CC = {
	'33786',    -- Cyclone
	'102051',	-- Frostjaw
	'102359',	-- Mass Entanglement
	'10326',    -- Turn Evil
	'105421',	-- Blinding Light
	'107566',	-- Staggering Shout
	'114404',	-- Void Tendrils
	'115078',	-- Paralysis
	'116706',	-- Disable (2x)
	'118', 		-- Polymorph
	'128405',	-- Narrow Escape
	'1499',		-- Freezing Trap
	'19386',	-- Wyvern Sting
	'19387', 	-- Entrapment
	'20066',    -- Repentance
	'2094', 	-- Blind
	'31661',    -- Dragon's Breath
	'339',      -- Entangling Roots
	'45334',	-- Wild Charge
	'51514', 	-- Hex
	'5246',     -- Intimidating Shout 
	'5484', 	-- Howl of Terror
	'5782',     -- Fear
	'605', 		-- Mind Control
	'6358',     -- Seduction
	'64044',	-- Psychic Horror
	'64803',	-- Entrapment
	'6789', 	-- Death Coil
	'8122',     -- Psychic Scream
	'82691', 	-- Ring of Frost
	'8377',     -- Earthgrab
	'91807', 	-- Shambling Rush (Leap with DT)
	'99',		-- Disorienting Roar
}

AuraList.Silence = {
	'114238',   -- Fae Silence (Glyph of Fae Silence)
	'1330',     -- Garrote - Silence
	'15487',    -- Silence (priest)
	'19647',    -- Spell Lock
	'28730',    -- Arcane Torrent
	'47476',    -- Strangulate
	'58357',    -- Glyph of Gag Order
	'81261',    -- Solar Beam
}

AuraList.Taunt = {
	'56222',		-- Dark Command
	'57604',		-- Death Grip -- NEEDS CHECK 57603
	'20736',		-- Distracting Shot
	'6795',			-- Growl
	'118585',		-- Leer of the Ox
	'62124',		-- Reckoning
	'355',			-- Taunt
}

ns.AuraList = AuraList