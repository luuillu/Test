local provider = XLGetGlobal("VisualAssistant.UIProvider")
local g_treeObj = provider.GetTreeData()
local g_RectHelper = provider.GetRectHelper()
local g_index = 0
function OnInitControl(self)
	local rectCurrent = self:GetControlObject("rect.current")
	local rectParent = self:GetControlObject("rect.parent")
	rectCurrent:SetLineColorResID("system.blue")
	rectParent:SetLineColorResID("system.red")
	local attr = self:GetAttribute()

	g_treeObj:AttachEvent("OnSelectChange",function(item)
		attr.CurrentRectObj = self:GetControlObject("rect.parent")		
		local rectCurrent = self:GetControlObject("rect.current")
		rectCurrent:SetRectanglePoint(0,0,0,0)
		g_RectHelper:SetRect(item)
		attr.ParentItem = item
	end)
	g_RectHelper:AttachRectChangeEvent(function(item)
		if item then
			local rect = item.Value.rect
			attr.CurrentRectObj:SetRectanglePoint(rect.left, rect.top, rect.right, rect.bottom)
		else
			attr.CurrentRectObj:SetRectanglePoint(0, 0, 0, 0)
		end
	end)
end

function OnLButtonDown(self,x,y)
	local attr = self:GetAttribute()
	attr.CurrentRectObj = self:GetControlObject("rect.current")
	attr.Original = {x = x, y = y}
	self:SetCaptureMouse(true)
	--attr.CurrentRect = nil
end

function OnLButtonUp(self,x,y)
 	local attr = self:GetAttribute()	
	self:SetCaptureMouse(false)
	if attr.Original then
		local rect = {}
		if attr.Original.x <= x then
			rect.left = attr.Original.x
			rect.right = x
		else
			rect.left = x
			rect.right = attr.Original.x
		end
		if attr.Original.y <= y then
			rect.top = attr.Original.y
			rect.bottom = y
		else
			rect.top = y
			rect.bottom = attr.Original.y
		end
		--attr.CurrentRect = rect
		if rect.bottom ~= rect.top and rect.right ~= rect.left then
			if not g_treeObj:GetSelect() then
				local item = g_treeObj:InsertValue({text ="Rect"..g_index,rect = rect})
				attr.ParentItem = item			
				g_treeObj:SetSelect(item)
				g_treeObj:UpdateUI()
				
			else
				local item = g_treeObj:InsertValue({text ="Rect"..g_index,rect = rect}, attr.ParentItem)
				g_treeObj:UpdateUI()
				g_RectHelper:SetRect(item)
			end		
		end

		g_index = g_index+1
		attr.Original = nil	
	end

end

function OnMouseMove(self,x,y)
	local rectCurrent = self:GetControlObject("rect.current")
	--rectCurrent:SetLineColorResID("system.blue")
 	local attr = self:GetAttribute()
	if attr.Original then
		local left = attr.Original.x
		local top = attr.Original.y
		if left > x then
			local t = x
			x = left
			left = t
		end
		if top>y then
			local t = y
			y = top
			top = t
		end
		rectCurrent:SetRectanglePoint(left, top, x, y)
	end
end

function OnKeyDown(self, char, repeatCount, flags)
	local rect = g_RectHelper:GetRect().Value.rect
	if not rect then
		return
	end
	local shell = XLGetObject( "VisualAssistant.OSShell" )
	local bShift = shell:GetKeyState( 16 ) < 0
	if bShift then
		if char == 37 then  --left
			if rect.right - rect.left > 1 then
				rect.right = rect.right - 1
			end
		elseif char ==38 then --up
			if rect.bottom - rect.top > 1 then
				rect.bottom = rect.bottom - 1
			end
		elseif char ==39 then --right
			rect.right = rect.right + 1
		elseif char ==40 then
			rect.bottom = rect.bottom + 1
		end
	else
		if char == 37 then  --left
			rect.left = rect.left - 1
		elseif char ==38 then --up
			rect.top = rect.top - 1	
		elseif char ==39 then --right
			if rect.right - rect.left > 1 then
				rect.left = rect.left + 1
			end
		elseif char ==40 then
			if rect.bottom - rect.top > 1 then
				rect.top = rect.top + 1
			end
		end	
	end
	g_RectHelper:FireRectChangeEvent()
end

function SetParentRect(ctrl, rect)
	--[[local attr = ctrl:GetAttribute()
	attr.ParentRect = rect
	local rectParent = ctrl:GetControlObject("rect.parent")
	rectParent:SetRectanglePoint(rect.left, rect.top, rect.right, rect.bottom)
	--g_treeObj:SetSelect()]]
end