
local treeImpl = {}

function treeImpl:InsertValue(value, parent,index)
	local attr = self.Attribute
	--local tree = attr.TreeData
	if not parent then
		parent = attr.TreeData
	end
	local item = {Value = value,Parent = parent, Children = {}, Level = parent.Level +1, IsExpand = true}
	if not index then
		--XLMessageBox(parent.Level)
		index = #parent.Children
	end
	XLPrint("lxw treeImpl,parent = "..tostring(parent))
	table.insert(parent.Children,item)
	return item
end

function treeImpl:InsertItem(item, parent,index)
	local attr = self.Attribute
	--local tree = attr.TreeData
	if not parent then
		parent = attr.TreeData
	end
	if not index then
		index = #parent.Children
	end
	item.Parent = parent
	item.Level = parent.Level +1
	table.insert(parent.Children,item)
end


function treeImpl:RemoveItem(item)
	local parent = item.Parent
	
	local select = self:GetSelect()
	if select then
		obj = select
		for i = item.Level+1,select.Level do
			obj = obj.Parent
		end
		if obj == item  then
			if not item.Parent.IsRoot then
				self:SetSelect(item.Parent)
			else
				self:SetSelect(nil)
			end
		end
	end
	
	for i = 1,#parent.Children do
		if parent.Children[i] == item then
			table.remove(parent.Children, i)
			break
		end
	end
	self:FireEvent("OnRemoveItem",item)
	self:UpdateUI()
end

function treeImpl:SetExpandItem(item)
	item.IsExpand = not item.IsExpand
	if not item.IsExpand then
		local select = self:GetSelect()
		if select~= item then
			obj = select
			for i = item.Level+1, select.Level do
				obj = obj.Parent
			end
			if obj == item then
				self:SetSelect(item)
			end			
		end	
	end
	self:UpdateUI()
	return item.IsExpand
end

function treeImpl:GetExpandItem(item, bExpand)
	return item.IsExpand
end

function treeImpl:SetSelect(item)
	local attr = self.Attribute
	if attr.SelectItem ~= item then
		attr.SelectItem = item
		self:FireEvent("OnSelectChange",item)
	end
end

function treeImpl:GetSelect()
	local attr = self.Attribute
	return attr.SelectItem
end
function treeImpl:AttachEvent(EventName, Func)
	local attr = self.Attribute
	if not attr.EventList[EventName] then
		attr.EventList[EventName] = {}
	end
	table.insert(attr.EventList[EventName], Func)
end

function treeImpl:FireEvent(EventName, arg)
	local attr = self.Attribute
	if attr.EventList[EventName] then
		for i = 1, #attr.EventList[EventName] do
			attr.EventList[EventName][i](arg)
		end
	end
end


function GetExpandItemList(item, res)
	table.insert(res, item)
	item.ListIndex = #res
	if item.IsExpand then
		--XLPrint("lxw VissuaAssistant, Tree,textIsExpand="..item.Value.text)
		for i = 1,#item.Children do
			GetExpandItemList(item.Children[i], res)
		end
	else
		--XLPrint("lxw VissuaAssistant, Tree,text="..item.Value.text)
		
	end
end

function treeImpl:UpdateUI()
	local attr = self.Attribute
	local treeData = attr.TreeData
	--XLMessageBox("treeData.Children="..tostring(#treeData.Children))
	attr.List = {}
	for i = 1, #treeData.Children do
		GetExpandItemList(treeData.Children[i], attr.List)
	end
	self:FireEvent("OnListChange", #attr.List)
end

function treeImpl:GetList()
	local attr = self.Attribute
	return attr.List
end

function treeImpl:FindItemInList(item)
	local attr = self.Attribute
	for i = 1,#attr.List do
		if attr.List[i] == item then
			return i
		end
	end
end

function CreateTree()
	local tree = {
			Attribute = {TreeData = {Children = {}, Level = 0,IsRoot = true},
						 List = {},
						 EventList = {}, }
				}
	setmetatable(tree,{__index = treeImpl})
	return tree
end
