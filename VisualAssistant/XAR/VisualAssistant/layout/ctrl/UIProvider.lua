local g_Rect = nillocal g_Tree = nillocal g_List = nilfunction GetTreeData()	if not g_Tree then		local path = __document:gsub("[^\\/]*$","")		local treeHelper = XLLoadModule( path.."..\\Base\\tree.lua")		g_Tree = treeHelper:CreateTree()		end	return g_Treeendfunction GetRectHelper()	if not g_Rect then		local path = __document:gsub("[^\\/]*$","")		local RectHelper = XLLoadModule( path.."\\rectHelper.lua")		g_Rect = RectHelper:CreateRect()		end	return g_Rectendfunction GetPropertyList()	if not g_List then		local path = __document:gsub("[^\\/]*$","")		local Helper = XLLoadModule(path.."..\\Base\\list.lua")		g_List = Helper:CreateList()	end	return g_Listend