local E, Config = select(2, ...):unpack()

--[[
function E:Options()
	local options = {
		name = "TidyLFG Options",
		type = "group",
		args = {
			general = {
				type = "group",
				name = "General Settings",
				order = 1,
				args = {
					showLogs = {
						type = "toggle",
						name = "Print TidyLFG logs to chat window",
						width = "full",
						order = 1,
						get = function(info) return E:GetConfig("showLogs") end,
						set = function(info, value) E:SaveConfig("showLogs", value) end,
					},
				},
			},
			filter = {
				type = "group",
				name = "Filter Settings",
				order = 2,
				args = {
					filterUS = {
						type = "toggle",
						name = "Filter US realms from the dungeon list",
						width = "full",
						order = 1,
						get = function(info) return E:GetConfig("filterUS") end,
						set = function(info, value) E:SaveConfig("filterUS", value) end,
					},
					filterOCE = {
						type = "toggle",
						name = "Filter OCE realms from the dungeon list",
						width = "full",
						order = 2,
						get = function(info) return E:GetConfig("filterOCE") end,
						set = function(info, value) E:SaveConfig("filterOCE", value) end,
					},
					filterBrazil = {
						type = "toggle",
						name = "Filter Brazil realms from the dungeon list",
						width = "full",
						order = 3,
						get = function(info) return E:GetConfig("filterBrazil") end,
						set = function(info, value) E:SaveConfig("filterBrazil", value) end,
					},
					filterLatin = {
						type = "toggle",
						name = "Filter Latin realms from the dungeon list",
						width = "full",
						order = 4,
						get = function(info) return E:GetConfig("filterLatin") end,
						set = function(info, value) E:SaveConfig("filterLatin", value) end,
					},
				},
			},
		},
	}
	return options
end
]]

function E:Options()
	local options = {
		name = "TidyLFG Options",
		type = "group",
		args = {
			header1 = {
				type = "header",
				name = "General",
				order = 1,
			},
			showLogs = {
				type = "toggle",
				name = "Print TidyLFG logs to chat window",
				width = "full",
				order = 2,
				get = function(info) return E:GetConfig("showLogs") end,
				set = function(info, value) E:SaveConfig("showLogs", value) end,
			},
			header2 = {
				type = "header",
				name = "Filters",
				order = 3,
			},
			filterUS = {
				type = "toggle",
				name = "Filter US realms from the dungeon list",
				width = "full",
				order = 4,
				get = function(info) return E:GetConfig("filterUS") end,
				set = function(info, value) E:SaveConfig("filterUS", value) end,
			},
			filterOCE = {
				type = "toggle",
				name = "Filter OCE realms from the dungeon list",
				width = "full",
				order = 5,
				get = function(info) return E:GetConfig("filterOCE") end,
				set = function(info, value) E:SaveConfig("filterOCE", value) end,
			},
			filterBrazil = {
				type = "toggle",
				name = "Filter Brazil realms from the dungeon list",
				width = "full",
				order = 6,
				get = function(info) return E:GetConfig("filterBrazil") end,
				set = function(info, value) E:SaveConfig("filterBrazil", value) end,
			},
			filterLatin = {
				type = "toggle",
				name = "Filter Latin realms from the dungeon list",
				width = "full",
				order = 7,
				get = function(info) return E:GetConfig("filterLatin") end,
				set = function(info, value) E:SaveConfig("filterLatin", value) end,
			},
		},
	}
	return options
end
