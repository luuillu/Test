function systembutton_OnMinisize(self)
	local tree = self:GetOwner()
	local wnd = tree:GetBindHostWnd()
	wnd:Min()
end

function systembutton_OnMaxSize(self)
	local tree = self:GetOwner()
	local wnd = tree:GetBindHostWnd()
	local state = wnd:GetWindowState()
	if state == "max" then
		wnd:Restore()
		self:SetMaxState( true )
	else
		wnd:Max()
		self:SetMaxState( false )
	end
end

function systembutton_OnClose(self)											
	local path = __document:gsub("[^\\/]*$","")
	local mod = XLLoadModule( path.."\\HostWndHelper.lua")
	mod.EndWindow(self:GetOwner(), 0)
end

function systembutton_OnInitControl(self)
	AsynCall(function()		
		XLGetGlobal( "xunlei.KeyHelper" ):RegisterKey( self:GetOwner(), "27", function()
				self:FireExtEvent("OnClose")
				
		end)													
	end)
end