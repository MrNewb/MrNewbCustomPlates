# MrNewbsCustomPlate

MrNewbsCustomPlate is a FiveM resource designed to provide a customizable license plate system for vehicles. 
This resource allows players to set a license plate to a vehicle and updates it in the database. 
Additionally, it features advanced functionalities such as moving glovebox and trunk inventories, compatibility with various frameworks, profanity filtering, configurable placeholders, and plate length verification.

This custom license plate script offers a seamless solution for monetizing custom plates within a FiveM server in an automated manner. 
By integrating this script, server owners can effortlessly implement a monetization system for custom license plates, providing players with the opportunity to personalize their vehicles while generating revenue for the server.
## Features

- **License Plate Setting**: Allows players to set a license plate to a vehicle and updates it in the database.
- **Glovebox and Trunk Inventory Transfer**: Moves glovebox and trunk inventories when changing vehicles.
- **Compatibility**: Compatible with ESX, QB-Core, Ox-Lib Input, QB-Input, and various notification systems.
- **Advanced Logging**: Offers advanced logging capabilities via Ox-Lib or QB-Logs.
- **Profanity Filter**: Features a profanity filter that can be adjusted to avoid specific bad words.
- **Framework Specific Trimming**: Trims functionality specific to different frameworks for seamless integration.
- **Configurable Placeholders**: Allows customization of placeholders for license plates.
- **Plate Length Verification**: Provides configuration options for preferred character length for license plates.

## Installation

1. Clone or download the `MrNewbsCustomPlate` resource.
2. Place the resource in your FiveM server's resources directory.
3. Add `ensure MrNewbsCustomPlate` to your `server.cfg` file.
4. Configure the resource settings in the `config.lua` file to suit your preferences.

## Configuration

In the `config.lua` file, you can customize the following settings:

- `Debug`: Set this to `true` to enable debug mode.
- `CustomPlateName`: The item used to set license plates.
- `framework`: Set the name of the framework being used (e.g., "esx", "qb-core").
- `Logs`: Set the logging method ("ox", "qb", or `false` to disable logging).
- `Notify`: Set the notification method ("ox", "qb", "ok", "sd").
- `Input`: Set the input method ("qb" or "ox").
- `Keys`: Set the key method ("qb", "qs", "gflp10", "jaksam", "mk", "renewed", "t1ger").
- `Inventory`: Specify the inventory method ("ox" or "qb"). Highlighting the significant advantage of utilizing Ox for this purpose through a single export, as opposed to manual querying and updates with QB-based inventories. This functionality is designed to seamlessly integrate with other QB-based inventory systems that handle glovebox and trunk operations in a similar manner.
- `Progress`: Set the progress method ("ox" or "qb").
- `Icon`: Set the icon used for the resource (only in ox input).
- `Placeholder`: Set the default placeholder for license plates.
- `Title`: Set the title for the license plate system.
- `PlateLengthText`: Set the text for the required character length for license plates currently set to 8 by defualt in config.
- `MinNumbers`: Set the minimum number of characters for license plates this must match the above.
- `MaxNumbers`: Set the maximum number of characters for license platesthis must match the above.
- `FilteredWords`: Customize the list of filtered words for the profanity filter.

## Usage

1. Use the provided item to set a license plate to a vehicle.
2. Customize the license plate to your preference, following the configured character length and profanity filter settings.
3. License plate updates will be reflected in the database.
4. Enjoy the customizable license plate system in your FiveM server!

## Credits

MrNewb - Initial development of the resource.

PickleMods - Improvments to the script to use callback functions and structure changes.

Rumaier - initially testing within the ESX framework on Cosmix RP, which eventually prompted the transition from Ox-Lib being a hard dependency to utilizing framework helper functions.

basicskillz - Testing on qb-core w/ okok notify.


## Item Configuration for ox_inventory
```lua

	["customizableplate"] = {
		label = "customizableplate",
		weight = 200,
		stack = false,
		close = true,
	},

```
## Item Configuration for qb-core
```lua

	['customizableplate'] 			= {['name'] = 'customizableplate', 			    ['label'] = 'Custom Plate', 		    		 ['weight'] = 100, 		['type'] = 'item', 		['image'] = '',								['unique'] = true, 	['useable'] = true, 		['shouldClose'] = true,	   ['combinable'] = nil,                     ['description'] = 'Custom Plate for setting a new plate to a vehicle'},

```

## Acknowledgments

Special thanks to Decay Studios for creating the inventory icons used in this release. You can find them on Discord [here](https://discord.gg/yDXZwZPjdN).
[![Decay Studios](https://i.imgur.com/a6n1J4u.png)]([https://i.imgur.com/a6n1J4u.png](https://i.imgur.com/a6n1J4u.png))

## Resource support
- **Notes**: This will be one of my last resource's I release for free, I feel its fair as ive been in the community for years and this marks #10 of my free releases currently floating around (that I havent removed). If you use this, my otherstuff or have supported my releases or encouraged me at all I appreciate you. Give me feedback in my discord, let me know if theres things I could do better, tell me what you enjoy.

- **Discord**: I created a basic Discord server to brainstorm ideas for future releases, focusing mainly on quality-of-life improvements and entertaining feature requests. I'm open to collaborating with anyone even helping small servers. Its odd and I dont fit the current fivem community, but I do this for fun and enjoy learning.
https://discord.gg/ZBKYxB6PzA