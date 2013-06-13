#include "stdafx.h"
#include "./LuaOSShell.h"

BOOL APIENTRY DllMain( HANDLE hModule, 
					  DWORD  ul_reason_for_call, 
					  LPVOID lpReserved
					  )
{
	if(ul_reason_for_call == DLL_PROCESS_ATTACH)
	{
		XL_LRT_ENV_HANDLE hEnv = XLLRT_GetEnv(NULL);
		LuaOSShell::RegisterObj(hEnv);
	}

	return TRUE;
}

__declspec(dllexport) void NoUse()
{

}