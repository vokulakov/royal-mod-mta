editBox = {}

function createEditBox(ID, x, y, text, parent, mask)
	editBox[ID] = {}
	editBox[ID].text = text
	editBox[ID].active = false
	editBox[ID].mask = mask
	editBox[ID].text_mask = ""
	
	editBox[ID].flag = nil
	
	editBox[ID].back = guiCreateStaticImage(x, y, 260, 26, "assets/editbox.png", false, parent)
	
	editBox[ID].label_text = guiCreateLabel (0, 0.05, 1, 1, editBox[ID].text, true, editBox[ID].back)
	guiSetFont(editBox[ID].label_text, login.font["RR_editbox"])
	guiLabelSetColor(editBox[ID].label_text, 34, 34, 34)
	
	editBox[ID].label_warning_text = guiCreateLabel (x, y+25, 260, 20, "", false, parent)
	guiSetFont(editBox[ID].label_warning_text, login.font["RL_warning"])
	guiLabelSetColor(editBox[ID].label_warning_text, 214, 84, 71)
	
	editBox[ID].ierror = guiCreateStaticImage(250, 5, 10, 10, "assets/ierror.png", false, editBox[ID].back)
	guiSetVisible(editBox[ID].ierror, false)
	
	setEditBoxText(ID, text)
	
	editBox[ID].line_active = guiCreateStaticImage(0, 5, 1, 14, "assets/line.png", false, editBox[ID].back)
	guiSetVisible(editBox[ID].line_active, false)
	
	addEventHandler("onClientMouseEnter", getRootElement(), function()
		if (source == editBox[ID].back or source == editBox[ID].label_text) then
			if editBox[ID].active then return end
			guiStaticImageLoadImage(editBox[ID].back, "assets/editbox_a.png")
			
			if guiGetVisible(editBox[ID].ierror) then
				if editBox[ID].flag then
					guiStaticImageLoadImage(editBox[ID].ierror, "assets/iaccept.png")
				else
					guiStaticImageLoadImage(editBox[ID].ierror, "assets/ierror.png")
				end
			end
			
		end
	end)
	
	addEventHandler("onClientMouseLeave", getRootElement(), function()
		if (source == editBox[ID].back or source == editBox[ID].label_text) then
			if editBox[ID].active then return end
			guiStaticImageLoadImage(editBox[ID].back, "assets/editbox.png")
			
			if guiGetVisible(editBox[ID].ierror) then
				if editBox[ID].flag then
					guiStaticImageLoadImage(editBox[ID].ierror, "assets/iaccept.png")
				else
					guiStaticImageLoadImage(editBox[ID].ierror, "assets/ierror.png")
				end
			end
		end
	end)
	
	addEventHandler ( "onClientGUIClick", getRootElement(), function(button)
		if (button == "left" and source == editBox[ID].back or source == editBox[ID].label_text) then
			if not editBox[ID].active then 
				editBox[ID].active = true
				guiStaticImageLoadImage(editBox[ID].back, "assets/editbox_a.png")
				guiSetPosition(editBox[ID].line_active, guiLabelGetTextExtent(editBox[ID].label_text), 5, false)
				editBox[ID].timer = setTimer(showLineActive, 1000, 0, editBox[ID].line_active)
				
				if guiGetVisible(editBox[ID].ierror) then
					if editBox[ID].flag then
						guiStaticImageLoadImage(editBox[ID].ierror, "assets/iaccept.png")
					else
						guiStaticImageLoadImage(editBox[ID].ierror, "assets/ierror.png")
					end
				end
			
			end
		else
			if editBox[ID].active then
				editBox[ID].active = false
				guiStaticImageLoadImage(editBox[ID].back, "assets/editbox.png")
				guiSetVisible(editBox[ID].line_active, false)
				
				if guiGetVisible(editBox[ID].ierror) then
					guiStaticImageLoadImage(editBox[ID].ierror, "assets/ierror.png")
				end
				
				if isTimer(editBox[ID].timer) then killTimer(editBox[ID].timer) end
				if isTimer(editBox[ID].timer_dc) then killTimer(editBox[ID].timer_dc) end
			end
		end
	end)
	
	-- Работа с текстом
	addEventHandler("onClientCharacter", getRootElement(), function(character)
		if editBox[ID].active then
			if (editBox[ID].text:len() > 29) then return end
			editBox[ID].text = editBox[ID].text..character
			editBox[ID].text_mask = setCharacterMask(ID)
			guiSetText(editBox[ID].label_text, editBox[ID].text_mask)
			guiSetPosition(editBox[ID].line_active, guiLabelGetTextExtent(editBox[ID].label_text), 5, false)
			
			
			guiSetText(editBox[ID].label_warning_text, "")
			guiSetVisible(editBox[ID].ierror, false)
		end
	end)
	
	addEventHandler( "onClientKey", getRootElement(), function(button, press) 
		if (button == "backspace") then
			if not editBox[ID].active then return end
			if press then
				editBox[ID].text = deleteCharacterOnEditBox(editBox[ID].text)
				editBox[ID].text_mask = getCharacterMask(ID)
				guiSetText(editBox[ID].label_text, editBox[ID].text_mask)
				guiSetPosition(editBox[ID].line_active, guiLabelGetTextExtent(editBox[ID].label_text), 5, false)
				
				guiSetText(editBox[ID].label_warning_text, "")
				guiSetVisible(editBox[ID].ierror, false)
			end
		end
	end)
	
end

function deleteCharacterOnEditBox(element)
	if(element:len() == 0) then return element end
	local s = string.byte(element:sub(element:len(), element:len()))
	if( s > 127 and s < 256) then 
		element = string.sub(element, 0, element:len() - 2)
	else
		element = string.sub(element, 0, element:len() - 1)
	end
	return element
end

function showLineActive(element)
	if not element then return end
	if not guiGetVisible(element) then
		guiSetVisible(element, true)
		guiStaticImageLoadImage(element, "assets/line.png")
	else
		guiSetVisible(element, false)
	end
end	

function setEditBoxText(id, text)
	editBox[id].text = ""
	editBox[id].text_mask = ""
	editBox[id].text = text
	if text == "" then return end
	if editBox[id].mask then
		local value = 0
		repeat
			local s = string.byte(text:sub(text:len(), text:len()))
			if( s > 127 and s < 256) then
				text = string.sub(text, 0, text:len() - 2)
			else
				text = string.sub(text, 0, text:len() - 1)
			end
			value = value + 1
		until text == "" 
		for i = 1, value do
			editBox[id].text_mask = editBox[id].text_mask.."•"
			guiSetText(editBox[id].label_text, editBox[id].text_mask)
		end
	else
		guiSetText(editBox[id].label_text, text)
	end
end

function setEditBoxWarning(id, text, flag)
	guiSetText(editBox[id].label_warning_text, text)
	guiSetVisible(editBox[id].ierror, true)
	editBox[id].flag = flag
	if flag then
		guiStaticImageLoadImage(editBox[id].ierror, "assets/iaccept.png")
	else
		guiStaticImageLoadImage(editBox[id].ierror, "assets/ierror.png")
	end
end

function setCharacterMask(id)
	if not editBox[id].mask then return editBox[id].text end
	local newText = editBox[id].text_mask.."•"
	return newText
end

function getCharacterMask(id)
	if not editBox[id].mask then return editBox[id].text end
	if(editBox[id].text_mask:len() == 0) then return editBox[id].text_mask end
	local newText = string.sub(editBox[id].text_mask, 0, editBox[id].text_mask:len() - 3)
	return newText
end