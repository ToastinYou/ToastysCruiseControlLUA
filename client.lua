local cruiseControl = false
local cruiseSpeed
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local ped = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(ped, false)
		local speed = GetEntitySpeed(vehicle)
		DisableControlAction(0, 168, true)
		
		cruiseSpeed = speed

		if ped and vehicle and IsPedInAnyVehicle(ped, false) and GetPedInVehicleSeat(vehicle, -1) == ped and speed*2.23694+0.5 > 20 and not IsPedInAnyBoat(ped) and not IsPedInAnyPlane(ped) and (IsDisabledControlJustPressed(0, 168) or (IsControlJustPressed(0, 27) and IsControlJustPressed(0, 99))) then

			if not cruiseControl then
				DisplayNotification("[Toasty's Cruise Control]: Activated at a speed of "..math.floor(speed*2.23694+0.5).."mph.")
				cruiseControl = true
				setSpeed()
			else
				DisplayNotification("[Toasty's Cruise Control]: Deactivated.")
				cruiseControl = false
			end
		end

		if cruiseControl and (not IsPedInAnyVehicle(ped, false) or not GetPedInVehicleSeat(vehicle, -1) == ped or not IsVehicleOnAllWheels(vehicle)) then
			DisplayNotification("[Toasty's Cruise Control]: Deactivated.")
			cruiseControl = false
		end

		if ped and vehicle and cruiseControl then

			if IsControlPressed(27, 71) then
				cruiseControl = false
				acceleratingToNewSpeed()
			end

			if IsControlPressed(27, 72) then
				DisplayNotification("[Toasty's Cruise Control]: Deactivated.")
				cruiseControl = false
			end
		end

		if cruiseControl and speed*2.23694+0.5 < 20 then
			DisplayNotification("[Toasty's Cruise Control]: Deactivated.")
			cruiseControl = false
		end
	end
end)

function setSpeed()
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(0)
			local ped = GetPlayerPed(-1)
			local vehicle = GetVehiclePedIsIn(ped, false)

			if ped and vehicle and cruiseControl and IsVehicleOnAllWheels(vehicle) then
				SetVehicleForwardSpeed(vehicle, cruiseSpeed)
			end
		end
	end)
end

function acceleratingToNewSpeed()
	Citizen.CreateThread(function()
		while IsControlPressed(27, 71) do
			Citizen.Wait(1)
		end

		cruiseControl = true
		setSpeed()
	end)
end

function DisplayNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end