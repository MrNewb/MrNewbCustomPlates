Config = {
	Debug = false,												-- set this to turn on prints
	CustomPlateName = "customizableplate",						-- The item that would be used for this to work
	framework = "esx",											-- set this to the name of the method, pass as string. options are "qb", "esx", "ox", "nd" if using qbx just set to qb
	Logs = false,												-- set this to the name of the method, pass as string. options are "qb","ox", set to false to disable like Logs = false,		
	Notify = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb","ok","sd"
	Input = "ox",												-- set this to the name of the method, pass as string. options are "ox","qb"
	Keys = "ox",												-- set this to the name of the method, pass as string. options are "qb", "qs", "gflp10", "jaksam", "mk", "renewed", "t1ger" if you use a key system like wx just set this to Keys = false,
	Inventory = "ox",											-- set this to the name of the method, pass as string. options are "ox","qb"
	Progress = "ox",											-- set this to the name of the method, pass as string. options are "ox","qb"
	Icon = 'fa-solid fa-car-side',								-- set this to the icon you want to use, only works on ox_lib menu so if not using it leave it blank
	Placeholder = 'IAMNEWB1',									-- set this to the text that sits in the box before you type, I request you not change this but I wont stop you =(
	Title = 'Custom Plate',										-- set this to the title of the menu the player sees
	PlateLengthText = "Must Be 8 Characters Long",				-- set this to the text that explains how long it has to be
	MinNumbers = 8,												-- set this to the max numbers your plates use for the framework
	MaxNumbers = 8,												-- set this to the min numbers your plates use for the framework
	FilteredWords = {
		"badword",
		"fuck",
		"asshole",
	}
}