local E = select(2, ...):unpack()

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

local function TableFind(table, tableId)
    for index, value in pairs(table) do
        if value == tableId then
            return index
        end
    end
end

function E:UpdateLogButton(state)
	if (state == true) then
		E.logButton:SetText("Hide Tidy Logs");
	else
		E.logButton:SetText("Show Tidy Logs");
	end
end

function E:ToggleLogButton()
	if (E:GetConfig("showLogs") == true) then
		E:SaveConfig("showLogs", false);
		E.optionsPanel["showLogs"]:SetChecked(false);
		E.logButton:SetText("Show Tidy Logs");
	else
		E:SaveConfig("showLogs", true);
		E.optionsPanel["showLogs"]:SetChecked(true);
		E.logButton:SetText("Hide Tidy Logs");
	end
end

function E:TidyEvent(self, event, ...)
	E:UpdateLogButton(E:GetConfig("showLogs"))
    if ( event == "LFG_LIST_SEARCH_RESULT_UPDATED" ) then
		if( LFGListFrame.SearchPanel:IsShown() ) then
			LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel)
		end
    end
end

-- unfortunately Blizzard decided to make the name, comment, and voice details protected
-- this means we cannot utilize traditional methods of matching string patterns in order
-- to identify advertisments and other cruft in the LFG tool
function E:TidyUpdate()

	if( not LFGListFrame.SearchPanel:IsShown() ) then return; end

	-- Disable automatic group titles to prevent tainting errors
    LFGListEntryCreation_SetTitleFromActivityInfo = function(_) end

	local showLogs = E:GetConfig("showLogs")
	
	local resultInfo = C_LFGList.GetSearchResultInfo(self.resultID);
	local leaderName = resultInfo.leaderName; -- name of party leader

	-- the leaderName isn't always immediately available
	-- most notably if the group is too fresh
	-- as such, we should wait until the leaderName is available
	if( not leaderName or leaderName == nil) then return; end

	-- show premade group by default
	self.removeResult = false

	-- fetch some group details
	local name = self.Name:GetText(); -- name of group
	local comment = resultInfo.comment; -- group comment/description
	local voice = resultInfo.voiceChat; -- if group has voice chat option enabled
	local ageMinutes = math.floor(resultInfo.age / 60); -- age in minutes
	local numMembers = resultInfo.numMembers; -- number of members in group

	-- determine server name
	local serverName = string.match(leaderName, "-(.*)")
	if ( not serverName or serverName == nil ) then serverName = GetRealmName(); end -- if serverName is nil, it means it's our own server

	-- filter out any groups with configured leaders
	if(E:GetConfig("filterOCE") == true) then
		for i = 1, #E.REALMS_OCE do
			if strfind(serverName, E.REALMS_OCE[i]) then
				self.removeResult = true;
				if (showLogs == true) then
					print("|cFF1784d1TidyLFG|r: Oceanic leader detected. ("..name..") ("..leaderName..")");
				end
			end
		end
	end
	if(E:GetConfig("filterBrazil") == true) then
		for i = 1, #E.REALMS_BRAZIL do
			if strfind(serverName, E.REALMS_BRAZIL[i]) then
				self.removeResult = true;
				if (showLogs == true) then
					print("|cFF1784d1TidyLFG|r: Brazil leader detected. ("..name..") ("..leaderName..")");
				end
			end
		end
	end
	if(E:GetConfig("filterLatin") == true) then
		for i = 1, #E.REALMS_LATIN do
			if strfind(serverName, E.REALMS_LATIN[i]) then
				self.removeResult = true;
				if (showLogs == true) then
					print("|cFF1784d1TidyLFG|r: Latin leader detected. ("..name..") ("..leaderName..")");
				end
			end
		end
	end
	if(E:GetConfig("filterUS") == true) then
		local matched = {}
		for i = 1, #E.REALMS_US do
			if strfind(serverName, E.REALMS_US[i]) then
				table.insert(matched, serverName)
			end
		end
		if next(matched) == nil then
			self.removeResult = true;
			if (showLogs == true) then
				print("|cFF1784d1TidyLFG|r: US leader detected. ("..name..") ("..leaderName..")");
			end
		end
	end

	-- filter groups which were created over 45 minutes ago
	-- it is unlikely a genuine group will sit around in LFG for that long
	if (self.removeResult == false and ageMinutes > 45) then
		self.removeResult = true;
		if (showLogs == true) then
			print("|cFF1784d1TidyLFG|r: Advertisement detected. ("..name..")");
		end
	end

	-- filter groups which have voice comments and only 1 member
	-- this is common for advertisers who use voice comments to link their website URL
	if (self.removeResult == false and voice ~= "") then
		if (numMembers < 2) then
			self.removeResult = true;
			if (showLogs == true) then
				print("|cFF1784d1TidyLFG|r: Advertisement detected. ("..name..")");
			end
		end
	end

	local dungeonResults = LFGListFrame.SearchPanel.results
	if (self.removeResult == true) then
		-- note: TableFind must be a local function
		-- otherwise an error is thrown
		table.remove(dungeonResults, TableFind(dungeonResults, self.resultID));
		LFGListSearchPanel_UpdateResults(LFGListFrame.SearchPanel);
	end
end
