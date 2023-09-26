function createHelpButton(x, y, w, text, font_scale, alpha, button)
	local TEXT_FONT = exports["rmta_fonts"]:createFontGui("RR.ttf", font_scale)

	-- РАСЧЕТ РАЗМЕРОВ
	local TEST_TEXT = guiCreateLabel(x, y, w, 26, text, false)
	guiSetFont(TEST_TEXT, TEXT_FONT)
	local WIDTH, HEIGHT = guiLabelGetTextExtent(TEST_TEXT), guiLabelGetFontHeight(TEST_TEXT)
	destroyElement(TEST_TEXT)

	-- ЦЕНТРАЛЬНАЯ ПАНЕЛЬ
	local HELP_PANEL = guiCreateStaticImage(x, y, WIDTH+5+26, HEIGHT+10, "assets/panel/pane.png", false)
	guiSetProperty(HELP_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_PANEL, alpha)
	guiSetEnabled(HELP_PANEL, false)

	-- ЛЕВЫЙ КРАЙ
	local HELP_LEFT_UP = guiCreateStaticImage(x-6, y, 6, 6, "assets/panel/round_1.png", false)
	guiSetProperty(HELP_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_UP, alpha)
	setElementParent(HELP_LEFT_UP, HELP_PANEL)

	local HELP_LEFT_CENTER = guiCreateStaticImage(x-6, y+6, 6, HEIGHT-2, "assets/panel/pane.png", false)
	guiSetProperty(HELP_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_CENTER, alpha)
	setElementParent(HELP_LEFT_CENTER, HELP_PANEL)

	local HELP_LEFT_DOWN = guiCreateStaticImage(x-6, y+10+HEIGHT-6, 6, 6, "assets/panel/round_4.png", false)
	guiSetProperty(HELP_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_DOWN, alpha)
	setElementParent(HELP_LEFT_DOWN, HELP_PANEL)

	-- ПРАВЫЙ КРАЙ
	local HELP_RIGHT_UP = guiCreateStaticImage(x+WIDTH+26+5, y, 6, 6, "assets/panel/round_2.png", false)
	guiSetProperty(HELP_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_UP, alpha)
	setElementParent(HELP_RIGHT_UP, HELP_PANEL)

	local HELP_RIGHT_CENTER = guiCreateStaticImage(x+WIDTH+26+5, y+6, 6, HEIGHT-2, "assets/panel/pane.png", false)
	guiSetProperty(HELP_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_CENTER, alpha)
	setElementParent(HELP_RIGHT_CENTER, HELP_PANEL)

	local HELP_RIGHT_DOWN = guiCreateStaticImage(x+WIDTH+26+5, y+10+HEIGHT-6, 6, 6, "assets/panel/round_3.png", false)
	guiSetProperty(HELP_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_DOWN, alpha)
	setElementParent(HELP_RIGHT_DOWN, HELP_PANEL)

	-- ТЕКСТ
	local HELP_TEXT = guiCreateLabel(x, y+5, WIDTH, HEIGHT, text, false)
	guiLabelSetHorizontalAlign(HELP_TEXT, "center")
	guiSetFont(HELP_TEXT, TEXT_FONT)
	setElementParent(HELP_TEXT, HELP_PANEL)
	
	-- КНОПКА
	if button ~= "" then
		local HELP_BUTTON = guiCreateStaticImage(WIDTH+5, HEIGHT/2-13+5, 26, 26, "assets/"..button..".png", false, HELP_PANEL)
		guiSetEnabled(HELP_BUTTON, false)
	end

	return HELP_PANEL
end

--createHelpButton(500, 200, 150, "Переместить", 12, 0.7, "b_enter")

function createRectangle(x, y, w, h, alpha, round)
	local RECTANGLE_PANEL = guiCreateStaticImage(x, y, w, h, "assets/panel/pane.png", false)
	guiSetProperty(RECTANGLE_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(RECTANGLE_PANEL, alpha)
	guiSetEnabled(RECTANGLE_PANEL, false)

	if round then
		-- ЛЕВЫЙ КРАЙ
		local RECTANGLE_LEFT_UP = guiCreateStaticImage(x-6, y, 6, 6, "assets/panel/round_1.png", false)
		guiSetProperty(RECTANGLE_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_UP, alpha)
		setElementParent(RECTANGLE_LEFT_UP, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_CENTER = guiCreateStaticImage(x-6, y+6, 6, h-12, "assets/panel/pane.png", false)
		guiSetProperty(RECTANGLE_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_CENTER, alpha)
		setElementParent(RECTANGLE_LEFT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_DOWN = guiCreateStaticImage(x-6, y+h-6, 6, 6, "assets/panel/round_4.png", false)
		guiSetProperty(RECTANGLE_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_DOWN, alpha)
		setElementParent(RECTANGLE_LEFT_DOWN, RECTANGLE_PANEL)

		-- ПРАВЫЙ КРАЙ
		local RECTANGLE_RIGHT_UP = guiCreateStaticImage(x+w, y, 6, 6, "assets/panel/round_2.png", false)
		guiSetProperty(RECTANGLE_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_UP, alpha)
		setElementParent(RECTANGLE_RIGHT_UP, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_CENTER = guiCreateStaticImage(x+w, y+6, 6, h-12, "assets/panel/pane.png", false)
		guiSetProperty(RECTANGLE_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_CENTER, alpha)
		setElementParent(RECTANGLE_RIGHT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_DOWN = guiCreateStaticImage(x+w, y+h-6, 6, 6, "assets/panel/round_3.png", false)
		guiSetProperty(RECTANGLE_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_DOWN, alpha)
		setElementParent(RECTANGLE_RIGHT_DOWN, RECTANGLE_PANEL)
	end

	return RECTANGLE_PANEL
end

function setRectangleSize(rectangle, width, height)
	local elements = getElementChildren(rectangle)
	local rectangle_x, rectangle_y = guiGetPosition(rectangle, false)
	local rectangle_w, rectangle_h = guiGetSize(rectangle, false)
	guiSetSize(rectangle, width, height, false)
	for k, v in ipairs(elements) do
		if getElementType(v) == 'gui-staticimage' then
			local element_x, element_y = guiGetPosition(v, false)
			if tonumber(rectangle_x + rectangle_w) == tonumber(element_x) then
				guiSetPosition(v, rectangle_x + width, element_y, false)
			end
		end
	end
end