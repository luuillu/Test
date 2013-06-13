
#include "stdafx.h"
#define LUAOSSHELL_CLASS "VisualAssistant.OSShell.Class"
#define LUAOSSHELL_OBJ "VisualAssistant.OSShell"

class LuaOSShell
{	
public:
	static void RegisterObj(XL_LRT_ENV_HANDLE hEnv);
	static LuaOSShell*  __stdcall GetObject(void*);
	static int GetKeyState(lua_State*);
};