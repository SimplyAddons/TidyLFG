local E = select(2, ...):unpack()

local ELV = _G.ElvUI and _G.ElvUI[1]
local S = ELV and ELV:GetModule("Skins")

function E:CreateTidyButton()
	E.logButton = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "GameMenuButtonTemplate"); --UIPanelButtonTemplate
	E.logButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", -25, 29);
	E.logButton:SetSize(110, 30);
	if (E:GetConfig("showLogs") == true) then
		E.logButton:SetText("Hide Tidy Logs");
	else
		E.logButton:SetText("Show Tidy Logs");
	end
	E.logButton:SetNormalFontObject("GameFontNormalSmall");
	E.logButton:SetHighlightFontObject("GameFontHighlightSmall");
	E.logButton:SetScript("OnClick", E.ToggleLogButton);
	if IsAddOnLoaded("ElvUI") then
		S:HandleButton(E.logButton)
		E.logButton:ClearAllPoints()
		E.logButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", -29, 29);
	end
end

function E:OpenOptions()
	InterfaceOptionsFrame_OpenToCategory(E.AddOn)
end

function E:CreateConfigButton()
	E.configButton = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "GameMenuButtonTemplate"); --UIPanelButtonTemplate
	E.configButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", 2, 29);
	E.configButton:SetSize(30, 30);
	E.configButton:SetText("|T311226:24:24:0:0|t");
	E.configButton:SetNormalFontObject("GameFontNormalSmall");
	E.configButton:SetHighlightFontObject("GameFontHighlightSmall");
	E.configButton:SetScript("OnClick", E.OpenOptions);
	if IsAddOnLoaded("ElvUI") then
		S:HandleButton(E.configButton)
		E.configButton:ClearAllPoints()
		E.configButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", 1, 29);
	end
end

function E:OnInitialize()
	local defaults = {
		global = {
			loginMessage = false,
			showLogs = false,
			filterUS = false,
			filterOCE = false,
			filterBrazil = false,
			filterLatin = false,
		}
	}
    self.DB = LibStub("AceDB-3.0"):New("TidyLFGDB", defaults, true)
end

function E:OnEnable()

	if (E:GetConfig("loginMessage") == true) then
		print(self.LoginMessage)
	end

    E:CreateTidyButton()
	E:CreateConfigButton()
	E:InitOptions()

    LFGListFrame.SearchPanel:HookScript("OnEvent", E.TidyEvent);
    hooksecurefunc("LFGListSearchEntry_Update", E.TidyUpdate);
end
