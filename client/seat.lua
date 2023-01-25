local SEATS = {
    [1] = {
        label = 'del conductor',
        val = -1,
    },
    [2] = {
        label = 'del copiloto',
        val = 0,
    },
    [3] = {
        label = 'detras del conductor',
        val = 1,
    },
    [4] = {
        label = 'detras del copiloto',
        val = 2,
    }
}
local lastPlayerSeat;
local function ShowNotification(text, type, timeouts)
    local event = { 'esx:showNotification', text, type or '', timeouts or 7000 }
    TriggerEvent(table.unpack(event))
end
RegisterCommand('seat', function(src, args)
    if (IsPedInAnyVehicle(PlayerPedId())) then
        if (tonumber(args[1])) then
            if (SEATS[tonumber(args[1])]) then 
                local playerPed = PlayerPedId()
                local vehicle = GetVehiclePedIsIn(playerPed, false)
                local seat = SEATS[tonumber(args[1])].val
                local getPlayerCurrentSeat = GetPedInVehicleSeat(vehicle, seat)
                if (lastPlayerSeat ~= SEATS[tonumber(args[1])].val) then 
                    lastPlayerSeat = SEATS[tonumber(args[1])].val
                    ShowNotification(('Te has cambiado al asiento %s'):format(SEATS[tonumber(args[1])].label), 'success')
                    if (getPlayerCurrentSeat ~= seat) or (getPlayerCurrentSeat == 0) then  -- Esto porque el GTA va un poco de lado la verdad...
                        SetPedIntoVehicle(playerPed, vehicle, seat)
                    else
                        ShowNotification('Ese asiento ya esta ocupado', 'error')
                    end
                else
                    ShowNotification(('Ya estas en el asiento %s'):format(SEATS[tonumber(args[1])].label), 'error')
                end
            else
                ShowNotification('No existe ese asiento', 'error')
            end
        else
            ShowNotification('Debes de poner un asiento', 'error')
        end
    end
end)

RegisterNetEvent('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    if (IsDuplicityVersion()) then 
        print(('^2[WARN]^0 %s'):format('Debes de poner el codigo en client side, no es apto para serverside.'))
    end
end)