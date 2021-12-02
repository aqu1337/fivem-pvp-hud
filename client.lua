local vida = false

function sendstats()
	SendNUIMessage({
		show = IsPauseMenuActive(),
		vida = vida
	})
end


RegisterNUICallback('fechar', function(data)
	local tipo = data.id
	SendNUIMessage({show = tipo})
end)

local entityExist = false
local entityDead = false
local isInAnyVehicle = false
local sBuffer = {}
local vBuffer = {}
local CintoSeguranca = false
local ExNoCarro = false


Citizen.CreateThread(function()
  while true do
		local player = PlayerPedId()
    entityExist = DoesEntityExist(player)
		entityDead = IsEntityDead(player)
		isInAnyVehicle = IsPedInAnyVehicle(player, true)
		vida = math.floor((GetEntityHealth(player)-100)/(GetEntityMaxHealth(player)-100)*100)
		sendstats()
    Citizen.Wait(1000)
  end
end)

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(500)
	end
end

Citizen.CreateThread(function()
  ReplaceHudColour(116, 023)
end)

function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end