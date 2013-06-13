local provider = XLGetGlobal("VisualAssistant.UIProvider")
local g_treeObj = provider.GetTreeData()
local g_RectHelper = provider.GetRectHelper()
local g_ListObj = provider.GetPropertyList()


function OnInitControl(self)	
	g_RectHelper:AttachRectChangeEvent(function(item)
		if item then
			local rect = item.Value.rect
			local parentRect = nil
			if not item.Parent.Value then
				local select = g_treeObj:GetSelect()
				parentRect = select.Value.rect
			else
				parentRect = item.Parent.Value.rect
			end
			g_ListObj:SetItemList({
			{Name = "left", Value =tostring(rect.left - parentRect.left)},
			{Name = "top", Value = rect.top-parentRect.top},
			{Name = "width", Value = rect.right - rect.left},
			{Name = "height", Value = rect.bottom-rect.top},
			})
		else
			g_ListObj:SetItemList({})
		end
	end)
	local listObj = self:GetControlObject("list")

	g_ListObj:AttachEvent("OnListChange", function(count) 
		listObj:SetItemCount(count)
	end)
end

function InsertItem(self,name, value, bUpdateUI)

--[[	local data=
	{
		Name = name,
		Value = value,
	}
	
	local listObj = self:GetControlObject("list")
	listObj:InsertItem(data, bUpdateUI, nil, bUpdateUI)]]
end


function GetSelectedFolders(self)
	--[[local listObj = self:GetControlObject("list")
	local dataList = listObj:GetAllItem()
	local res = {}
	for i = 1,#dataList do
		local data = dataList[i]
		if data.SetCheck then
			table.insert(res,data.FolderPath)
		end
	end
	return res]]
end

function InsertItems(self, DataList)
	--[[local listObj = self:GetControlObject("list")
	listObj:ClearItems()
	listObj:InsertItemList(DataList, true, nil, true)]]
end

function GetDataList(self)
	--[[local listObj = self:GetControlObject("list")
	local dataList = listObj:GetAllItem()]]
end

function list_OnInitItem(self,_,index, obj)
	--[[local item = g_ListObj:GetItem(index)
	obj:SetName(item.Name)
	obj:SetValue(item.Value)]]
end

function list_OnUpdateView(self,_,list)
	for index, obj in pairs(list) do
		local item = g_ListObj:GetItem(index)
		obj:SetName(item.Name)
		obj:SetValue(item.Value)	
	end
end

function item_SetName(self, text)
	local name = self:GetControlObject("name")
	local attr = self:GetAttribute()
	attr.Name = text
	name:SetText(text)
end

function item_SetValue(self, text)
	local value = self:GetControlObject("value")
	value:SetText(text)
end

function SetRect(name, value)
	local item = g_RectHelper:GetRect()
	item.Value.rect[name] = value
	g_RectHelper:FireRectChangeEvent()
end
g_PosTable = {left = SetRect,top = SetRect,width = SetRect,height = SetRect}
function value_OnTextChange(self, _, text)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	--XLMessageBox("attr.Name="..tostring(attr.Name)..",fun="..tostring(g_PosTable[attr.Name]))
	if g_PosTable[attr.Name] then
		g_PosTable[attr.Name](attr.Name,tonumber(text))
	end
	self:SetText(text)
end

