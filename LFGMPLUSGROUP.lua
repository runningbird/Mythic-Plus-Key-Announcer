LFGMythicPlus = LibStub("AceAddon-3.0"):NewAddon("MythicPlusKeyAnnouncer", "AceConsole-3.0", "AceEvent-3.0")
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

local currentLFGResults = ''

-- Default settings for AceDB
local defaults = {
	profile = {
		messageColor = { r = 1, g = 0.76, b = 0.15 }, -- gold default
		showPopup = true,                       -- show popup by default
	}
}

-- Options table for AceConfig
local options = {
	name = "Mythic Plus Key Announcer",
	handler = LFGMythicPlus,
	type = 'group',
	args = {
		showPopup = {
			type = "toggle",
			name = "Show popup on join",
			desc = "Show a popup window when you join a Mythic+ group.",
			get = function(info)
				return LFGMythicPlus.db.profile.showPopup
			end,
			set = function(info, val)
				LFGMythicPlus.db.profile.showPopup = val
			end,
		},
		messageColor = {
			type = "color",
			name = "Message Color",
			desc = "Set the color for the group filled chat message.",
			get = function(info)
				local c = LFGMythicPlus.db.profile.messageColor
				return c.r, c.g, c.b
			end,
			set = function(info, r, g, b)
				local c = LFGMythicPlus.db.profile.messageColor
				c.r, c.g, c.b = r, g, b
			end,
		},
	},
}

-- Initialize Addon
function LFGMythicPlus:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("MythicPlusKeyAnnouncerDB", defaults, true)
	AceConfig:RegisterOptionsTable("MythicPlusKeyAnnouncer", options)
	AceConfigDialog:AddToBlizOptions("MythicPlusKeyAnnouncer", "Mythic Plus Key Announcer")
	self:RegisterChatCommand("mpk", "ChatCommand")
	self:RegisterEvent("LFG_LIST_JOINED_GROUP")
	self:RegisterEvent("GROUP_LEFT")
end

-- Helper to get hex color from db
local function GetColorHex()
	local c = LFGMythicPlus.db.profile.messageColor
	return string.format("|cff%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255)
end

-- Show popup window with group info using WoW API
local popupFrame = nil
local function ShowGroupPopup(msg)
	if popupFrame and popupFrame:IsShown() then
		popupFrame:Hide()
	end
	popupFrame = CreateFrame("Frame", nil, UIParent, "BasicFrameTemplateWithInset")
	popupFrame:SetSize(350, 100)
	popupFrame:SetPoint("CENTER")
	popupFrame.title = popupFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	popupFrame.title:SetPoint("TOP", 0, -10)
	popupFrame.title:SetText("Joined Mythic+ Group")
	popupFrame.text = popupFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	popupFrame.text:SetPoint("CENTER", 0, -10)
	popupFrame.text:SetText(msg)
	popupFrame:SetScript("OnMouseDown", function(self, button) self:StartMoving() end)
	popupFrame:SetScript("OnMouseUp", function(self, button) self:StopMovingOrSizing() end)
	popupFrame:SetMovable(true)
	popupFrame:EnableMouse(true)
	popupFrame:SetClampedToScreen(true)
	popupFrame.close = CreateFrame("Button", nil, popupFrame, "UIPanelCloseButton")
	popupFrame.close:SetPoint("TOPRIGHT", popupFrame, "TOPRIGHT")
	C_Timer.After(5, function() if popupFrame and popupFrame:IsShown() then popupFrame:Hide() end end)
end

-- Advanced /mpk handler placed after helpers so they are in scope
function LFGMythicPlus:ChatCommand(input)
	-- allow: /mpk testpopup  -> force the popup for testing
	local cmd = (input or ""):lower():match("^(%S+)")
	if cmd == "testpopup" then
		local msg = currentLFGResults
		if not msg or msg == '' then
			-- fallback test message uses a static colored string
			msg = "|cffFFD000 Mythic Plus Key Group:|r |cffDA70D6 TestDungeon:TestKey:15 |r"
		end
		ShowGroupPopup(msg)
		return
	end

	AceConfigDialog:Open("MythicPlusKeyAnnouncer")
end

-- Handle LFG Join Group Event
function LFGMythicPlus:LFG_LIST_JOINED_GROUP(event, ...)
	local searchResultID = ...
	local msg = ''

	if searchResultID then
		local searchResultInfo = C_LFGList.GetSearchResultInfo(searchResultID)
		if searchResultInfo then
			for _, activitiID in pairs(searchResultInfo.activityIDs) do
				local activityInfoTable = C_LFGList.GetActivityInfoTable(activitiID)
				msg = (GetColorHex() .. " Mythic Plus Key Group:|r |cffDA70D6  %s:%s:%s |r"):format(
					activityInfoTable.fullName,
					tostring(searchResultInfo.name), tostring(searchResultInfo.comment))
				currentLFGResults = msg
			end
		end
	end

	print(msg)
	if msg ~= '' and self.db.profile.showPopup then
		ShowGroupPopup(msg)
	end
end

-- Handle Group Leave
function LFGMythicPlus:GROUP_LEFT(event, ...)
	currentLFGResults = ''
end
