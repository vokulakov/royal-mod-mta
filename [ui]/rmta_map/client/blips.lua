LEGENDS_VISIBLE = false

local BLIPS = {
	{text = "Вы", url = "assets/local.png"}, -- локальный игрок
	{text = "Игрок", url = "assets/blips/0.png"},
	{text = "Работа грузчика", url = "assets/blips/12.png"},
	{text = "Автосервис", url = "assets/blips/18.png"},
} 

local TEXT_FONT = exports["rmta_fonts"]:createFontGui("RR.ttf", 12)

local function drawBlipRectangle(text, url, x, y)
	-- РАСЧЕТ РАЗМЕРОВ
	local TEST_TEXT = guiCreateLabel(x, y, 0, 0, text, false)
	guiSetFont(TEST_TEXT, TEXT_FONT)
	local WIDTH, HEIGHT = guiLabelGetTextExtent(TEST_TEXT), guiLabelGetFontHeight(TEST_TEXT)
	destroyElement(TEST_TEXT)
	-- ФОН
	local BLIP_BACKROUND = exports["rmta_buttons"]:createRectangle(mW-WIDTH+10-26, y, WIDTH+20+26, HEIGHT+8, 0.8, false)
	-- ТЕКСТ
	local BLIP_TEXT = guiCreateLabel(mW-WIDTH-8, y+4, WIDTH, HEIGHT, text, false)
	guiLabelSetHorizontalAlign(BLIP_TEXT, "center")
	guiSetFont(BLIP_TEXT, TEXT_FONT)
	setElementParent(BLIP_TEXT, BLIP_BACKROUND)
	-- BLIP
	local BLIP_IMAGE = guiCreateStaticImage(WIDTH+15, HEIGHT/2-13+4, 26, 26, url, false, BLIP_BACKROUND)

	return BLIP_BACKROUND
end

function legendsOfBlips(x, y, w, h)
	local RECTANGLE = exports["rmta_buttons"]:createRectangle(x, y, w, h, 0, false)

	local W = 0
	for i, data in ipairs(BLIPS) do
		LEGEND_BLIP = drawBlipRectangle(data.text, data.url, x, y+W*30)
		setElementParent(LEGEND_BLIP, RECTANGLE)
		W = W+1
	end

	return RECTANGLE
end