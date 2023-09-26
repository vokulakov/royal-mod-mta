createObject(900, 1935, -2326, 14.25, 0, 0, 90)

-- Вспомогательные функции

--[[ 
	-2816 / -2472 / 4
	
]]

addCommandHandler( 'pos',
	function( uPlayer )
		local x, y, z = getElementPosition(uPlayer)
		outputChatBox(math.floor(x).." | "..math.floor(y).." | "..math.floor(z))
	end
)

addCommandHandler( 'go',
	function( uPlayer )
		setElementPosition(uPlayer, 2638, -2432, 20)
	end
)

addCommandHandler( 'des',
	function( uPlayer )
		local theVehicle = getPedOccupiedVehicle ( uPlayer )
		if not theVehicle then return end
		destroyElement(theVehicle)
	end
)

addCommandHandler( 'cls', 
	function ( pl )
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
		outputChatBox(" ")
	end
)
-- 411
function car(playerSource, commandName, id)
	if not id then return end
	local x, y, z = getElementPosition(playerSource)
	local carT = createVehicle (id, x + 5, y, z + 5 )
	setVehicleDamageProof(carT, true)
end
addCommandHandler("cv", car)

addCommandHandler("truck", function(playerSource, commandName)
	local x, y, z = getElementPosition(playerSource)
	local carT = createVehicle (514, x + 5, y, z + 5)
	setVehicleDamageProof(carT, true)
	
	setTimer(function()
		local trailer = createVehicle (435, 0, 0, 0)
		setVehicleDamageProof(trailer, true)
		attachTrailerToVehicle(carT, trailer) 
	end, 1000, 1)
	
end)

addCommandHandler( 'color',
	function( uPlayer, cmd, r, g, b )
		if isPedInVehicle( uPlayer ) then
			local uVehicle = getPedOccupiedVehicle( uPlayer )
			if uVehicle then
				if (not r or not g or not b) then
					r, g, b = math.random( 255 ), math.random( 255 ), math.random( 255 )
				end
				setVehicleColor( uVehicle, r, g, b )
			end
		end
	end
)

addCommandHandler( 'jet', function( uPlayer )
	if (not doesPedHaveJetPack (uPlayer)) then 
		givePedJetPack (uPlayer)
	else
		removePedJetPack (uPlayer)
	end
end)

