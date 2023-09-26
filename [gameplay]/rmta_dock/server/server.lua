local function createJobPickup() -- создание пикапа
	local EMPLOYED = createPickup(
		DOCK_SETUPS['job']['employed'].x, 
		DOCK_SETUPS['job']['employed'].y, 
		DOCK_SETUPS['job']['employed'].z, 
	3, 1275, 1000)

	setElementData(EMPLOYED, "pickup:data", {
		text = "Работать в порту",
		text_offset = 0.8,
		dis = 20,
		color = {0, 255, 0, 255}
	})

	addEventHandler("onPickupHit", EMPLOYED, function(player)
		playSoundFrontEnd(player, 16)
		local CurrentJob = getElementData(player, "player.JOB")
		if CurrentJob == '-' or CurrentJob == 'dock' then
			triggerClientEvent(player, "onPlayerHitJobPickup", player)
		else 
			-- если устроен на другую работу
		end
	end)
end

local function dismissalPlayer(player) -- увольнение с работы
	if not player then return end
	
	dbExec(db, "UPDATE JobDockList SET TotalBox = ?, CurrentBox = ?, TotalContainer = ?, CurrentContainer = ?, TotalOrder = ?, CurrentOrder = ? WHERE Account = ?", 
		getElementData(player, "dock:loaderTotalBox"),
		getElementData(player, "dock:loaderCurrentBox"),
		getElementData(player, "dock:forkliftTotalContainer"),
		getElementData(player, "dock:forkliftCurrentContainer"),
		getElementData(player, "dock:driverTotalOrder"),
		getElementData(player, "dock:driverCurrentOrder"),
		getAccountName(getPlayerAccount(player))
	)

	setElementData(player, "player.JOB", "-")
	removeElementData(player, "dock:playerSpecialty")
	removeElementData(player, "dock:loaderTotalBox")
	removeElementData(player, "dock:loaderCurrentBox")
	removeElementData(player, "dock:forkliftTotalContainer")
	removeElementData(player, "dock:forkliftCurrentContainer")
	removeElementData(player, "dock:driverTotalOrder")
	removeElementData(player, "dock:driverCurrentOrder")
end
addEvent("rmta_dock.dismissalPlayer", true)
addEventHandler("rmta_dock.dismissalPlayer", getRootElement(), dismissalPlayer)

local function employedPlayer(player, specialty) -- устройство на работу
	if not player then return end
	local query = dbQuery(db, "SELECT * FROM JobDockList WHERE Account = ?", getAccountName(getPlayerAccount(player)))
	local result = dbPoll(query, -1)

	if type(result) == "table" and #result ~= 0 then
		for _, data in ipairs(result) do
			setElementData(player, "dock:loaderTotalBox", data['TotalBox'])
			setElementData(player, "dock:loaderCurrentBox", data['CurrentBox'])

			setElementData(player, "dock:forkliftTotalContainer", data['TotalContainer'])
			setElementData(player, "dock:forkliftCurrentContainer", data['CurrentContainer'])

			setElementData(player, "dock:driverTotalOrder", data['TotalOrder'])
			setElementData(player, "dock:driverCurrentOrder", data['CurrentOrder'])
		end
	else
		dbExec(db, "INSERT INTO JobDockList VALUES(?, ?, ?, ?, ?, ?, ?)", getAccountName(getPlayerAccount(player)), 0, 0, 0, 0, 0, 0)
		setElementData(player, "dock:loaderTotalBox", 0)
		setElementData(player, "dock:loaderCurrentBox", 0)

		setElementData(player, "dock:forkliftTotalContainer", 0)
		setElementData(player, "dock:forkliftCurrentContainer", 0)

		setElementData(player, "dock:driverTotalOrder", 0)
		setElementData(player, "dock:driverCurrentOrder", 0)
	end

	setElementData(player, "player.JOB", "dock")
	setElementData(player, "dock:playerSpecialty", specialty)
end
addEvent("rmta_dock.employedPlayer", true)
addEventHandler("rmta_dock.employedPlayer", getRootElement(), employedPlayer)

addEventHandler("onResourceStart", resourceRoot, function() 
	-- База данных
	db = dbConnect("sqlite", ":/jobs.db")
	dbExec(db, "CREATE TABLE IF NOT EXISTS JobDockList (Account, TotalBox, CurrentBox, TotalContainer, CurrentContainer, TotalOrder, CurrentOrder)")
	
	createJobPickup()
end)