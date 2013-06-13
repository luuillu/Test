function DlgHidden_BindObj(self,obj)
	local theRender = XLGetObject("Xunlei.UIEngine.RenderFactory")
	local objFactory = XLGetObject("Xunlei.UIEngine.ObjectFactory")
	local xlgraphic = XLGetObject("Xunlei.XLGraphic.Factory.Object")
	local attr = self:GetAttribute()
	attr.left,attr.top,attr.right,attr.bottom =obj:GetObjPos()
    local theBitmap = xlgraphic:CreateBitmap("ARGB32",attr.right-attr.left,attr.bottom-attr.top)
	theRender:RenderObject(obj,theBitmap)
	
	attr.bindObj = obj;
	attr.left,attr.top,attr.right,attr.bottom =obj:GetObjPos()
	obj:SetChildrenVisible(false)
	obj:SetVisible(false)
	local newImageObject = objFactory:CreateUIObject("","ImageObject")
	attr.imageObj = newImageObject
	newImageObject:SetBitmap(theBitmap)
	newImageObject:SetDrawMode(1)
	newImageObject:SetObjPos(attr.left,attr.top,attr.right,attr.bottom)
	obj:GetFather():AddChild(newImageObject)
end

function DlgHidden_GetBindObj(self)
	local attr = self:GetAttribute()
	if attr then
		return attr.bindObj
	end
	
	return nil
end
function DlgHidden_Action(self)

	local curve = self:GetCurve()
	local totalTime = self:GetTotalTime()
	local runningTime = self:GetRuningTime()
	local progress = curve:GetProgress(runningTime / totalTime)
	local bindObj = self:GetBindObj()
	
	local attr = self:GetAttribute()

	--放大
	local left,right,top,bottom
	if attr.ZoomOut then
		left = attr.left - attr.ChangeX * progress
		right = attr.right + attr.ChangeX * progress
		top = attr.top - attr.ChangeY * progress
		bottom = attr.bottom + attr.ChangeY* progress
	else
		left = attr.left + attr.ChangeX * progress
		right = attr.right - attr.ChangeX * progress
		top = attr.top + attr.ChangeY * progress
		bottom = attr.bottom - attr.ChangeY* progress
	end
	attr.imageObj:SetObjPos(left,top,right,bottom)
	--改变透明度
	local alpha = 255 - 255*(runningTime / totalTime)
	attr.imageObj:SetAlpha(alpha)
	return true
end


function DlgPop_BindObj(self,obj)
	local theRender = XLGetObject("Xunlei.UIEngine.RenderFactory")
	local objFactory = XLGetObject("Xunlei.UIEngine.ObjectFactory")
	local xlgraphic = XLGetObject("Xunlei.XLGraphic.Factory.Object")
	local attr = self:GetAttribute()
	attr.left,attr.top,attr.right,attr.bottom =obj:GetObjPos()
	local theBitmap = xlgraphic:CreateBitmap("ARGB32",attr.right-attr.left,attr.bottom-attr.top)
	theRender:RenderObject(obj,theBitmap)
	
	attr.bindObj = obj;
	attr.left,attr.top,attr.right,attr.bottom =obj:GetObjPos()

	obj:SetChildrenVisible(false)
	obj:SetVisible(false)
	local newImageObject = objFactory:CreateUIObject("","ImageObject")
	attr.imageObj = newImageObject
	newImageObject:SetBitmap(theBitmap)
	newImageObject:SetDrawMode(1)
	newImageObject:SetObjPos(attr.left,attr.top,attr.right,attr.bottom)
	obj:GetFather():AddChild(newImageObject)
	
	local function onAniFinish(self,old,new)
		if new == 4 then
			newImageObject:GetFather():RemoveChild(newImageObject)
			obj:SetVisible(true)
			obj:SetChildrenVisible(true)
		end
		return true
	end
	self:AttachListener(true,onAniFinish)
end

function DlgPop_GetBindObj(self)
	local attr = self:GetAttribute()
	if attr then
		return attr.bindObj
	end
	
	return nil
end

function DlgPop_Action(self)
	local curve = self:GetCurve()
	local totalTime = self:GetTotalTime()
	local runningTime = self:GetRuningTime()
	local progress = curve:GetProgress(runningTime / totalTime)
	local bindObj = self:GetBindObj()
	
	local attr = self:GetAttribute()

	
	local left,right,top,bottom
	if attr.ZoomOut then
		--放大
		left = (attr.left + attr.ChangeX) - attr.ChangeX * progress
		right = (attr.right - attr.ChangeX) + attr.ChangeX * progress
		top = (attr.top + attr.ChangeY) - attr.ChangeY * progress
		bottom = (attr.bottom - attr.ChangeY) + attr.ChangeY* progress
	else
		--缩小
		left = (attr.left - attr.ChangeX) + attr.ChangeX * progress
		right = (attr.right + attr.ChangeX) - attr.ChangeX * progress
		top = (attr.top - attr.ChangeY) + attr.ChangeY * progress
		bottom = (attr.bottom + attr.ChangeY) - attr.ChangeY* progress
	end
	attr.imageObj:SetObjPos(left,top,right,bottom)
	--改变透明度
	local alpha = 255*(runningTime / totalTime)
	attr.imageObj:SetAlpha(alpha)
	return true
end
