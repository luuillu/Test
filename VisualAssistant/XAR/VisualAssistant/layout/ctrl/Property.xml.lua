local provider = XLGetGlobal("VisualAssistant.UIProvider")
local g_treeObj = provider.GetTreeData()
local g_RectHelper = provider.GetRectHelper()
local g_ListObj = provider.GetPropertyList()

function InsertPropertyItems(self, data)
--[[	local list = self:GetControlObject("list")
	list:InsertItems(data)]]
end

function GetPropertyItems(self)
	--[[local list = self:GetControlObject("list")
	return list:GetDataList()]]
end

function OnInitControl(self)
	--[[g_RectHelper:AttachRectChangeEvent(function(item)
		local rect = item.Value.rect
		local parentRect = nil
		if not item.Parent.Value then
			local select = g_treeObj:GetSelect()
			parentRect = select.Value.rect
		else
			parentRect = item.Parent.Value.rect
		end
		g_ListObj:ClearAll()
		g_ListObj:SetItemList({
		{Name = "left", Value =tostring(rect.left - parentRect.left)},
		{Name = "top", Value = rect.top-parentRect.top},
		{Name = "width", Value = rect.right - rect.left},
		{Name = "height", Value = rect.bottom-rect.top},
		})
	end)]]
end