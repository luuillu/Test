
function PrintMethod(obj)
	local str = ""
	for name in pairs(obj.__index) do
		str = tostring(name).."||"
	end
	XLMessageBox(str)
end
function GetBitmap(obj,path)
	local factory = XLGetObject("Xunlei.XLGraphic.Factory.Object")
	local bitmap = factory:CreateBitmap(path,"ARGB32")
	local sp,mapwidth,mapheight = bitmap:GetInfo()
	--local thumbImageCreater = XLGetObject("Xunlei.Thunder.ThumbImageCreater")
	--local hr, width, height  = thumbImageCreater:GetImageSize(path)
	--PrintMethod(thumbImageCreater)
	--local hr, hBitmap1, realWidth, realHeight = thumbImageCreater:GetThumbFromFilePath(width, height, path)
	local left,top,width,height = obj:GetObjPosExp()
	obj:SetObjPos2(left,top,mapwidth,mapheight)
	obj:SetBitmap(bitmap)
	return mapwidth,mapheight
end

function OnInitControl(self)
	local path = __document:gsub("[^\\/]*$","")
	path =path.."..\\test.PNG" 
	local bkg = self:GetControlObject("bkg")
	local width,height = GetBitmap(bkg, path)
	local scroll = self:GetControlObject("scroll")
	scroll:SetBkgRange(width,height,true)
	
	local attr = self:GetAttribute()
	local templateMananger = XLGetObject("Xunlei.UIEngine.TemplateManager")
	local objectTreeTemplate = templateMananger:GetTemplate("VisualAssistant.RenderControl.tree","ObjectTreeTemplate")	
	local uiObjectTree = objectTreeTemplate:CreateInstance("VisualAssistant.RenderControl.tree")	
	attr.RenderControl = uiObjectTree:GetUIObject("VisualAssistant.RenderObject")	
	--rect:SetRectanglePoint(400,400,200,200)
end

function scrollOnViewPosChange(self, _,left,top,width,height)
	XLPrint("lxw VisualAssistant,left="..tostring(left).."top="..top)
	local ctrl = self:GetOwnerControl()
	local bkg = ctrl:GetControlObject("bkg")
	local _,_,mapwidth,mapheight = bkg:GetObjPosExp()
	bkg:SetObjPos2(-left,-top,mapwidth,mapheight)
end