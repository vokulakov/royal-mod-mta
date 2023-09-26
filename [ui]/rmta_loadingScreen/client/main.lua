local sx, sy = guiGetScreenSize()
local myScreenSource = dxCreateScreenSource(sx, sy)

local ugol, radius = 60, 60 -- Начальный угол поворота камеры и радиус окружности
local center = {["x"] = 1521, ["y"] = -1621, ["z"] = 129} -- Точка для центровки кадра

local function startCamera()
	ugol = ugol+0.05 --Добавляем для угла значения
	local x = center.x+radius*math.cos(math.rad(ugol)) --Новые координаты X
	local y = center.y-radius*math.sin(math.rad(ugol)) --Новые коодинаты Y
	setCameraMatrix(x, y, center.z+70, center.x, center.y, center.z, 0, 90) -- Двигаем камеру
end

local function blurShaderShow()
    dxUpdateScreenSource(myScreenSource)     
    dxSetShaderValue(BLUR_SHADER, "ScreenSource", myScreenSource)
	dxSetShaderValue(BLUR_SHADER, "BlurStrength", 6);
	dxSetShaderValue(BLUR_SHADER, "UVSize", sx, sy);
    dxDrawImage(-10, -10, sx+10, sy+10, BLUR_SHADER)
end

local function showLoadingScreen()
	-- Настройки
	showChat(false) -- скрытие чата
	setPlayerHudComponentVisible ("all", false) -- скрытие HUD
	setBlurLevel(0) -- отключение размытия при движении
	setOcclusionsEnabled(false) -- отключение скрытия объектов
	setWorldSoundEnabled(5, false) -- отключение фоновых звуков стрельбы
	setTime(5, 0) -- часы
	setMinuteDuration(60000 * 60 * 24) -- минуты
	toggleAllControls(false, true, true)
	addEventHandler("onClientResourceStart", root, startOtherResource)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), showLoadingScreen)

local function loadingRound()
	local seconds = getTickCount() / 1000
	local angle = math.sin(seconds) * 360
	dxDrawImage(sx-62, (sy-200/2)+5, 26, 26, 'assets/load.png', angle, 0, 0, _, true)
end

function startOtherResource(res)
	if (getResourceName(res) == "rmta_sounds") then
		WELCOME_SOUND = exports["rmta_sounds"]:playSound("sound_welcome.mp3", true)
	elseif (getResourceName(res) == "rmta_shaders") then
		BLUR_SHADER = exports["rmta_shaders"]:createShader("blur.fx")
		addEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
		addEventHandler ("onClientPreRender", getRootElement (), startCamera)
		fadeCamera(true, 2) -- открываем камеру
		setTimer( function() 
			LOGO = guiCreateStaticImage(sx/2-200/2, sy/2-200/2, 200, 200, "assets/logo.png", false)
			LABEL_LOAD = exports["rmta_buttons"]:createHelpButton(sx-290, sy-200/2, 270, "Идет загрузка ресурсов", 15, 0.7, "")
			addEventHandler("onClientPreRender", root, loadingRound)
		end, 200, 1)
    elseif (getResourceName(res) == "rmta_loginPanel") then
    	-- отключение экрана загрузки
    	setTimer( function() 
    		destroyElement(LABEL_LOAD)
    		removeEventHandler("onClientPreRender", root, loadingRound)
    	end, 1500, 1)
    	setTimer( function() 
			PRESS_ENTER = exports["rmta_buttons"]:createHelpButton(sx/2-170/2, sy-200/2, 170, "Продолжить", 15, 0.7, "b_enter")
    		bindKey("enter", "down", startLoginPanel)
		end, 2500, 1)
	end
end

function startLoginPanel() -- запуск логин панели
	destroyElement(PRESS_ENTER)
	destroyElement(LOGO)
	removeEventHandler("onClientResourceStart", root, startOtherResource)
	triggerEvent("setLoginPanelVisible", getRootElement(), true)
	unbindKey("enter", "down", startLoginPanel)
end

local function welcomeMessage()
	for i = 1, 20 do outputChatBox("") end
	--outputChatBox("Добро пожаловать!", 0, 255, 0)
end

function destroyLoginPanel() -- выключаем логин панель
	fadeCamera(false, 2)
	triggerEvent ("setLoginPanelVisible", getRootElement(), false)

	setTimer(function() 
		removeEventHandler ("onClientPreRender", getRootElement (), startCamera)
	end, 2000, 1)

	setTimer(function()
		removeEventHandler("onClientPreRender", getRootElement(), blurShaderShow)
		welcomeMessage()
		showChat(true)
		toggleAllControls(true, true, true) 
		toggleControl("radar", false) -- отключение стандартной карты
		stopSound(WELCOME_SOUND)
		triggerServerEvent("rmta_save.playerLogin", root, localPlayer)
		triggerServerEvent("rmta_world.setWorldTime", root, localPlayer)
		triggerEvent("rmta_showui.setVisiblePlayerUI", root, true)
	end, 4000, 1)
end
addEvent("destroyLoginPanel", true)
addEventHandler("destroyLoginPanel", getRootElement(), destroyLoginPanel)

