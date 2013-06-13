local provider = XLGetGlobal("VisualAssistant.UIProvider")
local g_treeObj = provider.GetTreeData()

function OnInitControl(self)
	local attr = self:GetAttribute()
	attr.TreeObj = g_treeObj
--[[
	for i = 1,10 do 
		local item = g_treeObj:InsertValue({text = "HelloParent"..i})
		local item2 = g_treeObj:InsertValue({text = "HelloChild"..i}, item)
		g_treeObj:InsertValue({text = "HelloChild2"..i}, item2)
		
	end]]
	
	g_treeObj:AttachEvent("OnListChange", function(count)
		XLPrint("lxw VissuaAssistant, Tree,count="..count)
		local list = self:GetControlObject("list")	
		list:SetItemCount(count)		
	end)
	
	g_treeObj:AttachEvent("OnRemoveItem", function(item)
		local index = g_treeObj:FindItemInList(item.Parent)
		if index then
			local list = self:GetControlObject("list")
			list:Navigate(index)
		end
	end)	
	--g_treeObj:UpdateUI()
end

function Item_SetLevel(self, nLevel)
	local bkg = self:GetControlObject("bkg")
	bkg:SetObjPos2(nLevel*10,0,"father.width","father.height")
end

function list_OnInitItem(self, _,index, obj)
--[[	local list = g_treeObj:GetList()
	--XLMessageBox(index)
	local itemData = list[index]
	if itemData then
		Item_SetLevel(obj, itemData.Level)
		local objAttr = obj:GetAttribute()
		objAttr.itemData = itemData
	else
		XLPrint("lxw VissuaAssistant, Tree,index="..index)
	end]]
end

function Item_SetExpand(self, bexpand)
	local expand = self:GetControlObject("expand")
	local attr = self:GetAttribute()
	local itemData = attr.itemData
	if #itemData.Children >0 then
		if bexpand then
			expand:SetResID("bitmap.categorytree.expanded.normal")
		else
			expand:SetResID("bitmap.categorytree.unexpanded.normal")
		end
	else
		expand:SetResID("")
	end
end

function Item_OnLButtonDown(self)
	local attr = self:GetAttribute()
	local itemData = attr.itemData
	g_treeObj:SetSelect(itemData)
	local list = self:GetOwnerControl()
	list:UpdateUI()
end

function Item_OnLButtonDbClick(self)
	local attr = self:GetAttribute()
	local itemData = attr.itemData
	local bExpand = g_treeObj:SetExpandItem(itemData)
end


function list_OnUpdateView(self, _,map)
	for k,obj in pairs(map) do
		local list = g_treeObj:GetList()
		--XLMessageBox(index)
		local itemData = list[k]
		
		local attr = obj:GetAttribute()
		attr.itemData = itemData
		obj:SetExpand(itemData.IsExpand)
		obj:SetLevel(itemData.Level)
		local value = itemData.Value
		obj:SetText(value.text)
		local ctrl = self:GetOwnerControl()
		obj:SetSelect(g_treeObj:GetSelect() == itemData)

	end
end

function Item_SetText(self, text)
	local textObj = self:GetControlObject("text")
	textObj:SetText(text)
end

function Item_SetSelect(self, bSelect)
	local attr = self:GetAttribute()
	local itemData = attr.itemData
	local bkg = self:GetControlObject("SelectBkg")
	if bSelect then
		bkg:SetTextureID("texture.listctrl.item.bkg.select")
	else
		bkg:SetTextureID("")
	end
end

function GetSelectItem(self)
--[[	local attr = self:GetAttribute()
	return attr.SelectItemData]]
end

function SetSelectItem(self, itemData)
	--[[local attr = self:GetAttribute()
	attr.SelectItemData = itemData
	local list = self:GetControlObject("list")
	list:UpdateUI()]]
end

function expand_OnLButtonDown(self)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	local itemData = attr.itemData
	local bExpand = g_treeObj:SetExpandItem(itemData)
end

function Item_OnInitControl(self)
	res = self:SetRedirect("OnKeyDown","control")
	--XLMessageBox("res="..tostring(res))
end

function list_OnKeyDown(self, char)
	--XLMessageBox("char="..tostring(char))
	if char == 46 then
		local item = g_treeObj:GetSelect()
		g_treeObj:RemoveItem(item)
	end
end