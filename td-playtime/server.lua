local notificationResource = nil

-- Function to check if a specific resource is running
function IsResourceAvailable(resourceName)
    return GetResourceState(resourceName) == "started"
end

-- Detect notification resources and set the notification handler accordingly
Citizen.CreateThread(function()
    if IsResourceAvailable("okokNotify") then
        notificationResource = "okokNotify"
    elseif IsResourceAvailable("mythic_notify") then
        notificationResource = "mythic_notify"
    elseif IsResourceAvailable("esx_notify") then
        notificationResource = "esx_notify"
    elseif IsResourceAvailable("qb-core") then
        notificationResource = "QBCore"
    else
        notificationResource = "default"
    end

    print("[INFO] Notification system detected: " .. notificationResource)
end)

-- Function to send notifications dynamically based on available resources
function SendNotification(source, message, type)
    if notificationResource == "okokNotify" then
        TriggerClientEvent('okokNotify:Alert', source, "Playtime Tracker", message, 5000, type or 'info')
    elseif notificationResource == "mythic_notify" then
        TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = type or 'inform', text = message, length = 5000 })
    elseif notificationResource == "QBCore" then
        TriggerClientEvent('QBCore:Notify', source, message, type or 'success')
    elseif notificationResource == "esx_notify" then
        TriggerClientEvent('esx:showNotification', source, message)
    else
        -- Fallback: Use the native notification system
        TriggerClientEvent('chat:addMessage', source, {
            color = {0, 255, 0},
            multiline = true,
            args = {"Playtime Tracker", message}
        })
    end
end

-- Database setup: Create the table if it doesn't exist (exe does this anyway)
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS player_playtimes (
            id INT AUTO_INCREMENT PRIMARY KEY,
            license VARCHAR(50) UNIQUE NOT NULL,
            playtime INT DEFAULT 0 NOT NULL
        )
    ]], {}, function(affectedRows)
        if affectedRows > 0 then
            print("[INFO] Table 'player_playtimes' has been created or already exists.")
        end
    end)
end)

-- Register the "playtime" command to display playtime data
RegisterCommand("playtime", function(source, args)
    local licenseID = nil

    -- Retrieve the player's license identifier
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local identifier = GetPlayerIdentifier(source, i)
        if string.sub(identifier, 1, string.len("license:")) == "license:" then
            licenseID = string.sub(identifier, 9) -- Removes the "license:" part
            break
        end
    end

    if not licenseID then
        print("[ERROR] License not found for player (source: " .. source .. ")")
        SendNotification(source, "Unable to retrieve your license ID. Please try again.", 'error')
        return
    end

    -- Fetch the playtime for the given license
    MySQL.Async.fetchScalar("SELECT playtime FROM player_playtimes WHERE license = @license", {
        ['@license'] = licenseID
    }, function(playtime)
        if not playtime then
            SendNotification(source, "No playtime data found for your account.", 'error')
            return
        end
        
        -- Calculate playtime in days, hours, and minutes
        local days = math.floor(playtime / (24 * 60))
        local remainingHours = math.floor((playtime % (24 * 60)) / 60)
        local remainingMinutes = playtime % 60
        local hours = playtime / 60

        -- Send playtime notifications
        SendNotification(source, "Total Hours: " .. string.format("%.2f", hours) .. " hours", 'success')
        SendNotification(source, "Your playtime: " .. days .. " days, " .. remainingHours .. " hours, and " .. remainingMinutes .. " minutes.", 'success')

        print("[INFO] Sent playtime to player (source: " .. source .. ", license: " .. licenseID .. ")")
    end)
end, false)
