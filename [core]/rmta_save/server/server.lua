local START_MONEY = 2000 -- стартовый капитал
local START_COIN = 10 -- стартовые коинсы

local function getRealDate()
	local TIME = getRealTime()
	local DATE_MONTHDAY, DATE_MONTH, DATE_YEAR = string.format("%02d", TIME.monthday), string.format("%02d", TIME.month + 1), TIME.year + 1900
	return DATE_MONTHDAY.."/"..DATE_MONTH.."/"..DATE_YEAR
end

local function createNewAccount(currentAccount, id, email) -- создание аккаунта
	setAccountData(currentAccount, "account.ID", "id_"..tonumber(id))
	setAccountData(currentAccount, "account.NICKNAME", getAccountName(currentAccount))
	setAccountData(currentAccount, "account.EMAIL", email)
	setAccountData(currentAccount, "account.DATE_REG", getRealDate())
	setAccountData(currentAccount, "account.COIN", tonumber(START_COIN))
	setAccountData(currentAccount, "account.LEVEL", 1)
	setAccountData(currentAccount, "account.EXP", 0)
	setAccountData(currentAccount, "account.JOB", '-')
end
addEvent("rmta_save.createNewAccount", true)
addEventHandler("rmta_save.createNewAccount", root, createNewAccount)

local function onPlayerLogin(player)
	local account = getPlayerAccount(player)

	local accountMoney = getAccountData(account, "account.MONEY")
	if (accountMoney) then 
		local PLAYER_NICKNAME = getAccountData(account, "account.NICKNAME")
		local PLAYER_MONEY = accountMoney
		local PLAYER_LEVEL = getAccountData(account, "account.LEVEL") or 1
		local PLAYER_EXP = getAccountData(account, "account.EXP") or 0
		local PLAYER_COIN = getAccountData(account, "account.COIN") or tonumber(START_COIN)
		local PLAYER_JOB = getAccountData(account, "account.JOB")

		setElementData(player, "player.NICKNAME", PLAYER_NICKNAME)
		setElementData(player, "player.COIN", tonumber(PLAYER_COIN))
		setElementData(player, "player.LEVEL", tonumber(PLAYER_LEVEL))
		setElementData(player, "player.EXP", tonumber(PLAYER_EXP))
		setElementData(player, "player.JOB",  PLAYER_JOB)
		setPlayerMoney(player, PLAYER_MONEY)
	else -- игрок зашел впервые
		setElementData(player, "player.NICKNAME", getAccountData(account, "account.NICKNAME"))
		setElementData(player, "player.COIN", getAccountData(account, "account.COIN"))
		setElementData(player, "player.LEVEL", getAccountData(account, "account.LEVEL"))
		setElementData(player, "player.EXP", getAccountData(account, "account.EXP"))
		setElementData(player, "player.JOB", getAccountData(account, "account.JOB"))
		setPlayerMoney(player, tonumber(START_MONEY))
	end

 	triggerEvent("rmta_spawn.spawnPlayer", root, player) -- заспавнить игрока
end
addEvent("rmta_save.playerLogin", true)
addEventHandler("rmta_save.playerLogin", root, onPlayerLogin)

function onQuit()
	local account = getPlayerAccount(source)
	if (account) then
		setAccountData(account, "account.MONEY", tonumber(getPlayerMoney(source)))
		setAccountData(account, "account.COIN", tonumber(getElementData(source, "player.COIN")) or tonumber(START_COIN))
		setAccountData(account, "account.LEVEL", tonumber(getElementData(source, "player.LEVEL")) or 1)
		setAccountData(account, "account.EXP", tonumber(getElementData(source, "player.EXP")) or 0)
		setAccountData(account, "account.JOB", tostring(getElementData(source, "player.JOB")))
	end
end
addEventHandler ("onPlayerQuit", getRootElement(), onQuit)