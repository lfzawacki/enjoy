#include "key_event.h"

#include <X11/Xlib.h>
#include <X11/extensions/XTest.h>

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

void send_key_down_event( int keycode )
{
	Display* d = x11_get_display();
	// (display , keycode , is_pressed , delay )
	XTestFakeKeyEvent(d, keycode , 1 , 0);
	XFlush(d);
}

void send_key_up_event( int keycode )
{
	Display* d = x11_get_display();
	// (display , keycode , is_pressed , delay )
	XTestFakeKeyEvent(d, keycode , 0 , 0);
	XFlush(d);
}

