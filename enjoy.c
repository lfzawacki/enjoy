#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <linux/joystick.h>
#include <string.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void dump_event(struct js_event e) {

	printf("----\n");
	printf("time: %d\n", e.time);
	printf("value: %x\n", e.value);
	printf("type: %d\n", e.type);
	printf("number: %d\n", e.number);

}

int openDevice(const char* device) {
	return open(device, O_RDONLY );
}

lua_State* openLua() {
	lua_State *L = luaL_newstate();
	luaL_openlibs(L);
/*	luaopen_base(L);*/
/*	luaopen_table(L);*/
/*	luaopen_string(L);*/
/*	luaopen_math(L);*/
/*	luaopen_os(L);*/

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

	while(1) {
		len = read(fd, &msg, sizeof(msg));

		if (len == sizeof(msg)) { //read was succesfull

			if (msg.type == JS_EVENT_BUTTON && msg.value == 1) { // seems to be a key press
				dump_event(msg);

				lua_getglobal(L,"event");
				lua_pushnumber(L, (double) msg.number );

				if(lua_pcall(L, 1, 0, 0) != 0) {
					return luaL_error(L,"%s\n",lua_tostring(L, -1));
				}

			}

		}
	}

	return 0;

}

