-- SCREEN POSITION PARAMETERS
local screenPosX = 0.165                    -- X coordinate (top left corner of HUD)
local screenPosY = 0.900                    -- Y coordinate (top left corner of HUD)

-- SPEEDOMETER PARAMETERS--
local speedLimit = 100.0                    -- Speed limit for changing speed color
local speedColorText = {255, 255, 255}      -- Color used to display speed label text
local speedColorUnder = {160, 255, 160}     -- Color used to display speed when under speedLimit
local speedColorOver = {255, 64, 64}        -- Color used to display speed when over speedLimit

-- FUEL PARAMETERS --
local fuelWarnLimit = 25.0                  -- Fuel limit for triggering warning color
local fuelColorText = {255, 255, 255}       -- Color used to display fuel text
local fuelColorOver = {255, 255, 255}       -- Color used to display fuel when good
local fuelColorUnder = {255, 64, 64}        -- Color used to display fuel warning

-- SEATBELT PARAMETERS --
local seatbeltColorOn = {160, 255, 160}     -- Color used when seatbelt is on
local seatbeltColorOff = {255, 64, 64}      -- Color used when seatbelt is off

-- LOCATION PARAMETERS --
local locationColorText = {255, 255, 255}   -- Color used to display location string

-- Lookup tables for direction and zone
local directions = { [0] = 'N', [1] = 'W', [2] = 'S', [3] = 'E', [4] = 'N', } 
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }

-- Main thread
Citizen.CreateThread(function()
    while true do
        -- Loop forever and update HUD every 5ms (200hz)
        Citizen.Wait(5)

        -- Get player PED and save to local
        local player = GetPlayerPed(-1)
        
        -- Display information only when in vehicle
        if (IsPedInAnyVehicle(player, false)) then
            -- Get vehicle speed and draw speedometer
            local speed = GetEntitySpeed(GetVehiclePedIsIn(player, false))*2.2369
            speedColor = (speed >= speedLimit) and speedColorOver or speedColorUnder
            drawTxt(("%.3d"):format(math.ceil(speed)), 2, speedColor, 0.9, screenPosX, screenPosY)
            drawTxt("MPH", 2, speedColorText, 0.4, screenPosX + 0.035, screenPosY + 0.024)
            
            -- Draw fuel gauge; always displays 100 but can be modified by setting currentFuel with an API call
            local currentFuel = 100.0
            fuelColor = (currentFuel >= fuelWarnLimit) and fuelColorOver or fuelColorUnder
            drawTxt(("%.3d"):format(math.ceil(currentFuel)), 2, fuelColor, 0.9, screenPosX + 0.055, screenPosY)
            drawTxt("FUEL", 2, fuelColorText, 0.4, screenPosX + 0.090, screenPosY + 0.024)

            -- Draw seatbelt status; always displays ON but can be moddified by setting seatbeltIsOn with an API call
            local seatbeltIsOn = true
            seatbeltColor = seatbeltIsOn and seatbeltColorOn or seatbeltColorOff
            drawTxt("SEATBELT", 2, seatbeltColor, 0.4, screenPosX + 0.115, screenPosY + 0.024)
            
            -- Get heading and zone from lookup tables and street name from hash
            local heading = directions[math.floor((GetEntityHeading(player) + 45.0) / 90.0)]
            local position = GetEntityCoords(player)
            local zoneNameFull = zones[GetNameOfZone(position.x, position.y, position.z)]
            local streetName = GetStreetNameFromHashKey(GetStreetNameAtCoord(position.x, position.y, position.z))
            
            -- Display heading, street name and zone when possible
            local locationText = heading
            locationText = (streetName == "" or streetName == nil) and (locationText) or (locationText .. " | " .. streetName)
            locationText = (zoneNameFull == "" or zoneNameFull == nil) and (locationText) or (locationText .. " | " .. zoneNameFull)
            drawTxt(locationText, 4, locationColorText, 0.6, screenPosX, screenPosY + 0.052)
        end
    end
end)

-- Helper function to draw text to screen
function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    SetTextColour(colour[1],colour[2],colour[3], 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end