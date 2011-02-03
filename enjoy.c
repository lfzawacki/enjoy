#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <SDL/SDL.h>

#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>

void init() {
	SDL_Init(SDL_INIT_JOYSTICK|SDL_INIT_VIDEO);
	SDL_JoystickEventState(SDL_ENABLE);
}

void dumpEvent(SDL_Event e, unsigned int time) {
	printf("----\n");
	printf("time: %u\n", time);
	printf("value: %s\n", e.type == SDL_JOYBUTTONDOWN ? "DOWN" : "UP" );
	printf("number: %d\n", e.jbutton.button);
}

void handleEvents(lua_State* L)
{

	while(1) {
		SDL_Event event;
		while(SDL_WaitEvent(&event)) {

			switch(event.type) {

				case SDL_JOYBUTTONDOWN:
				case SDL_JOYBUTTONUP:

				dumpEvent(event,time(0));

				lua_getglobal(L,"__event_button");
				lua_pushnumber(L, (double) event.jbutton.button );
				lua_pushboolean(L, (int) event.type == SDL_JOYBUTTONDOWN );

				if(lua_pcall(L, 2, 0, 0) != 0) {
					luaL_error(L,"%s\n",lua_tostring(L, -1));
				}

				break;

				case SDL_JOYAXISMOTION:
					printf("axes\n");
					break;

			}

		}
	}
}

void openJoystick(int index) {

	SDL_Joystick *joy;

	if( SDL_NumJoysticks() > 0){

		joy = SDL_JoystickOpen(index);

		if(joy) {
			printf("Using: %s\n", SDL_JoystickName(index));
			printf("Number of Axes: %d\n", SDL_JoystickNumAxes(joy));
			printf("Number of Buttons: %d\n", SDL_JoystickNumButtons(joy));
			printf("Number of Balls: %d\n", SDL_JoystickNumBalls(joy));
		}
		else {
			printf("Shiet\n");
			exit(1);
		}

	}
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

}

// returns the joy index or -1 in case of error
int selectJoy(const char* index_string) {
	int index,ret;

	return sscanf(index_string,"%d",&index) ? index : -1;
}

void printJoyInfo()
{
	int njoys = SDL_NumJoysticks();
	if ( njoys == 0) {
		printf("No joystick detected.\n");
	} else {
		int i;
		for (i=0; i< njoys; i++) {
			printf("%d %s\n", i, SDL_JoystickName(i));
		}

	}
}


int main(int argc, char** argv) {

	// TODO print usage and parameters

	init();

	if (argc < 2) {
		printJoyInfo();
		exit(0);
	}

	int selected = selectJoy(argv[1]);

	if (selected < 0) {
		//shiet
		printf("shiet\n");
		exit(1);
	}

	printf("%d\n",selected);
	openJoystick(selected);
	lua_State *L = openLua();

	// TODO have core.lua as a precompiled binary
	loadLuaFile(L,"core.lua");

	// lua_register(L, "__send_key_event" , lua_send_key_event );

	handleEvents(L);

	return 0;

}

