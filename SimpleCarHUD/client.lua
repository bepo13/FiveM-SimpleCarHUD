-- SPEEDOMETER PARAMETERS--
local speedFont = 2                     -- Font used to display speed text
local speedLimit = 100                  -- Speed limit for changing speed color
local speedColorText = {255,255,255}    -- Color used to display speed text
local speedColorUnder = {160,255,160}   -- Color used to display speed when under speedLimit
local speedColorOver = {255,64,64}      -- Color used to display speed when over speedLimit

-- FUEL PARAMETERS --
local fuelFont = 2                      -- Font used to display location
local fuelWarnLimit = 40.0              -- Fuel limit for triggering warning color
local fuelEmptyLimit = 10.0             -- Fuel limit for triggering empty color
local fuelColorText = {255,255,255}     -- Color used to display fuel text
local fuelColorGood = {160,255,160}     -- Color used to display fuel when good
local fuelColorWarn = {255,160,80}      -- Color used to display fuel warning
local fuelColorEmpty = {255,64,64}      -- Color used to display fuel empty

-- LOCATION PARAMETERS --
local locationFont = 4                  -- Font used to display location
local locationColorText = {255,255,255} -- Color used to display location

-- Arrays for displaying location
local zones = { ['AIRP'] = "Los Santos International Airport", ['ALAMO'] = "Alamo Sea", ['ALTA'] = "Alta", ['ARMYB'] = "Fort Zancudo", ['BANHAMC'] = "Banham Canyon Dr", ['BANNING'] = "Banning", ['BEACH'] = "Vespucci Beach", ['BHAMCA'] = "Banham Canyon", ['BRADP'] = "Braddock Pass", ['BRADT'] = "Braddock Tunnel", ['BURTON'] = "Burton", ['CALAFB'] = "Calafia Bridge", ['CANNY'] = "Raton Canyon", ['CCREAK'] = "Cassidy Creek", ['CHAMH'] = "Chamberlain Hills", ['CHIL'] = "Vinewood Hills", ['CHU'] = "Chumash", ['CMSW'] = "Chiliad Mountain State Wilderness", ['CYPRE'] = "Cypress Flats", ['DAVIS'] = "Davis", ['DELBE'] = "Del Perro Beach", ['DELPE'] = "Del Perro", ['DELSOL'] = "La Puerta", ['DESRT'] = "Grand Senora Desert", ['DOWNT'] = "Downtown", ['DTVINE'] = "Downtown Vinewood", ['EAST_V'] = "East Vinewood", ['EBURO'] = "El Burro Heights", ['ELGORL'] = "El Gordo Lighthouse", ['ELYSIAN'] = "Elysian Island", ['GALFISH'] = "Galilee", ['GOLF'] = "GWC and Golfing Society", ['GRAPES'] = "Grapeseed", ['GREATC'] = "Great Chaparral", ['HARMO'] = "Harmony", ['HAWICK'] = "Hawick", ['HORS'] = "Vinewood Racetrack", ['HUMLAB'] = "Humane Labs and Research", ['JAIL'] = "Bolingbroke Penitentiary", ['KOREAT'] = "Little Seoul", ['LACT'] = "Land Act Reservoir", ['LAGO'] = "Lago Zancudo", ['LDAM'] = "Land Act Dam", ['LEGSQU'] = "Legion Square", ['LMESA'] = "La Mesa", ['LOSPUER'] = "La Puerta", ['MIRR'] = "Mirror Park", ['MORN'] = "Morningwood", ['MOVIE'] = "Richards Majestic", ['MTCHIL'] = "Mount Chiliad", ['MTGORDO'] = "Mount Gordo", ['MTJOSE'] = "Mount Josiah", ['MURRI'] = "Murrieta Heights", ['NCHU'] = "North Chumash", ['NOOSE'] = "N.O.O.S.E", ['OCEANA'] = "Pacific Ocean", ['PALCOV'] = "Paleto Cove", ['PALETO'] = "Paleto Bay", ['PALFOR'] = "Paleto Forest", ['PALHIGH'] = "Palomino Highlands", ['PALMPOW'] = "Palmer-Taylor Power Station", ['PBLUFF'] = "Pacific Bluffs", ['PBOX'] = "Pillbox Hill", ['PROCOB'] = "Procopio Beach", ['RANCHO'] = "Rancho", ['RGLEN'] = "Richman Glen", ['RICHM'] = "Richman", ['ROCKF'] = "Rockford Hills", ['RTRAK'] = "Redwood Lights Track", ['SANAND'] = "San Andreas", ['SANCHIA'] = "San Chianski Mountain Range", ['SANDY'] = "Sandy Shores", ['SKID'] = "Mission Row", ['SLAB'] = "Stab City", ['STAD'] = "Maze Bank Arena", ['STRAW'] = "Strawberry", ['TATAMO'] = "Tataviam Mountains", ['TERMINA'] = "Terminal", ['TEXTI'] = "Textile City", ['TONGVAH'] = "Tongva Hills", ['TONGVAV'] = "Tongva Valley", ['VCANA'] = "Vespucci Canals", ['VESP'] = "Vespucci", ['VINE'] = "Vinewood", ['WINDF'] = "Ron Alternates Wind Farm", ['WVINE'] = "West Vinewood", ['ZANCUDO'] = "Zancudo River", ['ZP_ORT'] = "Port of South Los Santos", ['ZQ_UAR'] = "Davis Quartz" }
local directions = { [0] = 'N', [90] = 'W', [180] = 'S', [270] = 'E', [360] = 'N', } 

-- Main thread
Citizen.CreateThread(function()
    while true do
        -- Loop delay
        Citizen.Wait(5)

        -- Get player position and speed
		local pos = GetEntityCoords(GetPlayerPed(-1))
		local var1, var2 = GetStreetNameAtCoord(pos.x, pos.y, pos.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
		local current_zone = zones[GetNameOfZone(pos.x, pos.y, pos.z)]
        local spd = GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false))*2.2369

        -- Find which direction we are facing
        for k,v in pairs(directions)do
            -- Get heading and fit to directions +/- 45 degrees
			direction = GetEntityHeading(GetPlayerPed(-1))
			if(math.abs(direction - k) < 45)then
				direction = v
				break;
			end
		end
        
        -- Display information when in vehicle
        if(IsPedInAnyVehicle(GetPlayerPed(-1), false)) then
            -- Draw speedometer
            if (spd >= speedLimit) then
                -- Over speed limit, draw speed using speedColorOver
                drawTxt(("%.3d"):format(math.ceil(spd)), speedFont, speedColorOver, 0.9, 0.165, 0.900)
            else
                -- Under speed limit, draw speed using speedColorUnder
                drawTxt(("%.3d"):format(math.ceil(spd)), speedFont, speedColorUnder, 0.9, 0.165, 0.900)
            end
            -- Draw MPH tag
            drawTxt("MPH", speedFont, speedColorText, 0.4, 0.20, 0.924)
            
            -- Draw fuel gauge; always displays 100 but can be modified by setting currentFuel with correct API call
            local currentFuel = 100.0
            if (currentFuel >= fuelWarnLimit) then
                -- Over fuel warning limit, draw fuel using fuelColorGood
                drawTxt(("%.3d"):format(math.ceil(currentFuel)), fuelFont, fuelColorGood, 0.9, 0.220, 0.900)
            elseif (currentFuel >= fuelEmptyLimit) then
                -- Under fuel warning limit, draw fuel using fuelColorWarn
                drawTxt(("%.3d"):format(math.ceil(currentFuel)), fuelFont, fuelColorWarn, 0.9, 0.220, 0.900)
            else
                -- Under fuel empty limit, draw fuel using fuelColorEmpty
                drawTxt(("%.3d"):format(math.ceil(currentFuel)), fuelFont, fuelColorEmpty, 0.9, 0.220, 0.900)
            end
            -- Draw fuel tag
            drawTxt("FUEL", fuelFont, fuelColorText, 0.4, 0.255, 0.924)
            
            -- Draw street name and heading direction
            if (GetStreetNameFromHashKey(var1) and GetNameOfZone(pos.x, pos.y, pos.z)) then
                if (zones[GetNameOfZone(pos.x, pos.y, pos.z)] and tostring(GetStreetNameFromHashKey(var1))) then
                    if tostring(GetStreetNameFromHashKey(var2)) == "" then
                        -- Heading | street name | zone
                        drawTxt(direction .. " | " .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], locationFont, locationColorText, 0.6, 0.165, 0.952)
                    else 
                        -- Heading | street name | zone
                        drawTxt(direction .. " | " .. tostring(GetStreetNameFromHashKey(var2)) .. " | " .. zones[GetNameOfZone(pos.x, pos.y, pos.z)], locationFont, locationColorText, 0.6, 0.165, 0.952)
                    end
                end
            end
        end
    end
end)

-- Helper function to draw text to screen
function drawTxt(content, font, colour, scale, x, y)
    SetTextFont(font)
    SetTextScale(scale, scale)
    local colourr,colourg,colourb = table.unpack(colour)
    SetTextColour(colourr,colourg,colourb, 255)
    SetTextEntry("STRING")
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    AddTextComponentString(content)
    DrawText(x, y)
end
