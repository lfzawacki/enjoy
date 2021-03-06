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

void send_key_event( const char* keycode , int keydown )
{
	Display* d = x11_get_display();

	int code = XStringToKeysym(keycode);

	if ( code == NoSymbol ) {
		printf("No symbol");
		return;
	}

	printf("CODE: %x\nLULZ: %s\n",code, XKeysymToString(XKeycodeToKeysym(d,code,0)));
	// (display , keycode , is_pressed , delay )
	XTestFakeKeyEvent(d, code , keydown , 0);
	XFlush(d);
}

