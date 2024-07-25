local E = select(2, ...):unpack();

local AceGUI = LibStub("AceGUI-3.0")
local ELV = _G.ElvUI and _G.ElvUI[1]
local S = ELV and ELV:GetModule("Skins")

function E:CreateTidyButton()
	-- Create a container frame for the button
	local container = CreateFrame("Frame", nil, LFGListFrame.SearchPanel)
	container:SetSize(110, 30)
	container:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", -25, 29)

	-- Create the AceGUI button
	local button = AceGUI:Create("Button")
	button:SetWidth(110)
	button:SetHeight(30)

	-- Set the button text based on the current config
	if E:GetConfig("showLogs") then
		button:SetText("Hide Tidy Logs")
	else
		button:SetText("Show Tidy Logs")
	end

	-- Define the button's OnClick behavior
	button:SetCallback("OnClick", function()
		E:ToggleLogButton()
		-- Update the button text after toggling
		if E:GetConfig("showLogs") then
			button:SetText("Hide Tidy Logs")
		else
			button:SetText("Show Tidy Logs")
		end
	end)

	-- Add the AceGUI button to the container frame
	button.frame:SetParent(container)
	button.frame:SetPoint("CENTER", container, "CENTER")
	button.frame:Show()
	
	E.logButton = button
end

function E:OpenOptions()
	if Settings and Settings.OpenToCategory then
		Settings.OpenToCategory(E.AddOn);
	else
		print("Error: Unable to open options. The settings API is not available.");
	end
end

function E:CreateConfigButton()
	E.configButton = CreateFrame("Button", nil, LFGListFrame.SearchPanel, "GameMenuButtonTemplate"); --UIPanelButtonTemplate
	E.configButton:SetPoint("TOPRIGHT", LFGListFrame.SearchPanel, "TOPRIGHT", 2, 29);
	E.configButton:SetSize(30, 30);
	E.configButton:SetText("|T311226:24:24:0:0|t");
	E.configButton:SetNormalFontObject("GameFontNormalSmall");
	E.configButton:SetHighlightFontObject("GameFontHighlightSmall");
	E.configButton:SetScript("OnClick", E.OpenOptions);
	if C_AddOns.IsAddOnLoaded("ElvUI") then
		S:HandleButton(E.configButton);
		E.configButton:ClearAllPoints();
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
	};
	self.DB = LibStub("AceDB-3.0"):New("TidyLFGDB", defaults, true);

	E:TaintFixes();

	-- Check if options are already registered
	if not E.optionsRegistered then
		LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("TidyLFG", E:Options());
		self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TidyLFG", "TidyLFG");
		E.optionsRegistered = true;
	end
end

function E:OnEnable()
	if (E:GetConfig("loginMessage") == true) then
		print(self.LoginMessage);
	end

	E:CreateTidyButton();
	E:CreateConfigButton();
	E:InitOptions();

	-- If we try and set the inital text when we create the
	-- button, it wont be redrawn correctly later
	E:UpdateLogButton(E:GetConfig("showLogs"))

	LFGListFrame.SearchPanel:HookScript("OnEvent", E.TidyEvent);
	hooksecurefunc("LFGListSearchEntry_Update", E.TidyUpdate);
end

-- Ensure initialization is hooked correctly
local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" then
		E:OnInitialize()
		E:OnEnable()
	end
end)
