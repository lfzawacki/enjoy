#include "key_event.h"

#include <X11/Xlib.h>
#include <X11/extensions/XTest.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
/** this is here because of
 *  error: initializer element is not constant
 */

Display* x11_get_display() {

	static int initialized = 0;
	static Display *d = NULL;

	if ( !initialized ) {
		d = XOpenDisplay(0);
		initialized = 1;
	}

	return d;

}

// modifies the string in place and returns it
char* toupperall( const char* str )
{
	int len = strlen(str);
	int i;
	char *tmp = strdup(str);

	for( i=0 ; i < len ; i++ ) tmp[i] = toupper(tmp[i]) ;

	return tmp;
}

void send_key_down_event( const char* keycode )
{
	Display* d = x11_get_display();

	char* upper = toupperall(keycode);
	int code = XStringToKeysym(upper);
	free(upper);

	if ( code == NoSymbol ) {
		return;
	}

	printf("CODE: %x\n",code);
	// (display , keycode , is_pressed , delay )
	XTestFakeKeyEvent(d, code , 1 , 0);
	XFlush(d);
}

void send_key_up_event( const char* keycode )
{
	Display* d = x11_get_display();

	char* upper = toupperall(keycode);
	int code = XStringToKeysym(upper);
	free(upper);

	if ( code == NoSymbol ) {
		return;
	}

	printf("CODE: %x\n",code);
	// (display , keycode , is_pressed , delay )
	XTestFakeKeyEvent(d, code , 0 , 0);
	XFlush(d);
}
