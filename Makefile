all:
	gcc -o enjoy enjoy.c key_event_x11.c -llua -lm -lX11 -lXtst -ldl

