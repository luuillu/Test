
local listImpl = {}

function listImpl:InsertItem(item, index)
	local attr = self.Attribute
	if not index then
		index = #attr.DataList
	end
	table.insert(attr.DataList, index,item)
	self:FireEvent("OnListChange", #attr.DataList)
end

function listImpl:RemoveItem(index)
	local attr = self.Attribute
	table.remove(attr.DataList, index)
	self:FireEvent("OnListChange", #attr.DataList)
end

function listImpl:SetItemList(items)
	local attr = self.Attribute
	attr.DataList = items
	self:FireEvent("OnListChange", #items)
end

function listImpl:RemoveItemRange(_begin,_end)
	if _end <= _begin then
		return
	end
	
	local attr = self.Attribute
	local res = {}
	for i = 1,_begin do
		table.insert(res, attr.DataList[i])
	end
	for i = _end,#attr.DataList do
		table.insert(res, attr.DataList[i])
	end
	attr.DataList = res
	self:FireEvent("OnListChange", #attr.DataList)
end

function listImpl:RemoveItemByTable(tb)
	--[[local attr = self.Attribute
	local res = {}
	for i = 1,#attr.DataList do
		if not tb[i] then
			table.insert(res, attr.DataList[i])
		end
	end
	attr.DataList = res]]
end

function listImpl:GetItem(index)
	local attr = self.Attribute
	return attr.DataList[index]
end

function listImpl:AttachEvent(name, func)
	local attr = self.Attribute
	if not attr.EventList[name] then
		attr.EventList[name] = {}
	end
	table.insert(attr.EventList[name],func)
end

function  listImpl:FireEvent(name, arg)
	local attr = self.Attribute
	local funcList = attr.EventList[name]
	if funcList then
		for i=1, #funcList do
			funcList[i](arg)
		end	
	end
end

function CreateList()
	list = {Attribute = {DataList = {} ,EventList = {}}}
	setmetatable(list,{__index = listImpl})
	return list
end