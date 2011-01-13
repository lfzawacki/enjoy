#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// this should be modularized for other OS
#include <fcntl.h>
#include <linux/joystick.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

////// keypresses module starts
#include "key_event.h"

int lua_send_key_event( lua_State* L )
{
	if ( lua_isstring(L,1) && lua_isboolean(L,2) ) {
		send_key_event(lua_tostring(L,1) , lua_toboolean(L,2) );
	} else {
		luaL_error(L,"Dammit! Gimme a keycode...");
	}

	return 0;
}

////// and ends here ...

void dump_event(struct js_event e) {

	printf("----\n");
	printf("time: %d\n", e.time);
	printf("value: %s\n", e.value == 1 ? "DOWN" : "UP" );
	printf("type: %d\n", e.type);
	printf("number: %d\n", e.number);

}

int openDevice(const char* device) {
	return open(device, O_RDONLY );
}

lua_State* openLua() {
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);
	return L;
}

void loadLuaFile(lua_State* L, const char* filename)
{
	int error = luaL_dofile(L, filename);

	if(error) {
		printf("%s",lua_tostring(L, -1));
		lua_error(L);
	}

	//lua_pcall(L, 0, 0, 0);
}

int main() {
	unsigned int len = 0;
	struct js_event msg;

	int fd = openDevice("/dev/input/js0");
	lua_State *L = openLua();
	loadLuaFile(L,"core.lua");

	lua_register(L, "__send_key_event" , lua_send_key_event );

	while(1) {
		len = read(fd, &msg, sizeof(msg));

		if (len == sizeof(msg)) { //read was succesfull

			if (msg.type == JS_EVENT_BUTTON) { // seems to be a key press
				dump_event(msg);

				lua_getglobal(L,"__event_button");
				lua_pushnumber(L, (double) msg.number );
				lua_pushboolean(L, (int) msg.value );

				if(lua_pcall(L, 2, 0, 0) != 0) {
					return luaL_error(L,"%s\n",lua_tostring(L, -1));
				}

			}

		}
	}

	return 0;

}

