local E = select(2, ...):unpack()

E.optionsPanel = CreateFrame("Frame", nil, UIParent)
E.optionsPanel.name = E.AddOn
E.optionsPanel:Hide()

E.optionsPanel:SetScript("OnShow", function(self)

    -- grab our options
    local options = E:Options()

    -- title
    local title = E.optionsPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge");
	title:SetPoint("TOPLEFT", 16, -16);
	title:SetText(E.AddOn .. ' Options');

    -- render options
    local relative = title
    for id=1, #options do
        E.optionsPanel[options[id]["key"]] = CreateFrame("CheckButton", nil, E.optionsPanel, "UICheckButtonTemplate");
        E.optionsPanel[options[id]["key"]]:SetPoint("TOPLEFT", relative, "LEFT", 0, -16);
        E.optionsPanel[options[id]["key"]].text:SetText(options[id]["desc"]);
        E.optionsPanel[options[id]["key"]]:SetChecked(E:GetConfig(options[id]["key"]));
        E.optionsPanel[options[id]["key"]]:SetScript("OnClick", function(event)
            E:SaveConfig(options[id]["key"], event:GetChecked())
        end)
        relative = E.optionsPanel[options[id]["key"]]
    end

    -- unregister so we dont repeatedly
    -- render the addon options
	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(E.optionsPanel)