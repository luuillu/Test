function SetViewSize(self, size, upDate)
	local attr = self:GetAttribute()
	attr.ViewSize = tonumber(size)
	if upDate then
		UpdataScrollPos(self) 
		--UpdateThumb(self)
		
	end
end

function SetBkgSize(self, size, upDate)
	local attr = self:GetAttribute()
	--local pos = ScrollPosToBkgPos(self,attr.ScrollPos)	
	attr.BkgSize = tonumber(size)
	--attr.ScrollPos =BkgPosToScrollPos(self, pos)	
	if upDate then
		UpdataScrollPos(self)
		--UpdateThumb(self)
	end
end

function MoveDistance(self, distance)
	local attr = self:GetAttribute()
	--distance =
	--attr.ScrollPos = attr.ScrollPos + distance
	UpdataScrollPos(self, attr.ScrollPos + distance)
	--UpdateThumb(self)
	XLPrint("lxw VisualAssistant,ScrollBar, ".."distance="..tostring(distance))
end

function BkgPosToScrollPos(self, pos)
	local attr = self:GetAttribute()
	local left, top,right,bottom = self:GetObjPos()
	if attr.Type == 1 then
		return DoubleToInteger(pos* (bottom-top)/attr.BkgSize)
	elseif attr.Type == 2 then
		return DoubleToInteger(pos* (right-left)/attr.BkgSize)
	end
end

function ScrollPosToBkgPos(self, pos)
	local attr = self:GetAttribute()
	local left, top,right,bottom = self:GetObjPos()
	if attr.Type == 1 then
		return DoubleToInteger(pos* attr.BkgSize/(bottom-top))
	elseif attr.Type == 2 then
		return DoubleToInteger(pos* attr.BkgSize/(right-left))
	end
end

function DoubleToInteger(i)
	return math.floor(i+0.5)
end

function UpdateThumb(self)
	local attr = self:GetAttribute()
	if attr.ViewSize < attr.BkgSize and attr.ViewSize >0 then
		if not attr.IsShow then
			self:SetChildrenVisible(true)
			attr.IsShow = true
			self:FireExtEvent("OnShowChange",true)
		end
		local rate = attr.ViewSize/attr.BkgSize
		local thumb = self:GetControlObject("thumb")
		if attr.Type == 1 then
			local left,_,width = thumb:GetObjPosExp()
			local top = BkgPosToScrollPos(self, attr.ScrollPos)
			local height = math.floor(rate*100+0.5).."*father.height/100"
			thumb:SetObjPos2(left,top,"father.width",height)
			--local left,top,right,bottom = thumb:GetObjPos()
			XLPrint("lxw VisualAssistant,ScrollBar, ".."top="..tostring(top))
		elseif attr.Type == 2 then
			local _,top,_,height = thumb:GetObjPosExp()
			local left =  BkgPosToScrollPos(self, attr.ScrollPos)
			local width = math.floor(rate*100+0.5).."*father.width/100"
			thumb:SetObjPos2(left,top,width,"father.height")
		end
	else
		if attr.IsShow ~= false then		
			self:SetChildrenVisible(false)
			attr.IsShow = false
			self:FireExtEvent("OnShowChange",false)
		end
	end
	XLPrint("lxw VisualAssistant,ScrollBar, ".."attr.ViewSize="..tostring(attr.ViewSize).."attr.BkgSize="..tostring(attr.BkgSize).."id="..tostring(self:GetID()).."attr.IsShow="..tostring(attr.IsShow))
end

function UpdataScrollPos(self, pos) 
	local attr = self:GetAttribute()
	local old = nil
	if pos then
		old = attr.ScrollPos
		attr.ScrollPos = pos
	end
	XLPrint("lxw VisualAssistant,ScrollBar, attr.ViewSize="..tostring(attr.ViewSize).."attr.BkgSize="..tostring(attr.BkgSize).."attr.ScrollPos="..tostring(attr.ScrollPos))
	if attr.ViewSize < attr.BkgSize then
		if attr.ScrollPos< 0 then
			attr.ScrollPos = 0
		else
			--[[local thumb = self:GetControlObject("thumb")
			local left,top,right,bottom = thumb:GetObjPos()
			local size = 0
			local pl,pt,pr,pb = self:GetObjPos()
			local total = 0
			if attr.Type == 1 then
				size = bottom - top
				total = pb - pt
			elseif attr.Type == 2 then
				size = right - left
				total = pr - pl
			end
			if attr.ScrollPos + size> total then
				attr.ScrollPos = total - size
			end]]
			if attr.ScrollPos + attr.ViewSize > attr.BkgSize then
				attr.ScrollPos = attr.BkgSize-attr.ViewSize			
			end
		end
	else
		attr.ScrollPos = 0
	end
	XLPrint("lxw VisualAssistant,ScrollBar, attr.ScrollPos="..tostring(attr.ScrollPos))	
	if old ~= attr.ScrollPos then
		UpdateThumb(self)
		--if attr.BkgSize >= attr.ViewSize then 
			self:FireExtEvent("OnViewChange",attr.ScrollPos,attr.ViewSize)
		--else
			--self:FireExtEvent("OnViewChange",ScrollPosToBkgPos(self,attr.ScrollPos),attr.BkgSize)
		--end
	end
end
--[[
function UpDataUI(self)
	local attr =self:GetAttribute()
	local bkg = self:GetControlObject("bkg")
	
	if attr.Type == 1 then -- 垂直滚动
		
		
	
	elseif attr.Type == 2 then
	
	
	end
end]]

function Navigate(self, pos)
	local attr = self:GetAttribute()
	--attr.ScrollPos = BkgPosToScrollPos(self,pos)
	UpdataScrollPos(self,pos)
	--UpdateThumb(self)
	--local str = debug.traceback()
	--str = string.gsub(str,"[\r\n]","||")
	XLPrint("lxw VisualAssistant,Navigate,ScrollBar, pos="..tostring(pos))
end

function IsShow(self)
	local attr = self:GetAttribute()
	return attr.IsShow
end

local g_TextureID = {
{"texture.vsb.small.thumb", "texture.vsb.small.bkg.normal"},
{"texture.hsb.small.thumb", "texture.hsb.small.bkg.normal"},
}
function OnInitControl(self)
	local attr = self:GetAttribute()
	if not attr.ThumbTexture then
		attr.ThumbTexture = g_TextureID[attr.Type][1]
	end
	if not attr.BkgTexture then
		attr.BkgTexture = g_TextureID[attr.Type][2]
	end
	local bkgObj = self:GetControlObject("bkg")
	bkgObj:SetTextureID(attr.BkgTexture)
	local thumb =self:GetControlObject("thumb")
	thumb:SetTextureID(attr.ThumbTexture..".normal")
	thumb:SetRedirect("OnLButtonDown","control")
	thumb:SetRedirect("OnLButtonUp","control")
	thumb:SetRedirect("OnMouseMove","control")
	attr.ViewSize = 0
	attr.BkgSize = 0
	attr.ScrollPos = 0
end

function OnLButtonDown(self,x,y)
	local attr = self:GetAttribute()
	local obj = self:GetControlObject("thumb")
	
	local left, top, right,bottom = obj:GetObjPos()
	if left < x and x<right and top<y and y<bottom then
		self:SetCaptureMouse(true)
		attr.CapturePos = {x=x-left, y=y-top}
		obj:SetTextureID(attr.ThumbTexture..".down")
	else		
		local left,top,right,bottom = self:GetObjPos()
		XLPrint("lxw VisualAssistant,ScrollBar, OnLButtonDown x="..tostring(x).."y="..tostring(y))
		if attr.Type == 1 then	
			UpdataScrollPos(self, ScrollPosToBkgPos(self,y))	
		elseif attr.Type == 2 then
			UpdataScrollPos(self, ScrollPosToBkgPos(self,x))
		end
	end
end

function OnLButtonUp(self)
	local attr = self:GetAttribute()
	if attr.CapturePos then
		self:SetCaptureMouse(false)
		attr.CapturePos = nil
		local thumb = self:GetControlObject("thumb")
		thumb:SetTextureID(attr.ThumbTexture..".normal")
	end
end

function OnMouseMove(self, x,y)
	local attr = self:GetAttribute()

	if attr.CapturePos then
		XLPrint("lxw VisualAssistant,ScrollBar,x="..(x).."y="..y.."attr.CapturePos.y="..tostring(attr.CapturePos.y))
		local left,top,right,bottom = self:GetObjPos()
		if attr.Type == 1 then		
			UpdataScrollPos(self, ScrollPosToBkgPos(self,y - attr.CapturePos.y))
		elseif attr.Type == 2 then
			UpdataScrollPos(self, ScrollPosToBkgPos(self,x - attr.CapturePos.x))
		end	
					
	end
end

function thumb_OnMouseEnter(self,x,y)
		local ctrl = self:GetOwnerControl()
		local attr = ctrl:GetAttribute()
		self:SetTextureID(attr.ThumbTexture..".hover")	
end

function thumb_OnMouseLeave(self,x,y)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	self:SetTextureID(attr.ThumbTexture..".normal")
end

function OnMouseWheel(self,x, y, distance)
	local attr = self:GetAttribute()
	self:MoveDistance(-distance)
end