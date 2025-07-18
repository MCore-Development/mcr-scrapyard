Config = {}

Config.Framework = 'ESX' -- 'ESX' or 'qbcore'
Config.Target = 'ox_target' -- 'ox_target' or 'qb-target'
Config.Notify = 'ESX' -- 'ESX' or 'qbcore'

Config.PoliceJobs = {'police', 'sheriff'}
Config.RequiredCops = 1
Config.Dispatch = 'cd_dispatch' -- editable in cl_edits.lua
Config.SentDispatchChance = 35 -- 35%
Config.SentDispatchChancePart = 10 -- 10%

Config.ScrapyardLocations = {
    vector4(-577.1910, -1641.9651, 19.4262, 238.2189)
}

Config.MarkerSettings = {
    type = 1,
    color = {r = 0, g = 0, b = 255, a = 80},
    scale = {x = 6.0, y = 6.0, z = 0.5}
}

Config.ProgressBarDuration = 7500

Config.RewardsItems = {
    {item = 'water', min = 1, max = 2}
}

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

return Config