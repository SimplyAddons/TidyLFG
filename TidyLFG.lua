local showLogs = false;

-- convenient shorthand for the /reload command
SLASH_RELOADUI1 = "/rl";
SlashCmdList["RELOADUI"] = ReloadUI;

-- convenient command for enabling blizzard debug tools
SLASH_FRAMESTK1 = "/fs";
SlashCmdList["FRAMESTK"] = function()
	LoadAddOn("Blizzard_DebugTools");
	FrameStackTooltip_Toggle();
end

-- oceanic realms
local realmsOCE = {
	"Aman'Thul",
	"Barthilas",
	"Caelestrasz",
	"Dath'Remar",
	"Dreadmaul",
	"Frostmourne",
	"Gundrak",
	"Jubei'Thos",
	"Khaz'goroth",
	"Nagrand",
	"Saurfang",
	"Thaurissan"
}

local function tablefind(tab, el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
end

local function toggleLogs(self)
	if (showLogs == true) then
		showLogs = false;
		LFGListFrame.SearchPanel.logBtn:SetText("Show Tidy Logs");
	else
		showLogs = true;
		LFGListFrame.SearchPanel.logBtn:SetText("Hide Tidy Logs");
	end
end

-- Overwrite C_LFGList.GetPlaystyleString with a custom implementation because the original function is
-- hardware protected, causing an error when a group tooltip is shown as we modify the search result list.
-- Original code from https://github.com/ChrisKader/LFMPlus/blob/36bca68720c724bf26cdf739614d99589edb8f77/core.lua#L38
-- but sligthly modified.
C_LFGList.GetPlaystyleString = function(playstyle, activityInfo)
	if not (
		activityInfo and
		playstyle and
		playstyle ~= 0 and
		C_LFGList.GetLfgCategoryInfo(activityInfo.categoryID).showPlaystyleDropdown
	) then
		return nil
	end
	local globalStringPrefix
	if activityInfo.isMythicPlusActivity then
		globalStringPrefix = "GROUP_FINDER_PVE_PLAYSTYLE"
	elseif activityInfo.isRatedPvpActivity then
		globalStringPrefix = "GROUP_FINDER_PVP_PLAYSTYLE"
	elseif activityInfo.isCurrentRaidActivity then
		globalStringPrefix = "GROUP_FINDER_PVE_RAID_PLAYSTYLE"
	elseif activityInfo.isMythicActivity then
		globalStringPrefix = "GROUP_FINDER_PVE_MYTHICZERO_PLAYSTYLE"
	end
	return globalStringPrefix and _G[globalStringPrefix .. tostring(playstyle)] or nil
end

function init(self, event, arg1)
	if (event == "PLAYER_LOGIN") then
		LFGListFrame.SearchPanel.logBtn = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "GameMenuButtonTemplate");
		LFGListFrame.SearchPanel.logBtn:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", -50, -32);
		LFGListFrame.SearchPanel.logBtn:SetSize(110, 20);
		LFGListFrame.SearchPanel.logBtn:SetText("Show Tidy Logs");
		LFGListFrame.SearchPanel.logBtn:SetNormalFontObject("GameFontNormalSmall");
		LFGListFrame.SearchPanel.logBtn:SetHighlightFontObject("GameFontHighlightSmall");
		LFGListFrame.SearchPanel.logBtn:SetScript("OnClick", toggleLogs);		
		LFGListFrame.SearchPanel:HookScript("OnEvent", tidyEvent);
		hooksecurefunc("LFGListSearchEntry_Update", tidyUpdate);
		self:UnregisterEvent("PLAYER_LOGIN");
	end
end

-- unfortunately Blizzard decided to make the name, comment, and voice details protected
-- this means we cannot utilize traditional methods of matching string patterns in order
-- to identify advertisments and other cruft in the LFG tool
function tidyUpdate(group, ...)
	if( not LFGListFrame.SearchPanel:IsShown() ) then return; end

	-- Disable automatic group titles to prevent tainting errors
    LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end
	
	local resultID = group.resultID;
	local resultInfo = C_LFGList.GetSearchResultInfo(resultID);
	local leaderName = resultInfo.leaderName; -- name of party leader

	-- the leaderName isn't always immediately available
	-- most notably if the group is too fresh
	-- as such, we should wait until the leaderName is available
	if( not leaderName or leaderName == nil) then return; end

	-- show premade group by default
	group.tidy = false

	-- fetch some group details
	local name = group.Name:GetText(); -- name of group
	local comment = resultInfo.comment; -- group comment/description
	local voice = resultInfo.voiceChat; -- if group has voice chat option enabled
	local ageMinutes = math.floor(resultInfo.age / 60); -- age in minutes
	local numMembers = resultInfo.numMembers; -- number of members in group

	-- determine server name
	local serverName = string.match(leaderName, "-(.*)")
	if ( not serverName or serverName == nil ) then serverName = GetRealmName(); end -- if serverName is nil, it means it's our own server

	-- filter out any groups with Oceanic leaders
	-- we do this as we would otherwise be phased to oceanic realms
	-- resulting in high latency/ping, rendering the game unplayable
	for i = 1, #realmsOCE do
		if strfind(serverName, realmsOCE[i]) then
			group.tidy = true;
			if (showLogs == true) then
				print("|cFF1784d1TidyLFG|r: Oceanic leader detected. ("..name..") ("..leaderName..")");
			end
		end
	end

	-- filter groups which were created over 45 minutes ago
	-- it is unlikely a genuine group will sit around in LFG for that long
	if (group.tidy == false and ageMinutes > 45) then
		group.tidy = true;
		if (showLogs == true) then
			print("|cFF1784d1TidyLFG|r: Advertisement detected. ("..name..")");
		end
	end

	-- filter groups which have voice comments and only 1 member
	-- this is common for advertisers who use voice comments to link their website URL
	if (group.tidy == false and voice ~= "") then
		if (numMembers < 2) then
			group.tidy = true;
			if (showLogs == true) then
				print("|cFF1784d1TidyLFG|r: Advertisement detected. ("..name..")");
			end
		end
	end
	
	local tlResults = LFGListFrame.SearchPanel.results;
	if (group.tidy == true) then
		table.remove(tlResults, tablefind(tlResults, resultID));
		LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel);
	end
end

function tidyEvent(self, event, ...)
    if ( event == "LFG_LIST_SEARCH_RESULT_UPDATED" ) then
		if( LFGListFrame.SearchPanel:IsShown() ) then
			LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
		end
    end
end

local events = CreateFrame("Frame");
events:RegisterEvent("ADDON_LOADED");
events:RegisterEvent("PLAYER_LOGIN");
events:SetScript("OnEvent", init);