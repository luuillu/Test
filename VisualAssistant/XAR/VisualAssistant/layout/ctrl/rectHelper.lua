local RectImpl = {}function RectImpl:GetRect()	local attr = self.Attribute	return attr.Itemendfunction RectImpl:SetRect(item)	local attr = self.Attribute	--attr.Current = rect	attr.Item = item	self:FireRectChangeEvent()endfunction RectImpl:AttachRectChangeEvent(func)	local attr = self.Attribute	table.insert(attr.EventList, func)endfunction RectImpl:FireRectChangeEvent()	local attr = self.Attribute	for i =1, #attr.EventList do		attr.EventList[i](attr.Item)	endendfunction CreateRect()	local rect = {Attribute = {Current = {}, EventList = {} }}	setmetatable(rect, {__index = RectImpl})	return rectend