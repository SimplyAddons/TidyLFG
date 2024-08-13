local AddOnName, NS = ...

local AddOn = LibStub("AceAddon-3.0"):NewAddon(AddOnName)

-- configuration defaults
--AddOn.defaults = { global = {} }

NS[1] = AddOn
--NS[2] = AddOn.defaults.global

function NS:unpack()
	--return self[1], self[2]
	return self[1]
end

NS[1].AddOn = AddOnName
NS[1].Version = C_AddOns.GetAddOnMetadata(AddOnName, "Version")
NS[1].userClassHexColor = "|c" .. select(4, GetClassColor(NS[1].userClass))
NS[1].LoginMessage = format("%sTidyLFG v%s|r - /tl", NS[1].userClassHexColor, NS[1].Version)

TidyLFG = NS
