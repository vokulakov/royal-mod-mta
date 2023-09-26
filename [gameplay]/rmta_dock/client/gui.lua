local screenX, screenY = guiGetScreenSize()
local windowVisible = false

WINDOW = {}

FONT = {
	["RB"] = exports["rmta_fonts"]:createFontGui("RB.ttf", 11),
	["RB_QUIT"] = exports["rmta_fonts"]:createFontGui("RB.ttf", 10),
	["RR"] = exports["rmta_fonts"]:createFontGui("RR.ttf", 10)
}

WINDOW.SPECIALTY = { -- Информация о работе
	{	
		x = 270,
		y = 160,
		name = "ГРУЗЧИК",
		lvl = 1, 
		icon = "assets/gui/1.png",
		image = "assets/gui/img_1.png",
		text = "Переносите ящики со склада на поддон. Оплата\nпроизводится за каждый ящик. За ящик вы\nполучите $5."
	},
	
	{	
		x = 270,
		y = 220,
		name = "ОПЕРАТОР ПОГРУЗЧИКА",
		lvl = 1, 
		icon = "assets/gui/2.png",
		image = "assets/gui/img_2.png", 
		text = "Перевезите поддоны с ящиками на склад для\nотгрузки. Оплата производится за каждый\nподдон. За поддон вы получите $15."
	},
	
	{	
		x = 270,
		y = 280,
		name = "ВОДИТЕЛЬ",
		lvl = 1, 
		icon = "assets/gui/3.png",
		image = "assets/gui/img_3.png", 
		text = "Развезите товар по точкам, которые указаны на\nкарте. Оплата производится в зависимости от\nкол-ва точек. За смену вы получите ~$1000."
	}
}

local function drawDockWindow()
	if getElementData(localPlayer, "player.JOB") == 'dock' then -- увольнение
		WINDOW.back = guiCreateStaticImage(screenX/2-300/2, screenY/2-130/2, 300, 130, "assets/gui/bg2.png", false)
		WINDOW.close = guiCreateStaticImage(screenX/2+300/2-32/2, screenY/2-130/2-32/2, 32, 32, "assets/gui/b_close.png", false)
		setElementParent(WINDOW.close, WINDOW.back)

		WINDOW.info_label = guiCreateLabel(0, 10, 300, 30, "УВОЛЬНЕНИЕ С РАБОТЫ", false, WINDOW.back)
		guiLabelSetHorizontalAlign(WINDOW.info_label, "center")
		guiSetFont(WINDOW.info_label, FONT["RB_QUIT"])
		guiLabelSetColor(WINDOW.info_label, 0, 0, 0)

		WINDOW.info = guiCreateLabel(0, 50, 300, 30, "Вы точно хотите уволиться?", false, WINDOW.back)
		guiLabelSetHorizontalAlign(WINDOW.info, "center")
		guiSetFont(WINDOW.info, FONT["RR"])
		guiLabelSetColor(WINDOW.info, 0, 0, 0)

		WINDOW.button_quit = guiCreateStaticImage(300/2-160/2, 130-60, 160, 70, "assets/gui/btn.png", false, WINDOW.back)
		return
	end

	WINDOW.back = guiCreateStaticImage(screenX/2-600/2, screenY/2-360/2, 600, 360, "assets/gui/bg.png", false)
	WINDOW.close = guiCreateStaticImage(screenX/2+600/2-32/2, screenY/2-360/2-32/2, 32, 32, "assets/gui/b_close.png", false)
	setElementParent(WINDOW.close, WINDOW.back)

	WINDOW.image = guiCreateStaticImage(0, 0, 240, 360, "assets/gui/img_1.png", false, WINDOW.back)
	guiSetVisible(WINDOW.image, false)

	WINDOW.info_label = guiCreateLabel(270, 30, 200, 20, "ИНФОРМАЦИЯ", false, WINDOW.back)
	guiSetFont(WINDOW.info_label, FONT["RB"] )
	guiLabelSetColor(WINDOW.info_label, 153, 156, 175)

	WINDOW.info = guiCreateLabel(270, 60, 400, 100, "", false, WINDOW.back)
	guiSetFont(WINDOW.info, FONT["RR"] )
	guiLabelSetColor(WINDOW.info, 0, 0, 0)

	WINDOW.change_label = guiCreateLabel(270, 130, 220, 20, "ВЫБИРИТЕ СПЕЦИАЛЬНОСТЬ", false, WINDOW.back)
	guiSetFont(WINDOW.change_label, FONT["RB"] )
	guiLabelSetColor(WINDOW.change_label, 153, 156, 175)

	WINDOW.loader_button, WINDOW.loader_button_mouse, WINDOW.loader_button_job = buttons:new(WINDOW.SPECIALTY[1], WINDOW.back)
	WINDOW.forklift_button, WINDOW.forklift_button_mouse, WINDOW.forklift_button_job = buttons:new(WINDOW.SPECIALTY[2], WINDOW.back)
	WINDOW.driver_button, WINDOW.driver_button_mouse, WINDOW.driver_button_job = buttons:new(WINDOW.SPECIALTY[3], WINDOW.back)

	WINDOW.loader_button:setButtonActiveOnClick(true) -- грузчик
end

local function showDockWindow()
	windowVisible = not windowVisible
	showChat(not windowVisible)
	showCursor(windowVisible)
	setElementData(localPlayer, "player.ACTIVE_UI", windowVisible)
	triggerEvent("rmta_showui.setVisiblePlayerUI", getRootElement(), not windowVisible)

	if windowVisible then 
		drawDockWindow() -- ОКНО
	else
		destroyElement(WINDOW.back)
	end
end

addEventHandler("onClientGUIClick", getRootElement(), function()
	if not windowVisible then return end
	guiMoveToBack(WINDOW.back)
	
	if source == WINDOW.loader_button_mouse then
		if (tonumber(getElementData(localPlayer, "player.LEVEL")) >= tonumber(WINDOW.SPECIALTY[1].lvl)) then
			WINDOW.forklift_button:setButtonActiveOnClick(false)
			WINDOW.driver_button:setButtonActiveOnClick(false)
			WINDOW.loader_button:setButtonActiveOnClick(true)
		end
	elseif source == WINDOW.forklift_button_mouse then
		if (tonumber(getElementData(localPlayer, "player.LEVEL")) >= tonumber(WINDOW.SPECIALTY[2].lvl)) then
			WINDOW.loader_button:setButtonActiveOnClick(false)
			WINDOW.driver_button:setButtonActiveOnClick(false)
			WINDOW.forklift_button:setButtonActiveOnClick(true)
		end
	elseif source == WINDOW.driver_button_mouse then
		if (tonumber(getElementData(localPlayer, "player.LEVEL")) >= tonumber(WINDOW.SPECIALTY[3].lvl)) then
			WINDOW.loader_button:setButtonActiveOnClick(false)
			WINDOW.forklift_button:setButtonActiveOnClick(false)
			WINDOW.driver_button:setButtonActiveOnClick(true)
		end
	end
	
	-- Приступить к работе
	if source == WINDOW.loader_button_job then -- грузчик
		showDockWindow()
		triggerServerEvent("rmta_dock.employedPlayer", getRootElement(), localPlayer, 'loader')
	elseif source == WINDOW.forklift_button_job then -- оператор
		showDockWindow()
		triggerServerEvent("rmta_dock.employedPlayer", getRootElement(), localPlayer, 'forklift')
	elseif source == WINDOW.driver_button_job then -- водитель
		showDockWindow()
		triggerServerEvent("rmta_dock.employedPlayer", getRootElement(), localPlayer, 'driver')
	end

	-- Уволитья с работы
	if source == WINDOW.button_quit then
		showDockWindow()
		triggerServerEvent("rmta_dock.dismissalPlayer", getRootElement(), localPlayer)
	end

	if source == WINDOW.close then
		showDockWindow()
	end
end)

addEventHandler("onClientMouseEnter", getRootElement(), function ()
	if not windowVisible then return end
	
	if source == WINDOW.loader_button_job or source == WINDOW.forklift_button_job or source == WINDOW.driver_button_job then
		guiStaticImageLoadImage(source, "assets/gui/b_start.png")
	end
	
	if source == WINDOW.close then
		guiStaticImageLoadImage(source, "assets/gui/b_close_a.png")
	elseif source == WINDOW.button_quit then
		guiStaticImageLoadImage(source, "assets/gui/btn_a.png")
	end
end)

addEventHandler("onClientMouseLeave", getRootElement(), function ()
	if not windowVisible then return end

	if source == WINDOW.loader_button_job or source == WINDOW.forklift_button_job or source == WINDOW.driver_button_job then
		guiStaticImageLoadImage(source, "assets/gui/b_start_a.png")
	end

	if source == WINDOW.close then
		guiStaticImageLoadImage(source, "assets/gui/b_close.png")
	elseif source == WINDOW.button_quit then
		guiStaticImageLoadImage(source, "assets/gui/btn.png")
	end
end)

local function showPlayerLoaderWindow()
	showDockWindow()
end
addEvent("onPlayerHitJobPickup", true)
addEventHandler("onPlayerHitJobPickup", getRootElement(), showPlayerLoaderWindow)
