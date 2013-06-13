

local function AddMouseScroll(self, tree, wnd)
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
				if wparam<0 then
					wparam = -120
				elseif wparam>0 then
					wparam = 120
				end
				vscroll:MoveDistance(-wparam)
			end		
		end
	end)

end
function OnInitControl(self)
	local attr = self:GetAttribute()
	attr.ViewPos = {}
	local hscroll = self:GetControlObject("hscroll")
	local vscroll = self:GetControlObject("vscroll")
	local left, top,right,bottom = self:GetObjPos()
	--hscroll:SetViewSize(right-left)
	--vscroll:SetViewSize(bottom-top,true)
	--XLMessageBox("width="..tostring(right-left))
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


function scroll_OnShowChange(self, _,bShow)
	local attr = self:GetAttribute()
	if attr.Type == 1 then
		local hscroll = self:GetObject("control:hscroll")
		local left, top,width, height = hscroll:GetObjPosExp()
		if bShow then
			hscroll:SetObjPos2(left,top,"father.width - 12",height)
		else
			hscroll:SetObjPos2(left,top,"father.width",height)
		end
		--hscroll:UpdataScrollPos()
	
	elseif attr.Type == 2 then
		local vscroll = self:GetObject("control:vscroll")
		local left, top,width, height = vscroll:GetObjPosExp()
		if bShow then
			vscroll:SetObjPos2(left,top,width,"father.height-12")
		else
			vscroll:SetObjPos2(left,top,width,"father.height")
		end
		--vscroll:UpdataScrollPos()		
	end
end

function scroll_OnViewChange(self, _, beigin, size)
--XLPrint("lxw ControlWithScroll, beigin="..tostring(beigin).."size="..tostring(size))
	local attr = self:GetAttribute()
	local ctrlAttr = self:GetOwnerControl():GetAttribute()
	if attr.Type == 1 then
		ctrlAttr.ViewPos.Top = beigin
		ctrlAttr.ViewPos.Height = size
		
	elseif attr.Type == 2 then
		ctrlAttr.ViewPos.Left = beigin
		ctrlAttr.ViewPos.Width = size
	end
	
	local ctrl = self:GetOwnerControl()
	if ctrlAttr.ViewPos.Height and ctrlAttr.ViewPos.Width then
		ctrl:FireExtEvent("OnViewPosChange",ctrlAttr.ViewPos.Left, ctrlAttr.ViewPos.Top,
			ctrlAttr.ViewPos.Width, ctrlAttr.ViewPos.Height)
		if ctrlAttr.BindViewID then
			local view = ctrl:GetObject(ctrlAttr.BindViewID)
			local left,top = ctrl:GetObjPosExp()
			view:SetObjPos2(left,top,ctrlAttr.ViewPos.Width, ctrlAttr.ViewPos.Height)
		end
	end
end

function SetBkgRange(self, width,height)
	local hscroll = self:GetControlObject("hscroll")
	local vscroll = self:GetControlObject("vscroll")
	hscroll:SetBkgSize(width, true)
	vscroll:SetBkgSize(height, true)
end

function scroll_OnPosChange(self,_,_,_,_,left,top,right,bottom)
	local attr = self:GetAttribute()
	if attr.Type == 1 then
		self:SetViewSize(bottom-top, true)
	elseif attr.Type == 2 then
		self:SetViewSize(right-left, true)
	end
	--local str = debug.traceback()
	--str = str:gsub("[\r\n]","||")
	--XLPrint("lxw ControlWithScroll, left="..tostring(left).."top="..tostring(top).."right="..tostring(right).."bottom="..tostring(bottom)..str)
end

function UpdateViewSize(self)
	local ctrlAttr = self:GetAttribute()
	self:FireExtEvent("OnViewPosChange",ctrlAttr.ViewPos.Left, ctrlAttr.ViewPos.Top,
			ctrlAttr.ViewPos.Width, ctrlAttr.ViewPos.Height)
end

function Navigate(self, left,top)
	local hscroll = self:GetControlObject("hscroll")
	local vscroll = self:GetControlObject("vscroll")
	if left then
		hscroll:Navigate(left)
	end
	if top then
		vscroll:Navigate(top)
	end
end