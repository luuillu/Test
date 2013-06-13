function OnVScroll(self, eventName, type_, pos)
	local pos = self:GetScrollPos()
    
    if type_==1 then
        self:SetScrollPos( pos - 15, true )
    elseif type_==2 then
		self:SetScrollPos( pos + 15, true )
    end
	UpdateViewSize(self:GetOwnerControl())
	return true
end

function OnScrollBarMouseWheel(self,name, x, y, distance)
	local ThumbPos = self:GetThumbPos()
	self:SetThumbPos(ThumbPos - distance/10)
end

function OnHScroll(self, eventName, type_, pos)
	local pos = self:GetScrollPos() 
    if type_==1 then
        self:SetScrollPos( pos - 15, true )
    elseif type_==2 then
		self:SetScrollPos( pos + 15, true )
    end
    UpdateViewSize(self:GetOwnerControl())
	return true
end

function OnPosChange(self)
	--UpdateViewSize(ctrl)
end

function UpdateViewSize(ctrl)
	local attr = ctrl:GetAttribute()
	local hscroll = ctrl:GetControlObject("hscroll")
	local vscroll = ctrl:GetControlObject("vscroll")
	local left,_,right = hscroll:GetObjPos()
	local width = right - left
	local _,top,_,bottom = vscroll:GetObjPos()
	local height = bottom - top
	local left = hscroll:GetScrollPos()
	local top = vscroll:GetScrollPos()
	
	local hpage = hscroll:GetPageSize()
	local vpage = vscroll:GetPageSize()
	if hpage ~= width then
		hscroll:SetPageSize(width)
	end
	if vpage ~= height then
		vscroll:SetPageSize(height)
	end
	
	if attr.hBkgRange and attr.vBkgRange then
		local range = 0
		if attr.hBkgRange-width> 0 then
			range = attr.hBkgRange-width
		else 
			width = attr.hBkgRange
		end
		hscroll:SetScrollRange(0,range,true)
		hscroll:Show(range ~= 0)
		range = 0
		if attr.vBkgRange-height> 0 then
			range = attr.vBkgRange-height
		else
			height = attr.vBkgRange
			top =0
		end

		XLPrint("lxw VissuaAssistant, Tree,range="..range.."height="..tostring(height))
		vscroll:SetScrollRange(0,range, true)
		vscroll:Show(range ~= 0)
	end
	XLPrint("lxw VissuaAssistant, Tree,FireExtEvent,height="..tostring(height))

	ctrl:FireExtEvent("OnViewPosChange",left,top, width,height)
	if attr.BindViewID then
		local view = ctrl:GetObject(attr.BindViewID)
		view:SetObjPos2(0,0,width,height)
	end
	XLPrint("lxw VisualAssistant,OnVScroll width="..tostring(width))
end

function OnVisibleChanged(self,_,bVisible)
		local id = self:GetID()
		local attr = self:GetAttribute()
		if id == "vscroll" then
			if attr.vLastVisible == bVisible then
				return 
			else
				attr.vLastVisible = bVisible
			end
		elseif id == "hscroll" then
			if attr.hLastVisible == bVisible then
				return 
			else
				attr.hLastVisible = bVisible
			end		
		end
		if attr.LastVisible == bVisible then
			return
		end
		attr.LastVisible = bVisible
		--AsynCall(function() 
			local ctrl = self:GetOwnerControl()
			local hscroll = ctrl:GetControlObject("hscroll")
			local hleft,htop,hwidth,hheight = hscroll:GetObjPosExp()
			local vscroll = ctrl:GetControlObject("vscroll")
			local vleft,vtop,vwidth,vheight = vscroll:GetObjPosExp()
	
			local str = debug.traceback()
			--XLMessageBox("lxw VisualAssistant,bVisible="..tostring(bVisible).."id="..tostring(id)..str)
			if bVisible then
				if id == "vscroll" then	
					hscroll:SetObjPos2(hleft,htop,"father.width-"..vwidth, hheight)		
				else	

					vscroll:SetObjPos2(vleft,vtop,vwidth,"father.height-"..hheight)		
				end
			else
				if id == "vscroll" then	
					local left,top,width,height = hscroll:GetObjPosExp()
					hscroll:SetObjPos2(hleft,htop,"father.width",hheight)		
				else	
					local left,top,width,height = vscroll:GetObjPosExp()
					vscroll:SetObjPos2(vleft,vtop,vwidth,"father.height")		
				end
			end	

		UpdateViewSize(ctrl)		
		--end)
end


function Scroll_OnPoschange(self,_,_,_,_,left,top,right,bottom)
	AsynCall(function() 
		UpdateViewSize(self:GetOwnerControl())	
	end)

end

function SetBkgRange(self,width,height)
	local attr = self:GetAttribute()
	if width then
		attr.hBkgRange = width
	end
	if height then
		attr.vBkgRange = height
	end
	UpdateViewSize(self)
end

function AddMouseScroll(self, tree, wnd)
	local attr = self:GetAttribute()
	attr.ScrollCokie = wnd:AddInputFilter(true, function(wnd, msg,wparam) 
		if msg == 522 then
			local vscroll = self:GetControlObject("vscroll")
			if not vscroll:IsShow() then
				return
			end
			local bindObj = self:GetObject(attr.BindViewID)
			local focus = tree:GetFocusObject()
			if focus and (bindObj:IsChild(focus) or bindObj:GetHandle() == focus:GetHandle() ) then
				local type_ = 1
				if wparam<0 then
					type_ = 2
				end
				vscroll:FireExtEvent("OnVScroll", type_)
			end		
		end
	end)

end
function OnInitControl(self)
	local attr = self:GetAttribute()
	if not attr.BindViewID then
		return
	end
		local owner = self:GetOwner();
		local wnd = owner:GetBindHostWnd()
		if not wnd then
			owner:AttachListener("OnCreateHostWnd", true,function(_,hosetwnd,iscrate) 
				if iscrate then	
					AddMouseScroll(self, owner, hosetwnd)
				end
			end)
		else
			AddMouseScroll(self,owner, wnd)
		end
end

function OnDestroy(self)
	 local attr = self:GetAttribute()
	 if attr.ScrollCokie then
		local wnd = self:GetOwner():GetBindHostWnd()
		if wnd then 
			wnd:RemoveInputFilter(attr.ScrollCokie)
		end
	 end
end