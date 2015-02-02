local _, ns = ...
if ns.locale ~= "ztTW" then return; end
local L = ns.L

--  [[ 		Main Addon 		]]  --
--	L.OptionsLoadAfterCombat = 'Options will be loaded after combat!'
--	L.AuraAdded = 'Spell "%s" (%d) was added to the aura filter.'
--	L.AuraExists = 'Spell "%s" (%d) already exists'
--	L.Anchors_Unlocked = "Frames unlocked."
--	L.Anchors_Locked = "Frames locked."
--	L.Anchors_tooltipline1 = "Hold SHIFT to drag"
--	L.Anchors_tooltipline2 = "ALT-click to reset position"
--	L.Anchors_InCombat = "Can't unlock frames in combat."

--  [[		OPTIONS 		]] --
	L.ReloadUIWarning_Desc = "你的改動需要重載 \n 界面來完全生效,重載?"
	L.NoEffectUntilRL = "這些設置將在重載后生效."

	---- PROFILES
	L.EnterProfileName = "輸入配置文件名"

	---- AURA PANEL
	L.AuraFilters = "光環過濾器"

	L.AuraFilterGeneralDesc = "添加一個到新光環或編輯現有的."
	L.AllFrames = "所有框體"

	L.AuraFilterArenaDesc = "競技場框體增益白名單."
	L.ArenaFrames = "競技場框體"

	L.AuraFilterBossDesc = "Boss框體減益白名單."
	L.BossFrames = "Boss框體"

	L.ShowAll = "顯示所有"
	L.OnlyOwn = "僅自己的"
	L.HideOnFriendly = "隱藏友方"
	L.NeverShow = "從不顯示"

	--L.Auras_EnterSpellID = "Enter a Spell ID"
	--L.Auras_AlreadyAdded = "Already added!"
	--L.Auras_InvalidSpellID = "Invalid Spell ID!"

	---- GENERAL PANEL
	L.General = "基本"

	L.General_ClassModule = "啓用默認職業模塊"
	L.General_ClassModuleTip = "爲你的職業啓用暴雪模塊."
	L.General_Party = "啓用小隊框體"
	L.General_PartyInRaid = "团隊中顯示小隊框體"
	L.General_Arena = "啓用競技場框體"
	L.General_Boss = "啓用Boss框體"
	L.General_Castbars = "啓用施法條"
	L.General_Ticks = "顯示引導法術頻率"
	L.General_PTimer = "顯示頭像計時"
	L.General_Feedback = "顯示戰鬥反饋"
	L.General_Threat = "啓用仇恨發光"
	L.General_OnlyPlayer = "只對玩家減益着色"
	L.General_AuraTimer = "顯示光環計時器"
	L.General_AuraTimerTip = "禁用内置光環計時器"
	L.General_Click = "點擊穿過框體"
	L.General_ClickTip = "使框體可以點擊穿過."
	L.General_ModKey = "焦點組合按鍵"
	L.General_ModButton = "焦點鼠標按鍵"
	L.General_Absorb = "啓用吸收量條"
	L.General_AbsorbTip = "爲一個單位顯示一個總吸收量條."
	L.General_ClassP = "啓用職業圖標頭像"
	L.General_ClassPTip = "顯示一個職業圖標替代玩家頭像."
	L.General_Resolve = "啓用堅毅條"
	L.General_ResolveTip = "爲防護戰士在玩家框體上顯示一個堅毅條."
	L.General_Enrage = "啓用戰士怒氣條"
	L.General_EnrageTip = "爲狂怒戰士在玩家框體上顯示一個怒氣條."
	L.General_WSBar = "啓用虛弱靈魂條"
	L.General_WSBarTip = "爲牧師顯示一個虛弱靈魂條."
	L.General_Arcane = "啓用法師奧術充能"
	L.General_ArcaneTip = "顯示一個奧術充能计數器."
	L.General_SnD = "啓用切割條"
	L.General_SnDTip = "顯示一個切割條."
	L.General_Ant = "顯示預感層數"
	L.General_AntTip = "顯示預感连擊點數."
	L.General_Shrooms = "顯示蘑菇圖標"
	L.General_ShroomsTip = "顯示圖標材質代替純文本."

	---- TEXTURES,
	L.Texture = "材質"
	L.Texture_Statusbar = "狀態條材質"
	L.Texture_Frames = "框體"
	L.Texture_Path = "自定義材質路徑"

	L.Texture_Player = "玩家框體樣式"
	L.Texture_Normal = "正常"
	L.Texture_NormalTip = "正常的玩家框體"
	L.Texture_Rare = "稀有"
	L.Texture_RareTip = "玩家框體使用稀有樣式"
	L.Texture_Elite = "精英"
	L.Texture_EliteTip = "玩家框體使用精英樣式"
	L.Texture_RareElite = "稀有精英"
	L.Texture_RareEliteTip = "玩家框體使用稀有精英樣式"
	L.Texture_Custom = "自定義"
	L.Texture_CustomTip = "自定義玩家框體"

	-- COLORS:
	L.Color_Class = "職業顏色"
	L.Color_ClassTip = "使用職業顏色"
	L.Color_Gradient = "漸變顏色"
	L.Color_GradientTip ="使用從綠色到紅色的漸變"
	L.Color_Custom = "自定義顏色"
	L.Color_CustomTip = "使用一個自定義顏色"
	L.Color_Power = "能量顏色"
	L.Color_PowerTip = "使用能量類型的顏色"

	L.Color_Frame = "框體覆蓋顏色"
	L.Color_Latency = "施法條延遲顏色"
	L.Color_Backdrop = "背景顏色"

	L.Color_Health = "生命顏色"
	L.Color_HealthCustom = "自定義生命顏色"
	L.Color_Power = "能量顏色"
	L.Color_PowerCustom = "自定義能量顏色"

	L.Color_NameText = "名字文本顏色"
	L.Color_NameTextCustom = "自定義名字文本顏色"
	L.Color_HealthText = "生命值文本顏色"
	L.Color_HealthTextCustom = "自定義生命值文本顏色"
	L.Color_PowerText = "能量值文本顏色"
	L.Color_PowerTextCustom = "自定義能量值文本顏色"

	---- FONTS
	L.Font = "字體"
	L.Font_Outline = "輪廓"
	L.Font_ThinOutline = "細輪廓"
	L.Font_ThickOutline = "粗輪廓"
	L.Font_OutlineMono = "單色"
	L.Font_Number = "數字字體"
	L.Font_NumberSize = "數字字體大小"
	L.Font_NumberOutline = "數字輪廓類型"
	L.Font_Name = "名字字體"
	L.Font_NameSize = "名字字體大小"
	L.Font_NameOutline = "名字輪廓類型"

	---- POSITIONS
--	L.Positions = "Positions"
--	L.Positions_Name = "Unit Frame"
--	L.Positions_X = "Horizontal [x]"
--	L.Positions_Y = "Vertical [y]"
--	L.Positions_Point = "Point"
--	L.Positions_Toggle = "Toggle Anchors"

	---- UNITS
	L.Tag_Numeric = "數值"
	L.Tag_Both = "同時"
	L.Tag_Percent = "百分比"
	L.Tag_Minimal = "最小"
	L.Tag_Deficit = "損失"
	L.Tag_Disable = "禁用"
	L.Tag_NumericTip = "顯示數值"
	L.Tag_BothTip = "同時顯示百分比和數值"
	L.Tag_PercentTip = "顯示百分比"
	L.Tag_MinimalTip = "顯示百分比,最大時隱藏"
	L.Tag_DeficitTip = "顯示一個損失數值"
	L.Tag_DisableTip = "禁用這個框體的文本"

	L.Icon_DontShow = "不顯示"
	L.Icon_Left = "圖標在左側"
	L.Icon_Right = "圖標在右側"

	L.Fat = "加厚"
	L.Normal = "正常"

	L.TOP = "顶部"
	L.BOTTOM = "底部"
	L.LEFT = "左側"
--	L.CENTER = "Center"
--	L.RIGHT = "Right"

	L.player = PLAYER
	L.target = TARGET
	L.targettarget = "目標的目標"
	L.pet = PET
	L.focus = "焦點"
	L.focustarget = "焦點的目標"
	L.party = PARTY
	L.boss = BOSS
	L.arena = ARENA

	L.Scale = "縮放"
	L.Style = "樣式"
	L.EnableAuras = "啓用光環"
	L.EnableAuraTip = "爲這個單位啓用光環"
	L.BuffPos = "增益位置"
	L.DebuffPos = "減益位置"

	L.Castbar = "施法條"
	L.ShowCastbar = "顯示施法條"
	L.ShowCastbarTip = "爲這個單位顯示施法條"
	L.Width = "寬度"
	L.Height = "高度"
	L.CastbarIcon = "施法條圖標"
	L.HoriPos = "水平位置"
	L.VertPos = "垂直位置"

	L.TextHealthTag = "生命值文本"
	L.TextPowerTag = "能量值文本"

	L.UnitSpecific = "單位細節"