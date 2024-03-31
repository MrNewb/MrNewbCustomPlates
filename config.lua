--		___  ___       _   _                  _      _____              _         _
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/
--									          | |
--									          |_|
--		  Need support? Join our Discord server for help: https://discord.gg/d3Kh2vz3a7
Config = {
	Debug = true,												-- set this to turn on prints
	CustomPlateName = "customizableplate",									-- The item that would be used for this to work
	framework = "qb",											-- set this to the name of the method, pass as string. options are "qb", "esx" if using qbx just set to qb
	Logs = false,												-- set this to the name of the method, pass as string. options are "qb","ox", set to false to disable like Logs = false,
	Notify = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb","ok","sd", "brutal", "mythic", "pnotify"
	Input = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb"
	AltKeys = false,											-- if you use t1ger keys/ mk / mono set to true so a key can be removed before the plate change
	Keys = "qb",												-- set this to the name of the method, pass as string. options are "qb", "newb", "ok", "qs", "gflp10", "jaksam", "mk", "renewed", "t1ger", "mono" if you use a key system like wx just set this to Keys = false,
	Inventory = "ox",											-- set this to the name of the method, pass as string. options are "ox","qb", "qs"
	Progress = "ox",											-- set this to the name of the method, pass as string. options are "ox","qb",
	Icon = 'fa-solid fa-car-side',										-- set this to the icon you want to use, only works on ox_lib menu so if not using it leave it blank
	Placeholder = 'IAMNEWB1',										-- set this to the text that sits in the box before you type, I request you not change this but I wont stop you =(
	Title = 'Custom Plate',											-- set this to the title of the menu the player sees
	PlateLengthText = "Must Be 8 Characters Long",								-- set this to the text that explains how long it has to be
	MinNumbers = 8,												-- set this to the max numbers your plates use for the framework (this is very important that it matches or you will have issues)
	MaxNumbers = 8,												-- set this to the min numbers your plates use for the framework (this is very important that it matches or you will have issues)
	FilteredWords = {
		"badword",
		"fuck",
		"asshole",
	}
}
