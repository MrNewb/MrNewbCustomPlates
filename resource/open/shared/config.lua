--		___  ___       _   _                  _      _____              _         _
--		|  \/  |      | \ | |                | |    /  ___|            (_)       | |
--		| .  . | _ __ |  \| |  ___ __      __| |__  \ `--.   ___  _ __  _  _ __  | |_  ___
--		| |\/| || '__|| . ` | / _ \\ \ /\ / /| '_ \  `--. \ / __|| '__|| || '_ \ | __|/ __|
--		| |  | || |   | |\  ||  __/ \ V  V / | |_) |/\__/ /| (__ | |   | || |_) || |_ \__ \
--		\_|  |_/|_|   \_| \_/ \___|  \_/\_/  |_.__/ \____/  \___||_|   |_|| .__/  \__||___/
--									          							  | |
--									          							  |_|
--
--		  Need support? Join our Discord server for help: https://discord.gg/mrnewbscripts
--		  Check out my paid scripts and freebies at https://mrnewbscripts.tebex.io/
--		  If you need help with configuration or have any questions, please do not hesitate to ask.
--		  Docs Are Always Available At -- https://mrnewb.github.io/docs/
--

Config = Config or {}

Config.PlateItemName = 'customizableplate'
Config.EnableOxExclusive = false
Config.ProgressBarEnabled = true

-- Matched as substrings, so keep entries long enough that they cannot swallow an
-- innocent plate: 'ass' would also block CLASS, BASS and PASSAT.
Config.FilteredWords = { 'badword', 'fuck', 'asshole' }

Config.Settings = {
    MinCharacters = 8,
    MaxCharacters = 8, -- A GTA plate holds eight characters; anything higher is clamped.
}
