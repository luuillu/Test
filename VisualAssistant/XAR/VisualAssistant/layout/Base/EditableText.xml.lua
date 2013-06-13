function OnInitControl(self)
	local attr = self:GetAttribute()
	self:SetEnable(attr.Enable)
	--editObj:SetReadOnly(not attr.Enable)
	local textObj = self:GetControlObject("text")
	textObj:SetTextColorResID(attr.TextColorID)
	local editObj = self:GetControlObject("edit")
	editObj:SetTextColorID(attr.TextColorID)
end


function edit_OnChar(self, char)
	if char == 13 then
		local root = self:GetOwner():GetRootObject()
		root:SetFocus(true)
	end
end

function edit_OnFocusChange(self,bFocus)
	local ctrl = self:GetOwnerControl()
	local  textObj = ctrl:GetControlObject("text")
	if bFocus then
		self:SetVisible(true)
		textObj:SetVisible(false)
		self:SetText(textObj:GetText())
		local bkgEdit = ctrl:GetControlObject("editBkg")
		bkgEdit:SetVisible(true)
	else
		self:SetVisible(false)
		textObj:SetVisible(true)

		if self:GetText() ~= textObj:GetText() then
			ctrl:FireExtEvent("OnTextChange",self:GetText())
		end
		
		local bkgEdit = ctrl:GetControlObject("editBkg")
		bkgEdit:SetVisible(false)
		--RemoveTip(self:GetOwnerControl())
	end
	ctrl:FireExtEvent("OnTextFocusChange",bFocus)
end

function edit_OnEditChange(self)
	--[[local text = self:GetText()
	local tc = #text
	local ObjAppAss = XLGetObject("Xunlei.MobilShareAss.Obj")
	--local txt,erc = ObjAppAss:IsNameLegal(text)
	RemoveTip(self:GetOwnerControl())
	if tc ~= 0 then
		--if erc == 0 then
			--AddTip(self:GetOwnerControl(), "只支持中英文、数字、'_'或减号！",1)
			--self:SetText(txt)
		--end
		
		if tc > 63 then
			AddTip(self:GetOwnerControl(), "输入的电脑名不能超过63个字符！",1)
			self:SetText(text:sub(1,63))
		end
	else
		AddTip(self:GetOwnerControl(), "电脑名不能为空！",1)
	end]]
end

function bkg_OnFocusChange(self,bFocus)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	if not attr.Enable then
		return
	end
	local  textObj = ctrl:GetControlObject("text")
	local editObj = ctrl:GetControlObject("edit")
	if bFocus then
		--self:SetReadOnly(false)
		editObj:SetVisible(true)
		editObj:SetFocus(true)
	end
end

function bkg_OnMouseEnter(self)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	local bkgEdit = ctrl:GetControlObject("editBkg")
	if attr.Enable then
		bkgEdit:SetVisible(true)
	end
end

function bkg_OnMouseLeave(self)
	local ctrl = self:GetOwnerControl()
	local attr = ctrl:GetAttribute()
	local bkgEdit = ctrl:GetControlObject("editBkg")
	local textObj = ctrl:GetControlObject("text")
	if attr.Enable and textObj:GetVisible() then
		bkgEdit:SetVisible(false)
	end
end

function SetEnable(self,enable)
	local attr = self:GetAttribute()
	attr.Enable = enable
	local editObj = self:GetControlObject("edit")
	local bkg = self:GetControlObject("bkg")
	if enable then
		bkg:SetCursorID("IDC_IBEAM")
	else
		bkg:SetCursorID("IDC_ARROW")
	end
end

function SetText(self, text)
	local  textObj = self:GetControlObject("text")
	textObj:SetText(text)
	local w,h = textObj:GetTextExtent()
	left, top,width, height = self:GetObjPosExp()
	self:SetObjPos2(left,top,w+17,height)
end