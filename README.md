# MrNewbCustomPlates

![MrNewbCustomPlates V3](MrNewbCustomPlates-V3.png)

Usable plate item. Player types a plate, it is filtered, then applied to a nearby owned vehicle.

[Documentation](https://mrnewb.github.io/docs/mrnewbcustomplates) · [GitHub](https://github.com/MrNewb/MrNewbCustomPlates) · [Discord](https://discord.gg/mrnewbscripts) · [Preview](https://www.youtube.com/watch?v=fGq9QBig3j4)

[![MrNewbCustomPlates preview](https://img.youtube.com/vi/fGq9QBig3j4/hqdefault.jpg)](https://www.youtube.com/watch?v=fGq9QBig3j4)

## Install

Needs [ox_lib](https://github.com/overextended/ox_lib), [oxmysql](https://github.com/overextended/oxmysql), and [Newb_Bridge](https://github.com/MrNewb/Newb_Bridge).

```cfg
ensure ox_lib
ensure oxmysql
ensure Newb_Bridge
ensure MrNewbCustomPlates
```

Do not add `server.export` on the ox_inventory item. Omit `consume` on the item def.

Item defs: [docs](https://mrnewb.github.io/docs/mrnewbcustomplates/install).

## Config

`configs/config.lua` — `PlateItemName` (default `customizableplate`), length, filtered words, progress bar toggle, optional ox exclusive (blocks giving the item to another player).

The player must be outside the vehicle and next to a networked vehicle they own. The server re-checks plate text, distance, ownership, and that the item is still in inventory before writing.

Optional: [MrNewbVehicleKeys](https://github.com/MrNewb/MrNewbVehicleKeysV2) so key metadata follows plate changes.

Inventory icons by [Decay Studios](https://discord.gg/yDXZwZPjdN).
