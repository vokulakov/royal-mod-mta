chekBox = {}

function createChekBox(ID, x, y, parent)
	chekBox[ID] = {}
	chekBox[ID].image = guiCreateStaticImage(x, y, 16, 16, "assets/checkbox.png", false, parent)
	chekBox[ID].active = false
	
	addEventHandler ("onClientGUIClick", getRootElement(), function(button)
		if button == "left" and source == chekBox[ID].image then
			if not chekBox[ID].active then
				chekBox[ID].active = true
				guiStaticImageLoadImage(chekBox[ID].image, "assets/checkbox_a.png")
			else
				chekBox[ID].active = false
				guiStaticImageLoadImage(chekBox[ID].image, "assets/checkbox.png")
			end
		end
	end)
end

function setChekBoxActive(ID, state)
	if state then
		chekBox[ID].active = true
		guiStaticImageLoadImage(chekBox[ID].image, "assets/checkbox_a.png")
	else
		chekBox[ID].active = false
		guiStaticImageLoadImage(chekBox[ID].image, "assets/checkbox.png")
	end
end