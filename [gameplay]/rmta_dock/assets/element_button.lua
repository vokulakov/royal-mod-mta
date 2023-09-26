buttons = {}

function buttons:new(data, parent)
	local BUTTON = {}
	BUTTON.active = false

	BUTTON.back = guiCreateStaticImage(data.x, data.y, 240, 50, "assets/gui/box.png", false, parent)
	BUTTON.image = guiCreateStaticImage(0, 0, 50, 50, data.icon, false, BUTTON.back)
	
	BUTTON.job_button = guiCreateStaticImage(data.x+250, data.y+10, 32, 32, "assets/gui/b_start_a.png", false, parent)
	guiSetVisible(BUTTON.job_button, false)

	BUTTON.name_label = guiCreateLabel(55, 5, 200, 20, data.name, false, BUTTON.back)
	guiSetFont(BUTTON.name_label, FONT["RB"] )
	guiLabelSetColor(BUTTON.name_label, 153, 156, 175)

	BUTTON.info_label = guiCreateLabel(55, 20, 200, 40, "Приступить к работе", false, BUTTON.back)
	guiSetFont(BUTTON.info_label, FONT["RR"] )
	guiLabelSetColor(BUTTON.info_label, 0, 0, 0)

	if (tonumber(getElementData(localPlayer, "player.LEVEL")) < tonumber(data.lvl)) then
		guiSetText(BUTTON.info_label, "Требуется "..data.lvl.." уровень")
	end

	BUTTON.mouse = guiCreateLabel(data.x, data.y, 240, 50, "", false, parent)

	setmetatable(BUTTON, self)
	self._index = self

	function BUTTON:setButtonActive(state) 
		if state then
			guiLabelSetColor(BUTTON.name_label, 250, 87, 118)
			guiStaticImageLoadImage(BUTTON.back, "assets/gui/box_a.png")
			guiStaticImageLoadImage(BUTTON.image, data.icon)
			guiSetVisible(BUTTON.image, true)

			guiStaticImageLoadImage(WINDOW.image, data.image)
			guiSetText(WINDOW.info, data.text)
			guiSetVisible(WINDOW.image, true)
		else
			guiLabelSetColor(BUTTON.name_label, 153, 156, 175)
			guiStaticImageLoadImage(BUTTON.back, "assets/gui/box.png")
			guiStaticImageLoadImage(BUTTON.image, data.icon)

			guiSetVisible(WINDOW.image, false)
			guiSetText(WINDOW.info, "")
		end
	end

	function BUTTON:setButtonActiveOnClick(state)
		guiSetVisible(BUTTON.job_button, state)
		self:setButtonActive(state)
		BUTTON.active = state
	end

	return BUTTON, BUTTON.mouse, BUTTON.job_button
end
