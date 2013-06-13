
local path = __document:gsub("[^\\/]*$","")
local wndHelper = XLLoadModule( path.."\\Base\\HostWndHelper.lua")

local provider = XLLoadModule( path.."\\ctrl\\UIProvider.lua")
XLSetGlobal("VisualAssistant.UIProvider",provider)

local KeyHelper = XLLoadModule( path.."\\thunderbolt\\KeyHelper.lua")
KeyHelper:RegisterObject()

SetOnceTimer(function() 
	local info = {
		Width = 1000,
		Height = 700,
		Class = "VisualAssistant.Main",
		SystemButton = 3,
	}
	wndHelper.Create(info)	
end,1000)

