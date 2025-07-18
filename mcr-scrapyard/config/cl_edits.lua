local Config = require('config.config')

local function sendDispatchNotification()
    local data = exports['cd_dispatch']:GetPlayerInfo()
    TriggerServerEvent('cd_dispatch:AddNotification', {
        job_table = Config.PoliceJobs,
        coords = data.coords,
        title = '10-17 Scraping Vehicle',
        message = 'Suspicious activity at the junkyard is located at '..data.street,
        flash = 0,
        unique_id = data.unique_id,
        sound = 1,
        blip = {
            sprite = 651,
            scale = 0.8,
            colour = 14,
            flashes = false,
            text = '10-17 Scraping Vehicle',
            time = 5,
            radius = 0,
        }
    })
end

return { sendDispatchNotification = sendDispatchNotification }