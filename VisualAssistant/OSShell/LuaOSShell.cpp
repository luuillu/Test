
# include "LuaOSShell.h"

static XLLRTGlobalAPI LuaOSShellMemberFunctions[] = 
{
	{"GetKeyState",LuaOSShell::GetKeyState},
	{NULL,NULL}
};

void LuaOSShell::RegisterObj(XL_LRT_ENV_HANDLE hEnv)
{
	if(hEnv == NULL)
	{
		return ;
	}

	XLLRTObject theObject;
	theObject.ClassName = LUAOSSHELL_CLASS;
	theObject.MemberFunctions = LuaOSShellMemberFunctions;
	theObject.ObjName = LUAOSSHELL_OBJ;
	theObject.userData = NULL;
	theObject.pfnGetObject = (fnGetObject)LuaOSShell::GetObject;

	XLLRT_RegisterGlobalObj(hEnv,theObject); 
}

LuaOSShell*  __stdcall LuaOSShell::GetObject(void*)
{
	static LuaOSShell* pInstance = new LuaOSShell;
	return pInstance;
}

int LuaOSShell::GetKeyState(lua_State*luaState)
{
	int nVirtKey = lua_tointeger(luaState,2);
	lua_pushinteger( luaState, (SHORT)::GetKeyState( nVirtKey));
	return 1;
}