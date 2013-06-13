function GetBitmap(self,width, height)
	local factory  = XLGetObject("Xunlei.UIEngine.RenderFactory")
	local bkg = self:GetControlObject("VisualAssistant.RenderControl.bkg")
	local graph = XLGetObject("Xunlei.XLGraphic.Factory.Object")

	local bitmap = graph:CreateBitmap("ARGB32",width,height)
	factory:RenderObject(bkg,bitmap)
	return bitmap
end