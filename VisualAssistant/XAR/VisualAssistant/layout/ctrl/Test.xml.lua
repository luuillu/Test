function OnInitControl(self)
	local v = self:GetControlObject("v")
	v:SetViewSize(100)
	v:SetBkgSize(500, true)
	local h = self:GetControlObject("h")
	h:SetViewSize(200)
	h:SetBkgSize(500, true)
self:SetZorder(10000)	
end