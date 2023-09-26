local objects = {
	{id = 5145, txd = "assets/dock_ls/docks_las2.txd", dff = "assets/dock_ls/sanpdmdock2_las2.dff", col = "assets/dock_ls/docks_las2.col"}, -- порт LS
	{id = 900, txd = "assets/1.txd", dff = "assets/1.dff", col = "assets/1.col"}
}

addEventHandler ( 'onClientResourceStart', resourceRoot, function () 
	for _, v in ipairs(objects) do
	    local txd = engineLoadTXD (v.txd)
        engineImportTXD (txd, v.id)

        local dff = engineLoadDFF (v.dff, 0)
        engineReplaceModel (dff, v.id)
  
        local col = engineLoadCOL (v.col)
        engineReplaceCOL (col, v.id)
	end
end) 