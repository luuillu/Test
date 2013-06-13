function RegisterBossKey( self )
	local xlConfig = XLGetObject("Xunlei.Thunder.Config")
	local switch = xlConfig:GetValue("BossKey", "BossKeySwitch", 0 )
	if switch == 1 then
		local key_code = xlConfig:GetValue("BossKey", "VirtualKeyCode", 68)
		local modifier = xlConfig:GetValue("BossKey", "Modifiers", 4 )
		if BitAnd( modifier, 4 ) ~= 0 and BitAnd( modifier, 1 ) == 0 then
			modifier = BitOr( BitAnd( modifier, 0xFFFFFFFB ), 1 )
		elseif BitAnd( modifier, 1 ) ~= 0 and BitAnd( modifier, 4 ) == 0 then
			modifier = BitOr( BitAnd( modifier, 0xFFFFFFFE ), 4 )
		end
		local shell = XLGetObject( "VisualAssistant.OSShell" )
		local app = XLGetObject( "Xunlei.Thunder.App" )
		local boss_key_id = shell:GlobalAddAtom( "xl_boss_key" )
		if shell:RegisterHotKey( app:GetHotkeyWnd(), boss_key_id, modifier, key_code ) then
			self.boss_key_id = boss_key_id
		end
	end
end

function UnregisterBossKey( self )
	local boss_key_id = self.boss_key_id
	if boss_key_id ~= nil then
		local shell = XLGetObject("VisualAssistant.OSShell" )
		local app = XLGetObject( "Xunlei.Thunder.App" )
		shell:UnregisterHotKey( app:GetHotkeyWnd(), boss_key_id )
		shell:GlobalDeleteAtom( boss_key_id )
		self.boss_key_id = nil
	end
end

function RegisterKey( self, tree, key_id, call_back, suffix )
	local id = tree:GetID()..".keylist"
	if suffix ~= nil then
		id = id.."."..tostring(suffix)
	end
	local key_list = XLGetGlobal( id )
	if key_list == nil then
		return
	end
	key_list[key_id] = call_back
end

function RegisterGlobalKey( self, key_id, call_back )
	local id = "global.keylist"
	local key_list = XLGetGlobal( id )
	if key_list == nil then
		key_list = {}
		XLSetGlobal( id, key_list )
	end
	key_list[ key_id ] = call_back
end

function UnregisterGlobalKey( self, key_id )
	local id = "global.keylist"
	local key_list = XLGetGlobal( id )
	if key_list == nil then
		return
	end
	key_list[ key_id ] = nil
end

function RegisterTabKey( self, tab_name, key_id, call_back )
	RegisterGlobalKey( self, tab_name..key_id, call_back )
end

function UnregisterTabKey( self, tab_name, key_id )
	UnregisterGlobalKey( self, tab_name..key_id )
end

function UnregisterKey( self, tree, key_id, suffix )
	local id = tree:GetID()..".keylist"
	if suffix ~= nil then
		id = id.."."..tostring(suffix)
	end
	local key_list = XLGetGlobal( id )
	if key_list == nil then
		return
	end
	key_list[key_id] = nil
end

function InitKeyList( self, tree, suffix )
	local key_list = {}
	local id = tree:GetID()..".keylist"
	if suffix ~= nil then
		id = id.."."..tostring(suffix)
	end
	XLSetGlobal( id, key_list )
end

function UninitKeyList( self, tree, suffix )
	local id = tree:GetID()..".keylist"
	if suffix ~= nil then
		id = id.."."..tostring(suffix)
	end
	XLSetGlobal( id, nil )
end

function FilterMessage( self, wnd, suffix )
	wnd:AddInputFilter( true, 
	function (HostWnd,msg,wparam,lparam)
		if msg == 260 or msg == 256 then
			local tree = wnd:GetBindUIObjectTree()
			if tree == nil then
				return
			end
			local list_id = tree:GetID()..".keylist"
			if suffix ~= nil then
				list_id = list_id.."."..tostring(suffix)
			end
			local key_list = XLGetGlobal( list_id )
			local global_key_list = XLGetGlobal( "global.keylist" )
			if key_list == nil and global_key_list == nil then
				return
			end
			local shell = XLGetObject( "VisualAssistant.OSShell" )
			local id = ""
			--VK_CONTROL
			if shell:GetKeyState( 17 ) < 0 then
				id=id.."17."
			end
			--VK_MENU ALT
			if shell:GetKeyState( 18 ) < 0 then
				id=id.."18."
			end
			--VK_SHIFT
			if shell:GetKeyState( 16 ) < 0 then
				id=id.."16."
			end
			id=id..wparam
			if key_list ~= nil and key_list[ id ] ~= nil then
				key_list[ id ]()
				return
			end
		end
	end
	)
end

function RegisterObject( self )
	local obj = {}
	obj.RegisterBossKey = RegisterBossKey
	obj.UnregisterBossKey = UnregisterBossKey
	obj.RegisterKey = RegisterKey
	obj.UnregisterKey = UnregisterKey
	obj.RegisterGlobalKey = RegisterGlobalKey
	obj.UnregisterGlobalKey = UnregisterGlobalKey
	obj.RegisterTabKey = RegisterTabKey
	obj.UnregisterTabKey = UnregisterTabKey
	obj.FilterMessage = FilterMessage
	obj.InitKeyList = InitKeyList
	obj.UninitKeyList = UninitKeyList
	XLSetGlobal("xunlei.KeyHelper", obj )
end