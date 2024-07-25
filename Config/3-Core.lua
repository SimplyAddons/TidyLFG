local E = select(2, ...):unpack()

function E:InitOptions()
	-- Create options panel frame
	E.optionsPanel = CreateFrame("Frame", nil, UIParent)
	E.optionsPanel.name = E.AddOn
	E.optionsPanel:Hide()

	-- Create button frames
	-- note: we attach the options to the panel now, rather than onShow,
    -- to prevent errors if the user attempts to toggle the logs before
    -- opening the options window
	local options = E:Options()
	for id=1, #options do
		E.optionsPanel[options[id]["key"]] = CreateFrame("CheckButton", nil, E.optionsPanel, "UICheckButtonTemplate")
	end

	E.optionsPanel:SetScript("OnShow", function(self)
		-- Grab our options
		local options = E:Options()

		-- Title
		local title = E.optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", 16, -16)
		title:SetText(E.AddOn .. ' Options')

		-- Render options
		local relative = title
		for id=1, #options do
			E.optionsPanel[options[id]["key"]]:SetPoint("TOPLEFT", relative, "LEFT", 0, -16)
			E.optionsPanel[options[id]["key"]].text:SetText(options[id]["desc"])
			E.optionsPanel[options[id]["key"]]:SetChecked(E:GetConfig(options[id]["key"]))
			E.optionsPanel[options[id]["key"]]:SetScript("OnClick", function(event)
				E:SaveConfig(options[id]["key"], event:GetChecked())
			end)
			relative = E.optionsPanel[options[id]["key"]]
		end

		-- Unregister to avoid repeated rendering of the addon options
		self:SetScript("OnShow", nil)
	end)

	-- Register the options panel using the new Settings API
	local function addOptionsCategory()
		Settings.RegisterAddOnCategory(E.optionsPanel)
	end

	if C_AddOns.IsAddOnLoaded("Blizzard_OptionsUI") then
		addOptionsCategory()
	else
		local f = CreateFrame("Frame")
		f:RegisterEvent("ADDON_LOADED")
		f:SetScript("OnEvent", function(_, _, addon)
			if addon == "Blizzard_OptionsUI" then
				f:UnregisterEvent("ADDON_LOADED")
				addOptionsCategory()
			end
		end)
	end
end