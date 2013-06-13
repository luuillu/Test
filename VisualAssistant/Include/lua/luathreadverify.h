/********************************************************************
*
* =-----------------------------------------------------------------=
* =                                                                 =
* =             Copyright (c) Xunlei, Ltd. 2004-2011              =
* =                                                                 =
* =-----------------------------------------------------------------=
* 
*   FileName    :   luathreadverify
*   Author      :   李亚星
*   Create      :   2011-10-9 11:30
*   LastChange  :   2011-10-9 11:30
*   History     :	
*
*   Description :   用以对lua虚拟机的线程安全检测，如果哪部分功能需要进行线程安全检测，只要include该
					头文件即可
*
********************************************************************/ 
#ifndef __LUATHREADVERIFY_H__
#define __LUATHREADVERIFY_H__

#ifdef TSLOG
#define  __XLUE_LUARUNTIM_CHECK_THREAD__
#endif

#ifdef __XLUE_LUARUNTIM_CHECK_THREAD__

#ifdef __cplusplus
extern "C"{
#endif //__cplusplus

// 快速检测luastate线程安全的方式
void CheckLightLuaState(lua_State* luaState, unsigned long dwEBP, const char* lpFunName);

// 初始化luastate的线程id
void InitLuaStateThread(lua_State* luaState, unsigned long threadid);

#ifdef __cplusplus
};
#endif //__cplusplus

#define THREAD_CHECK_LIGHT_LUASTATE(state) \
	do{\
		unsigned long __dwEBP2 = 0; \
		do { \
			__asm	mov __dwEBP2, ebp \
		}while(0);  \
		CheckLightLuaState(state, __dwEBP2, (const char*)__FUNCTION__ ); \
	}while(0);

// 这里的检测，使用的lua_lock宏
#ifdef lua_lock
#undef lua_lock
#endif // lua_lock

#define lua_lock(L) THREAD_CHECK_LIGHT_LUASTATE(L)

#define INIT_LUASTATE_THREAD(luaState, threadid)  InitLuaStateThread(luaState, threadid)

#else //__XLUE_LUARUNTIM_CHECK_THREAD__

#define INIT_LUASTATE_THREAD(luaState, threadid) 

#endif // __XLUE_LUARUNTIM_CHECK_THREAD__

#endif //__LUATHREADVERIFY_H__