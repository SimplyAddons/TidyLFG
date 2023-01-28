local E = select(2, ...):unpack()

-- convenient shorthand for the /reload command
SLASH_RELOADUI1 = "/rl";
SlashCmdList["RELOADUI"] = ReloadUI;

-- convenient command for enabling blizzard debug tools
SLASH_FRAMESTK1 = "/fs";
SlashCmdList["FRAMESTK"] = function()
	LoadAddOn("Blizzard_DebugTools");
	FrameStackTooltip_Toggle();
end

-- TidyLFG options
SLASH_TIDYLFG1 = "/tl";
SLASH_TIDYLFG2 = "/tidy";
SLASH_TIDYLFG3 = "/tidylfg";
SlashCmdList["TIDYLFG"] = function()
	InterfaceOptionsFrame_OpenToCategory(E.AddOn);
end