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
    --for optKey,optDesc in pairs(options) do
    for id=1, #options do
        E.optionsPanel[id] = CreateFrame("CheckButton", nil, E.optionsPanel, "UICheckButtonTemplate");
        E.optionsPanel[id]:SetPoint("TOPLEFT", relative, "LEFT", 0, -16);
        E.optionsPanel[id].text:SetText(options[id]["desc"]);
        E.optionsPanel[id]:SetChecked(E:GetConfig(options[id]["key"]));
        E.optionsPanel[id]:SetScript("OnClick", function(event)
            E:SaveConfig(options[id]["key"], event:GetChecked())
        end)
        relative = E.optionsPanel[id]
    end

	self:SetScript("OnShow", nil)
end)

InterfaceOptions_AddCategory(E.optionsPanel)