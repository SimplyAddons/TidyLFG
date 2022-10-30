# TidyLFG

TidyLFG enhances the default LFG experience for Mythic+ activities in World of Warcraft.

## Addon Features

TidyLFG only applies to M+ dungeon listings found under the Premade Group > Dungeons menu in the Group Finder.

* **Filter advertisements**
    * Advertisers often exhibit predictable behaviour, which stands out from typical users who are genuinely trying to play the game. We can use these identifiers to help filter out spam from the listings. Unfortunately, Blizzard decided to protect some areas of their game API, making it impossible for us to analyze group names or comments directly, so this will not catch everything.
* **Filter Realms**
    * If a player on a North American realm, joins a party with a group leader on an Oceanic realm, the NA player will be phased to the Oceanic realm. Unfortunately, this results in high latency and ping. This can often lead to a poor game experience for you, and your group members.
    
## Options

You can toggle logs on or off to see what groups are being filtered. Logs will appear in your chat window.

![TidyLFG](https://user-images.githubusercontent.com/9218035/198521561-c00f71b6-2ea0-4050-bb19-4bc00f6cddc7.jpg)

## To-Do

* Add configurable option to filter NA servers (for those in Oceanic realms who similarily, don't wish to be phased to NA realms).
* Add configurable option to enable or disable realm filters.
