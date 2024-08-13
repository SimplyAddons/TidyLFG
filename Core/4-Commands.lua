local E = select(2, ...):unpack()

-- convenient shorthand for the /reload command
SLASH_RELOADUI1 = "/rl";
SlashCmdList["RELOADUI"] = ReloadUI;

-- convenient command for enabling blizzard debug tools
SLASH_FRAMESTK1 = "/fs";
SlashCmdList["FRAMESTK"] = function()
	C_AddOns.LoadAddOn("Blizzard_DebugTools");
	FrameStackTooltip_Toggle();
end

-- TidyLFG options
SLASH_TIDYLFG1 = "/tl";
SLASH_TIDYLFG2 = "/tidy";
SLASH_TIDYLFG3 = "/tidylfg";
SlashCmdList["TIDYLFG"] = function()
	if Settings and Settings.OpenToCategory then
		Settings.OpenToCategory(E.AddOn);
	else
		print("Error: Unable to open options. The settings API is not available.");
	end
end
