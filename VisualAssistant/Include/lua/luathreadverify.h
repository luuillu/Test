/********************************************************************
*
* =-----------------------------------------------------------------=
* =                                                                 =
* =             Copyright (c) Xunlei, Ltd. 2004-2011              =
* =                                                                 =
* =-----------------------------------------------------------------=
* 
*   FileName    :   luathreadverify
*   Author      :   ������
*   Create      :   2011-10-9 11:30
*   LastChange  :   2011-10-9 11:30
*   History     :	
*
*   Description :   ���Զ�lua��������̰߳�ȫ��⣬����Ĳ��ֹ�����Ҫ�����̰߳�ȫ��⣬ֻҪinclude��
					ͷ�ļ�����
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

// ���ټ��luastate�̰߳�ȫ�ķ�ʽ
void CheckLightLuaState(lua_State* luaState, unsigned long dwEBP, const char* lpFunName);

// ��ʼ��luastate���߳�id
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

// ����ļ�⣬ʹ�õ�lua_lock��
#ifdef lua_lock
#undef lua_lock
#endif // lua_lock

#define lua_lock(L) THREAD_CHECK_LIGHT_LUASTATE(L)

#define INIT_LUASTATE_THREAD(luaState, threadid)  InitLuaStateThread(luaState, threadid)

#else //__XLUE_LUARUNTIM_CHECK_THREAD__

#define INIT_LUASTATE_THREAD(luaState, threadid) 

#endif // __XLUE_LUARUNTIM_CHECK_THREAD__

#endif //__LUATHREADVERIFY_H__