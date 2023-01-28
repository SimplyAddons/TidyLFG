local E = select(2, ...):unpack()

local ELV = _G.ElvUI and _G.ElvUI[1]
local S = ELV and ELV:GetModule("Skins")

function E:CreateTidyButton()
	E.logButton = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "GameMenuButtonTemplate"); --UIPanelButtonTemplate
	E.logButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", 2, 29);
	E.logButton:SetSize(110, 30);
	if (E:GetConfig("showLogs") == true) then
		E.logButton:SetText("Hide Tidy Logs");
	else
		E.logButton:SetText("Show Tidy Logs");
	end
	E.logButton:SetNormalFontObject("GameFontNormalSmall");
	E.logButton:SetHighlightFontObject("GameFontHighlightSmall");
	E.logButton:SetScript("OnClick", E.ToggleLogs);

	if IsAddOnLoaded("ElvUI") then
		S:HandleButton(E.logButton)
		E.logButton:ClearAllPoints()
		E.logButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", 1, 29);
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

    LFGListFrame.SearchPanel:HookScript("OnEvent", E.TidyEvent);
    hooksecurefunc("LFGListSearchEntry_Update", E.TidyUpdate);
end