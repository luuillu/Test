g_appname = "VisulAssistant"
function DoModal(info)
	--if info.ClassName then
	--[[info.Width = 500
	info.Height = 200
	info.HideBkgCtrl = nil
	info.ID = "Remote.Test"
	info.Class = "TextObject"
	info.Parent = nil
	info.OnBind = nil
	info.OnDestroy = nil]]
	if not info.ID then
		info.ID = info.Class
	end
	
	DoModalImpl(g_appname..".ModalHostWndHelper.wnd", g_appname..".ModalHostWndHelper.tree",info.Parent, info.OnBind, info.OnDestroy,
		function(modalHostWndTemplate, objectTreeTemplate)
			local modify = modalHostWndTemplate:BeginModify()
			local attrModify = modify:GetAttrList()
			
			attrModify:SetAttr("width",info.Width+16+30)
			attrModify:SetAttr("height",info.Height+16+30)
			modify:SetID(info.id)
			--XLMessageBox(modify:GetID())
			modalHostWndTemplate:EndModify(modify)
			
			ModifyObjectTree(objectTreeTemplate, info)
			local modalHostWnd = modalHostWndTemplate:CreateInstance(info.ID)
			if modalHostWnd == nil then
				return nil 
			end

			local uiObjectTree = objectTreeTemplate:CreateInstance(info.ID)
			if uiObjectTree == nil then
				return nil
			end
			
			return modalHostWnd, uiObjectTree
		end
	)
end

function DoModalImpl(hostWndTemplateID, treeTemplateID, parentWnd, onBindFunc, OnDestroyFunc, DoModify)
    local xar_manager = XLGetObject( "Xunlei.UIEngine.XARManager")
	if not xar_manager:IsXARLoaded( "DlgCom" ) then
		if not xar_manager:LoadXAR( "DlgCom" ) then
			return
		end
	end
	--创建HostWnd
	local templateMananger = XLGetObject("Xunlei.UIEngine.TemplateManager")
	local modalHostWndTemplate = templateMananger:GetTemplate(hostWndTemplateID,"HostWndTemplate")
	if modalHostWndTemplate == nil then
		return nil 
	end
	
	--创建ObjectTree
	local objectTreeTemplate = templateMananger:GetTemplate(treeTemplateID,"ObjectTreeTemplate")
	if objectTreeTemplate == nil then
		return nil 
	end
	
	local modalHostWnd, uiObjectTree = DoModify(modalHostWndTemplate, objectTreeTemplate)
	--绑定Object到HostWnd
	modalHostWnd:BindUIObjectTree(uiObjectTree)

	if onBindFunc ~= nil then
		onBindFunc(modalHostWnd, uiObjectTree)
	end

	--设置主窗口为父窗口
	local hostwndManager = XLGetObject("Xunlei.UIEngine.HostWndManager")
	if parentWnd == nil then
		parentWnd = hostwndManager:GetHostWnd("Thunder.MainFrame")
	end

	--弹出面板
	local parentHnd = 0
	if parentWnd ~= nil then
		parentHnd = parentWnd:GetWndHandle()
	end
	local ret = modalHostWnd:DoModal(parentHnd)
	
	if OnDestroyFunc ~= nil then
		OnDestroyFunc(modalHostWnd, uiObjectTree, ret)		
	end
	local hostWndID = modalHostWnd:GetID()

	--解除绑定
	modalHostWnd:UnbindUIObjectTree()
	
	--销毁ObjectTree
	local objtreeManager = XLGetObject("Xunlei.UIEngine.TreeManager")
	objtreeManager:DestroyTree(uiObjectTree)

	--销毁HostWnd
	hostwndManager:RemoveHostWnd(hostWndID)
	
	return ret
end


function EndWindow(tree, ret)
	local hostWnd = tree:GetBindHostWnd()
    local ctrl = tree:GetUIObject("msgboxdlg.border")
	local templateMananger = XLGetObject("Xunlei.UIEngine.TemplateManager")
	local hiddenAniTemplate = templateMananger:GetTemplate("Dlg.HiddenAni","AnimationTemplate")
	
	if hiddenAniTemplate then
		local function onAniFinish(self,old,new)
			if new == 4 then
				CloseWindow(tree,hostWnd, ret)
			end
		end
	
		local hiddenAni = hiddenAniTemplate:CreateInstance()
		hiddenAni:BindObj(ctrl)
		tree:AddAnimation(hiddenAni)
		hiddenAni:AttachListener(true,onAniFinish)
		hiddenAni:Resume() 
	else
		CloseWindow(tree,hostWnd, ret)
	end
end

function CloseWindow(tree,wnd, ret)
	local Class = wnd:GetClassName()
	if Class == "FrameHostWnd" then
		wnd:Destroy()
		local ret = wnd:UnbindUIObjectTree()
		local objtreeManager = XLGetObject("Xunlei.UIEngine.TreeManager")
		local ret = objtreeManager:DestroyTree(tree)
		local hostwndManager = XLGetObject("Xunlei.UIEngine.HostWndManager")
		local wndId = wnd:GetID()	
		local ret = hostwndManager:RemoveHostWnd(wndId)	
		
	elseif Class == "ModalHostWnd" then
		wnd:EndDialog(ret)
	end
end

function Create(info)
	--if info.ClassName then
	--[[info.Width = 500
	info.Height = 200
	info.HideBkgCtrl = nil
	info.ID = "Remote.Test"
	info.Class = "TextObject"
	info.Parent = nil
	info.OnBind = nil
	info.OnDestroy = nil]]
	if not info.ID then
		info.ID = info.Class
	end
	
	local hostWndTemplateID = g_appname..".FrameHostWndHelper.wnd"
	local treeTemplateID = g_appname..".FrameHostWndHelper.tree"
	
	local templateMananger = XLGetObject("Xunlei.UIEngine.TemplateManager")
	local frameHostWndTemplate = templateMananger:GetTemplate(hostWndTemplateID,"HostWndTemplate")
	if frameHostWndTemplate == nil then
		return nil
	end

	local objectTreeTemplate = templateMananger:GetTemplate(treeTemplateID,"ObjectTreeTemplate")
	if objectTreeTemplate == nil then
		return nil
	end
	
	local modify = frameHostWndTemplate:BeginModify()
	local attrModify = modify:GetAttrList()
	
	attrModify:SetAttr("width",info.Width+16+30)
	attrModify:SetAttr("height",info.Height+16+30)
	modify:SetID(info.id)
	--XLMessageBox(modify:GetID())
	frameHostWndTemplate:EndModify(modify)
	
	ModifyObjectTree(objectTreeTemplate, info)
	
	local frameHostWnd = frameHostWndTemplate:CreateInstance(info.ID)
	if frameHostWnd == nil then
		return nil
	end
	local uiObjectTree = objectTreeTemplate:CreateInstance(info.ID)
	if uiObjectTree == nil then
		return nil
	end
	
	frameHostWnd:BindUIObjectTree(uiObjectTree)
	
	frameHostWnd:Create(info.Parent)

	return frameHostWnd, uiObjectTree
end


g_sysButtons = {"VisulAssistant.utility.systembutton","VisulAssistant.utility.systembutton.min","VisulAssistant.utility.systembutton.minmax"}
function ModifyObjectTree(objectTreeTemplate, info)
	local modify = objectTreeTemplate:BeginModify()
	local rootModify = modify:GetRootObject()
	local attrModify = rootModify:GetAttrList()		
	attrModify:SetAttr("width",info.Width+16)
	attrModify:SetAttr("height",info.Height+16)
	modify:SetID(info.id)
	
	local childrenList = rootModify:GetChildrenList()
	local border = childrenList:GetObjectByName("msgboxdlg.border")
	local childrenList = border:GetChildrenList()			
	if info.HideBkgCtrl then
		childrenList:RemoveObjectByName("msgboxdlg.bkgctrl")
		
	end
	local bkg = childrenList:GetObjectByName("msgboxdlg.bkg")
	local childrenList = bkg:GetChildrenList()
	local obj = childrenList:GetObjectByName("Object")
	--local obj = childrenList:AddObject()		
	
	obj:SetClass(info.Class)
	--obj:SetTemplateID("Remote.ModalHostWndHelper.Object")
	local list = obj:GetAttrList()
	list:SetAttr("width",info.Width)
	list:SetAttr("height",info.Height)
	
	local capObj = childrenList:GetObjectByName("msgboxdlg.caption")
	local childrenList = capObj:GetChildrenList()
	local obj = childrenList:GetObjectByName("msgboxdlg.btn.close")
	info.SystemButton = info.SystemButton or 1
	obj:SetTemplateID(g_sysButtons[info.SystemButton])
	objectTreeTemplate:EndModify(modify)
end
