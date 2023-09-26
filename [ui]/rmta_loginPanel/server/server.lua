function PlayerLogin(username, password, checksave)
	if not (username == "") then
		if not (password == "") then
			local account = getAccount ( username, password )
			if ( account ~= false ) then
				if checksave == true then
					triggerClientEvent(source, "saveLoginToXML", getRootElement(), username, password)
				else
					triggerClientEvent(source, "resetSaveXML", getRootElement(), username, password)
				end
				local chek = logIn(source, account, password)
				if chek then 
					triggerClientEvent(source, "destroyLoginPanel", getRootElement())
				else
					triggerClientEvent(source, "showWarning", getRootElement(), 1, false, "Данный аккаунт уже авторизован")
				end
			else
				triggerClientEvent(source, "showWarning", getRootElement(), 1, false, "Неправильный ник, либо пароль")
				triggerClientEvent(source, "showWarning", getRootElement(), 2, false, "Неправильный ник, либо пароль")
			end
		else
			triggerClientEvent(source, "showWarning", getRootElement(), 2, false, "Введите пароль")
		end
	else
		triggerClientEvent(source, "showWarning", getRootElement(), 1, false, "Введите никнейм")
	end
end
addEvent("onRequestLogin", true)
addEventHandler("onRequestLogin", getRootElement(), PlayerLogin)

function registerPlayer(username, email, password)
	if not (username == "") then
		if not (password == "") then
			if not (email == "") then
				local account = getAccount (username, password)
				if (account == false) then
					if getEmailFromAllAccount(email) then
						local accountID = #getAccounts() + 1
						local accountAdded = addAccount(tostring(username),tostring(password))
						if (accountAdded) then
							triggerEvent("rmta_save.createNewAccount", root, accountAdded, accountID, email)
							triggerClientEvent(source, "onAccountCreate", getRootElement())
						else
							triggerClientEvent(source, "showWarning", getRootElement(), 3, false, "Попробуйте другие данные")
							triggerClientEvent(source, "showWarning", getRootElement(), 4, false, "Попробуйте другие данные")
							triggerClientEvent(source, "showWarning", getRootElement(), 5, false, "Попробуйте другие данные")
						end
					else
						triggerClientEvent(source, "showWarning", getRootElement(), 4, false, "Данный e-mail уже используется")
					end
				else
					triggerClientEvent(source, "showWarning", getRootElement(), 3, false, "Данный никнейм зарегистрирован")
				end
			else
				triggerClientEvent(source, "showWarning", getRootElement(), 4, false, "Введите e-mail, например: royal@royalmta.ru")
			end
		else
			triggerClientEvent(source, "showWarning", getRootElement(), 5, false, "Введите пароль")
		end
	else
		triggerClientEvent(source, "showWarning", getRootElement(), 3, false, "Введите никнейм")
	end
end
addEvent("onRequestRegister",true)
addEventHandler("onRequestRegister",getRootElement(),registerPlayer)

function getEmailFromAllAccount(email) -- проверка 
	local accountTable = getAccounts ()
	for _, account in ipairs(accountTable) do
		if getAccountData(account, "account.email") == email then 
			return false 
		end
	end
	return true
end
