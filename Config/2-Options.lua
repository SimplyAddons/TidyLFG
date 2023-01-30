local E, Config = select(2, ...):unpack()

-- table of available options
function E:Options()

    local options = {}
    options[1] = {
        key = "showLogs",
        desc = "  Print TidyLFG logs to chat window"
    }
    options[2] = {
        key = "filterUS",
        desc = "  Filter US realms from the dungeon list"
    }
    options[3] = {
        key = "filterOCE",
        desc = "  Filter OCE realms from the dungeon list"
    }
    options[4] = {
        key = "filterBrazil",
        desc = "  Filter Brazil realms from the dungeon list"
    }
    options[5] = {
        key = "filterLatin",
        desc = "  Filter Latin realms from the dungeon list"
    }

    return options
end
