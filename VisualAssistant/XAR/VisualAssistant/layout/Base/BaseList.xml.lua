function scrollOnViewPosChange(self, _,left ,top,width,height)
	XLPrint("lxw VisualAssistant scrollOnViewPosChange,left="..tostring(left).."top="..tostring(top)
	.."width="..tostring(width).."top="..tostring(width))

	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	local view = ctrl:GetControlObject("view")
	--[[view:SetObjPos2(0,0,width,height)]]
	local beginIdx = 1+(top - top%attr.ItemHeight)/attr.ItemHeight
	local bottom = top + height
	local endIdx = 1+(bottom - bottom%attr.ItemHeight)/attr.ItemHeight
	if endIdx>attr.ItemCount then
		endIdx = attr.ItemCount
	end
	local str = debug.traceback()
	str = str:gsub("[\r\n]","||")
	XLPrint("lxw VissuaAssistant, Tree,beginIdx="..beginIdx.."endIdx="..endIdx.."top"..top.."bottom="..bottom..",")
	local visibleItems = {}
	local factory = XLGetObject("Xunlei.UIEngine.ObjectFactory")
	
	for i =beginIdx,endIdx do
	
		local obj = attr.VisibleItems[i]
		if not obj then
			obj = factory:CreateUIObject("item"..i,attr.ItemClass)
			ctrl:FireExtEvent("OnInitItem",i,obj)
			view:AddChild(obj)
		else
			attr.VisibleItems[i] = nil
		end
		visibleItems[i] = obj
		obj:SetObjPos2(-left,(i-1)*attr.ItemHeight-top, attr.ItemWidth,attr.ItemHeight)		
	end
	for _,obj in pairs(attr.VisibleItems) do
		XLPrint("lxw treeImpl, Remove")
		if view:GetOwner() then
			view:RemoveChild(obj)
		end
	end
	attr.VisibleItems = visibleItems
	ctrl:FireExtEvent("OnUpdateView",visibleItems)
end

function SetItemCount(self, count)
	local attr = self:GetAttribute()
	attr.ItemCount = count
	local height = attr.ItemHeight*count
	local scroll = self:GetControlObject("scroll")
	XLPrint("lxw VissuaAssistant, Tree,attr.ItemWidth="..attr.ItemWidth)
	scroll:SetBkgRange(attr.ItemWidth, height)
end

function SetItemWidth(self,width)
	local attr = self:GetAttribute()
	attr.ItemWidth = width
	scroll:SetBkgRange(width)	
end

function UpdateUI(self)
	local scroll = self:GetControlObject("scroll")
	scroll:UpdateView()
end

function OnBind(self)
	local attr = self:GetAttribute()
	attr.VisibleItems = {}
	attr.ItemCount = 0
	local view = self:GetControlObject("view")
	view:SetRedirect("OnKeyDown","control")
end

function Navigate(self, index)
	local attr = self:GetAttribute()
	local scroll = self:GetControlObject("scroll")
	scroll:Navigate(nil, (index-1)*attr.ItemHeight)
	XLPrint("lxw VisualAssistant, Tree,index="..tostring(index).."height="..tostring((index-1)*attr.ItemHeight))
end