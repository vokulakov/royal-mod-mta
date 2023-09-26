local screenW, screenH = guiGetScreenSize()
local TEXTURE_MAP = "assets/map.jpg" -- карта
local TEXTURE_WATER = "assets/water.jpg" -- вода

local MAP_VISIBLE = false -- видимость карты
local MAP_WORLD_WIDTH, MAP_WORLD_HEIGHT = 3072, 3072 -- размер карты

local MAP_MARGIN = 40 -- отступ от краёв экрана
local MAP_WIDTH, MAP_HEIGHT = screenW-MAP_MARGIN*2, screenH-MAP_MARGIN*2
local MAX_MAP_MARGIN = 30 -- ограничение перемещения карты

local mapRenderTarget = dxCreateRenderTarget(MAP_WIDTH, MAP_HEIGHT, true)
mW, mH = dxGetMaterialSize(mapRenderTarget)

local ZOOM = 1 -- начальный зум
local ZOOM_MIN = 1 -- минимальный зум
local ZOOM_MAX = 2 -- максимальный зум
local ZOOM_SPEED = 0.05 -- скорость зума

local MAP_X, MAP_Y = mW/2-MAP_WORLD_WIDTH/2/ZOOM, mH/2-MAP_WORLD_HEIGHT/2/ZOOM
local ZOOM_X, ZOOM_Y = 0, 0

local function getPlayerFromMap() -- центрирование карты
	local posxP, posyP, poszP = getElementPosition(localPlayer)
	local mapx = math.floor(MAP_WORLD_WIDTH/6000*(posxP*-1-3000))
	local mapy = math.floor(MAP_WORLD_HEIGHT/6000*(posyP-3000))
	ZOOM = ZOOM_MIN
	MAP_X, MAP_Y = mapx/ZOOM+mW/2, mapy/ZOOM+mH/2 -- перемещение на центр
	getMapLimit() 
	-- ДАННЫЕ ДЛЯ МАСШТАБИРОВАНИЯ КАРТЫ
	ZOOM_X = ((mW/2)-(MAP_X+(MAP_WORLD_WIDTH/ZOOM)/2))*ZOOM
	ZOOM_Y = ((mH/2)-(MAP_Y+(MAP_WORLD_HEIGHT/ZOOM)/2))*ZOOM

end

local function getMapFromWorldPosition(worldX, worldY) -- позиция на карте по позиции в мире
	local X = MAP_X+MAP_WORLD_WIDTH/6000*(worldX-(-3000))/ZOOM
	local Y = MAP_Y+MAP_WORLD_HEIGHT/6000*(3000-worldY)/ZOOM
	return X, Y
end

local function getPlayerLocation(posxP, posyP, poszP) -- локация игрока
	local POSITION_ZONE = getZoneName(posxP, posyP, poszP).." / "..getZoneName(posxP, posyP, poszP, true)
	guiSetText(HELP_POSITION_LABEL, POSITION_ZONE)
	local POSITION_ZONE_WIDTH = guiLabelGetTextExtent(HELP_POSITION_LABEL)
	guiSetSize(HELP_POSITION_LABEL, POSITION_ZONE_WIDTH, 30, false)
	exports["rmta_buttons"]:setRectangleSize(HELP_POSITION_BAR, POSITION_ZONE_WIDTH, 30)
end

local function drawMap() -- КАРТА
	local posxP, posyP, poszP = getElementPosition(localPlayer)
	local _, _, rotzP = getElementRotation(localPlayer)
	local pX, pY = getMapFromWorldPosition(posxP, posyP)

	getPlayerLocation(posxP, posyP, poszP)

	dxSetRenderTarget(mapRenderTarget)
		dxDrawImage(0, 0, mW, mH, TEXTURE_WATER)
		dxDrawImage(MAP_X, MAP_Y, MAP_WORLD_WIDTH/ZOOM, MAP_WORLD_HEIGHT/ZOOM, TEXTURE_MAP, 0, 0, 0, tocolor(255, 255, 255, 255))

		-- Положение игроков
		for _, player in ipairs(getElementsByType("player")) do
			if player ~= localPlayer then 
				local px, py = getElementPosition(player)
				local pX, pY = getMapFromWorldPosition(px, py)
				dxDrawImage(pX-(15/ZOOM)/2, pY-(15/ZOOM)/2, 15/ZOOM, 15/ZOOM, "assets/blips/0.png", camRotZ, 0, 0, tocolor(255, 0, 0, 255))
			end
		end

		dxDrawImage(pX-(20/ZOOM)/2, pY-(20/ZOOM)/2, 20/ZOOM, 20/ZOOM, "assets/local.png", (-rotzP)%360, 0, 0, tocolor(255, 255, 255, 255)) -- позиция игрока
	dxSetRenderTarget()
	dxDrawImage(MAP_MARGIN, MAP_MARGIN, mW, mH, mapRenderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

local function showRectangleMap() -- РАМКА КАРТЫ
	local MAP_RECTANGLE_LEFT = exports["rmta_buttons"]:createRectangle(MAP_MARGIN-5, MAP_MARGIN-5, 5, MAP_HEIGHT+10, 0.7, false)
	local MAP_RECTANGLE_RIGHT = exports["rmta_buttons"]:createRectangle(MAP_MARGIN+MAP_WIDTH, MAP_MARGIN-5, 5, MAP_HEIGHT+10, 0.7, false)
	setElementParent(MAP_RECTANGLE_RIGHT, MAP_RECTANGLE_LEFT)
	local MAP_RECTANGLE_UP = exports["rmta_buttons"]:createRectangle(MAP_MARGIN, MAP_MARGIN-5, MAP_WIDTH, 5, 0.7, false)
	setElementParent(MAP_RECTANGLE_UP, MAP_RECTANGLE_LEFT)
	local MAP_RECTANGLE_DOWN = exports["rmta_buttons"]:createRectangle(MAP_MARGIN, MAP_MARGIN+MAP_HEIGHT, MAP_WIDTH, 5, 0.7, false)
	setElementParent(MAP_RECTANGLE_DOWN, MAP_RECTANGLE_LEFT)

	return MAP_RECTANGLE_LEFT
end

local function helpBar() -- подсказки
	local HELP_FONT = exports["rmta_fonts"]:createFontGui("RR.ttf", 12)
	-- ПАНЕЛЬ ПОМОЩИ
	local HELP_PANEL = exports["rmta_buttons"]:createRectangle(mW-460+25, screenH-MAP_MARGIN-35, 460, 30, 0.7, true)

	local HELP_MOVE_L = exports["rmta_buttons"]:createHelpButton(mW-435, screenH-MAP_MARGIN-35, 0, "Перемещение", 12, 0, "mouse_left")
	setElementParent(HELP_MOVE_L, HELP_PANEL)

	local HELP_ZOOM_L = exports["rmta_buttons"]:createHelpButton(mW-290, screenH-MAP_MARGIN-35, 0, "Масштаб", 12, 0, "mouse_wheel")
	setElementParent(HELP_ZOOM_L, HELP_PANEL)

	local HELP_LEGEND_L = exports["rmta_buttons"]:createHelpButton(mW-177, screenH-MAP_MARGIN-35, 0, "Легенда", 12, 0, "b_space")
	setElementParent(HELP_LEGEND_L, HELP_PANEL)

	local HELP_CLOSE_L = exports["rmta_buttons"]:createHelpButton(mW-73, screenH-MAP_MARGIN-35, 0, "Закрыть", 12, 0, "b_f11")
	setElementParent(HELP_CLOSE_L, HELP_PANEL)
	-- ИНФОРМАЦИЯ О ПОЛОЖЕНИЕ ИГРОКА
	HELP_POSITION_BAR = exports["rmta_buttons"]:createRectangle(screenW-mW-MAP_MARGIN+15, screenH-MAP_MARGIN-35, 230, 30, 0.7, true)
	setElementParent(HELP_POSITION_BAR, HELP_PANEL)
	HELP_POSITION_LABEL = guiCreateLabel(screenW-mW-MAP_MARGIN+15, screenH-MAP_MARGIN-30, 230, 30, "", false)
	setElementParent(HELP_POSITION_LABEL, HELP_POSITION_BAR)
	guiLabelSetHorizontalAlign(HELP_POSITION_LABEL, "center")
	guiSetFont(HELP_POSITION_LABEL, HELP_FONT)
	return HELP_PANEL
end

local function zoomingMAP()
	MAP_X = mW/2 - (MAP_WORLD_WIDTH/ZOOM)/2 - (ZOOM_X)/ZOOM
	MAP_Y = mH/2 - (MAP_WORLD_HEIGHT/ZOOM)/2 - (ZOOM_Y)/ZOOM
	getMapLimit()
end

addEventHandler( "onClientKey", root, function(button) -- изменение зума
	if not MAP_VISIBLE then return end
	if CLICK_MOVE then return end
    if button == "mouse_wheel_down" then
		if ZOOM < ZOOM_MAX then 
			ZOOM = ZOOM + ZOOM_SPEED
			zoomingMAP()
		end
	elseif button == "mouse_wheel_up" then
		if ZOOM > ZOOM_MIN then 
			ZOOM = ZOOM - ZOOM_SPEED 
			zoomingMAP()
		end
	end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY) 
	if not MAP_VISIBLE then return end
	if button == "left" then -- КЛИК ДЛЯ ПЕРЕМЕЩЕНИЯ КАРТЫ
		if state == "down" then
			if absoluteX > MAP_MARGIN and absoluteX < MAP_MARGIN+mW and absoluteY > MAP_MARGIN and absoluteY < MAP_MARGIN+mH then
				CLICK_MOVE = true
				moveX, moveY = absoluteX - MAP_X, absoluteY - MAP_Y
			end
		else
			CLICK_MOVE = false
		end
	elseif button == "right" then -- КЛИК ДЛЯ МЕТКИ
		if state == "down" then
		end
	end
end)

function getMapLimit() -- проверяем положение карты относительно рамки
	LIMIT_X, LIMIT_Y = mW-MAP_WORLD_WIDTH/ZOOM-MAX_MAP_MARGIN, mH-MAP_WORLD_HEIGHT/ZOOM-MAX_MAP_MARGIN 
	LIMIT_MAP_X, LIMIT_MAP_Y = LIMIT_X, LIMIT_Y

	if MAP_X >= MAX_MAP_MARGIN then -- если вышли за рамку слева
		LIMIT_MAP_X = MAP_X -- временная граница рамки слева
	elseif MAP_X/ZOOM <= LIMIT_X/ZOOM then -- если вышли за рамку справа
		LIMIT_MAP_X = MAP_X
	end

	if MAP_Y >= MAX_MAP_MARGIN then -- если вышли за рамку сверху
		LIMIT_MAP_Y = MAP_Y -- временная граница рамки сверху
	elseif MAP_Y/ZOOM <= LIMIT_Y/ZOOM then -- если вышли за рамку снизу
		LIMIT_MAP_Y = MAP_Y
	end

end

addEventHandler( "onClientCursorMove", getRootElement(), function(cursorX, cursorY, mouseX, mouseY) -- перемещение карты
	if not MAP_VISIBLE then return end
	if not CLICK_MOVE then return end
	if mouseX > MAP_MARGIN and mouseX < MAP_MARGIN+mW and mouseY > MAP_MARGIN and mouseY < MAP_MARGIN+mH then 	-- ПРОВЕРКА ПОЛОЖЕНИЯ КУРСОРА

		MAP_X, MAP_Y = mouseX-moveX, mouseY-moveY	

		if LIMIT_MAP_X > MAX_MAP_MARGIN then -- находимся за рамкой слева
			if MAP_X >= LIMIT_MAP_X then --  временная граница слева
				MAP_X = LIMIT_MAP_X
			elseif MAP_X <= MAX_MAP_MARGIN then -- вернулись в границу рами слева
				LIMIT_MAP_X = LIMIT_X
			end
		elseif MAP_X >= MAX_MAP_MARGIN then -- граница рамки слева
			MAP_X = MAX_MAP_MARGIN
		end

		if LIMIT_MAP_X < LIMIT_X/ZOOM then -- находимся за рамкой справа
			if MAP_X <= LIMIT_MAP_X then -- временная граница справа
				MAP_X = LIMIT_MAP_X
			elseif MAP_X/ZOOM >= LIMIT_X/ZOOM then -- вернулись в границу рамки справа
				LIMIT_MAP_X = LIMIT_X
			end
		elseif MAP_X/ZOOM <= LIMIT_X/ZOOM then -- граница рамки справа
			MAP_X = LIMIT_X
		end

		if LIMIT_MAP_Y > MAX_MAP_MARGIN then -- находися за рамкой сверху
			if MAP_Y >= LIMIT_MAP_Y then -- временная граница сверху
				MAP_Y = LIMIT_MAP_Y
			elseif MAP_Y <= MAX_MAP_MARGIN then -- вернулись в границу рамки сверху
				LIMIT_MAP_Y = LIMIT_Y
			end
		elseif MAP_Y >= MAX_MAP_MARGIN then -- граница рамки сверху
			MAP_Y = MAX_MAP_MARGIN
		end

		if LIMIT_MAP_Y < LIMIT_Y/ZOOM then -- находимся за рамкой снизу
			if MAP_Y <= LIMIT_MAP_Y then -- временная граница снизу
				MAP_Y = LIMIT_MAP_Y
			elseif MAP_Y/ZOOM >= LIMIT_Y/ZOOM then -- вернулись в границу рамки снизу
				LIMIT_MAP_Y = LIMIT_Y
			end
		elseif MAP_Y/ZOOM <= LIMIT_Y/ZOOM then -- граница рамки снизу
			MAP_Y = LIMIT_Y
		end

		-- ДАННЫЕ ДЛЯ МАСШТАБИРОВАНИЯ КАРТЫ
		ZOOM_X = ((mW/2)-(MAP_X+(MAP_WORLD_WIDTH/ZOOM)/2))*ZOOM
		ZOOM_Y = ((mH/2)-(MAP_Y+(MAP_WORLD_HEIGHT/ZOOM)/2))*ZOOM
	else
		CLICK_MOVE = false
	end
end)

local function showLegendsPanel() -- панель легенд
	if not MAP_VISIBLE then return end
	if LEGENDS_VISIBLE then
		destroyElement(HELP_LEGENDS_PANEL)
		LEGENDS_VISIBLE = false
	else
		HELP_LEGENDS_PANEL = legendsOfBlips(mW-260+30, MAP_MARGIN+10, 260, mH-MAP_MARGIN-35) 
		LEGENDS_VISIBLE = true
	end
end

local function showMap()
	if not getElementData(localPlayer, "player.ACTIVE_UI") == 'map' then return end
	local PLAYER_UI = getElementData(localPlayer, "player.UI")
	if not PLAYER_UI['map'] then return end
	if not MAP_VISIBLE then 
		MAP_BACKGROUND = showRectangleMap()
		HELP_BAR = helpBar()
		HELP_LEGENDS_PANEL = legendsOfBlips(mW-260+30, MAP_MARGIN+10, 260, mH-MAP_MARGIN-35) 
		LEGENDS_VISIBLE = true
		bindKey("space", "down", showLegendsPanel)
		getPlayerFromMap()
		addEventHandler("onClientPreRender", getRootElement(), drawMap)
		setElementData(localPlayer, "player.ACTIVE_UI", "map")
	else
		destroyElement(MAP_BACKGROUND)
		if LEGENDS_VISIBLE then 
			destroyElement(HELP_LEGENDS_PANEL)
			LEGENDS_VISIBLE = false
		end
		destroyElement(HELP_BAR)
		unbindKey("space", "down", showLegendsPanel)
		CLICK_MOVE = false
		removeEventHandler("onClientPreRender", getRootElement(), drawMap)
		setElementData(localPlayer, "player.ACTIVE_UI", false)
	end
	showChat(MAP_VISIBLE)
	showCursor(not MAP_VISIBLE)

	MAP_VISIBLE = not MAP_VISIBLE
	triggerEvent("rmta_showui.setVisiblePlayerUI", getRootElement(), not MAP_VISIBLE)
	triggerEvent("rmta_showui.setVisiblePlayerComponentUI", getRootElement(), "map", true)
end

addEventHandler("onClientResourceStart", resourceRoot, function()
	bindKey("f11", "down", showMap)
end)

addEventHandler("onClientResourceStop", resourceRoot, function() -- отключение ресурса
	unbindKey("f11", "down", showMap)
end)

