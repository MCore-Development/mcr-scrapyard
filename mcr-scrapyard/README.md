# MCORE Scrapyard System

## How the Script Works
This script adds an advanced scrapyard system to your FiveM server. Players can bring vehicles to a scrapyard location and dismantle them for rewards. The script supports both ESX and QBCore frameworks and integrates with police dispatch systems. The process includes:
- Player brings a vehicle to the scrapyard marker.
- If enough police officers are online, the player can start dismantling the vehicle.
- A progress bar and mechanic animation play during dismantling.
- There is a configurable chance to send a dispatch alert to police jobs.
- After successful dismantling, the player receives a reward and the vehicle is deleted.

## Features
- Supports ESX and QBCore frameworks
- Configurable scrapyard locations and marker appearance
- Police job and required cops check
- Progress bar with mechanic animation
- Police dispatch integration (cd_dispatch)
- Configurable rewards
- **Fully localized:** All texts and labels are in `Config.Locales` in `config/config.lua` (EN/CS or your own language)
- Easy configuration via `config.lua`

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target] or [qb-target] (choose in config)
- [es_extended] (for ESX) or [qb-core] (for QBCore)
- [cd_dispatch] (for police dispatch integration)

## Installation
1. Download or clone this repository into your server's resources folder.
2. Ensure all dependencies are installed and started before this script.
3. Configure the script in `config/config.lua` to match your framework, target, jobs, rewards, and other preferences.
4. Add `ensure mcr-scrapyard` to your `server.cfg`.
5. (Optional) Edit `config/cl_edits.lua` for custom dispatch logic or localization.

## Configuration
- All main settings are in `config/config.lua`.
- Scrapyard locations, marker settings, police jobs, required cops, rewards, and dispatch chance are fully configurable.
- **Localization:**
  - All texts, labels, and notifications are in `Config.Locales`.
  - You can easily translate the script by editing the `Config.Locales` table.
  - Example (English):
    ```lua
    Config.Locales = {
        target_vehicle = 'Scrap Vehicle',
        progressbar_text = 'Scrapping vehicle...',
        get_cop_count_notify = 'There aren\'t enough police officers on duty!',
        disassemble_vehicle = 'Dismantle vehicle',
        disassemble_front_left_door = 'Dismantle front left door',
        disassemble_front_right_door = 'Dismantle front right door',
        disassemble_rear_left_door = 'Dismantle rear left door',
        disassemble_rear_right_door = 'Dismantle rear right door',
        disassemble_hood = 'Dismantle hood',
        disassemble_trunk = 'Dismantle trunk',
        disassemble_front_left_wheel = 'Dismantle front left wheel',
        disassemble_front_right_wheel = 'Dismantle front right wheel',
        disassemble_rear_left_wheel = 'Dismantle rear left wheel',
        disassemble_rear_right_wheel = 'Dismantle rear right wheel',
        disassembling_vehicle = 'Dismantling vehicle...'
    }
    ```
  - Example (Czech):
    ```lua
    Config.Locales = {
        target_vehicle = 'Vrak vozidla',
        progressbar_text = 'Rozebírání vozidla...',
        get_cop_count_notify = 'Není dostatek policistů ve službě!',
        disassemble_vehicle = 'Rozebrat vozidlo',
        disassemble_front_left_door = 'Rozebrat přední dveře řidiče',
        disassemble_front_right_door = 'Rozebrat přední dveře spolujezdce',
        disassemble_rear_left_door = 'Rozebrat zadní dveře řidiče',
        disassemble_rear_right_door = 'Rozebrat zadní dveře spolujezdce',
        disassemble_hood = 'Rozebrat kapotu',
        disassemble_trunk = 'Rozebrat kufr',
        disassemble_front_left_wheel = 'Rozebrat přední levé kolo',
        disassemble_front_right_wheel = 'Rozebrat přední pravé kolo',
        disassemble_rear_left_wheel = 'Rozebrat zadní levé kolo',
        disassemble_rear_right_wheel = 'Rozebrat zadní pravé kolo',
        disassembling_vehicle = 'Rozebírání vozidla...'
    }
    ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support
For issues or questions, contact the script author or open an issue on the repository. 