LFGMythicPlus = LibStub("AceAddon-3.0"):NewAddon("MythicPlusKeyAnnouncer", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

local currentLFGResults = ''

-- Initialize Addon
function LFGMythicPlus:OnInitialize()
	self:RegisterChatCommand("mpk", "ChatCommand")
	self:RegisterEvent("LFG_LIST_JOINED_GROUP")
	self:RegisterEvent("GROUP_LEFT")
end

-- Handle Chat Commands if non arg then show the UI
function LFGMythicPlus:ChatCommand()
	--if not currentLFGResults == '' then
	print(currentLFGResults)
	--end
end

-- Handle LFG Join Group Event
function LFGMythicPlus:LFG_LIST_JOINED_GROUP(event, ...)
	local searchResultID = ...
	local msg = ''

	if searchResultID then
		--local id, activityID, name, comment, voiceChat, iLvl, honorLevel, age, numBNetFriends, numCharFriends, numGuildMates, isDelisted, author, members, autoinv = C_LFGList.GetSearchResultInfo(searchResultID)
		local searchResultInfo = C_LFGList.GetSearchResultInfo(searchResultID)
		if searchResultInfo then
			--Get the Activity Information
			--fullName, shortName, categoryID, groupID, itemLevel, filters, minLevel, maxPlayers, displayType, orderIndex, useHonorLevel = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID)
			local activityInfo = C_LFGList.GetActivityInfoTable(searchResultInfo.activityID) -- activityID, questID, showWarmode
			msg = ("|cffFFC125 Mythic Plus Key Group:|r |cffDA70D6  %s:%s:%s |r"):format(activityInfo.fullName,
				tostring(searchResultInfo.name), tostring(searchResultInfo.comment))
			currentLFGResults = msg
		end
	end

	print(msg)
end

-- Handle Group Leave
function LFGMythicPlus:GROUP_LEFT(event, ...)
	currentLFGResults = ''
end
