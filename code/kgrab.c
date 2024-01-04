#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>
#include <X11/Xos.h>

#include <stdlib.h>
#include <stdio.h>

int main() {
  XEvent ev;
  KeySym ks;
  char cbuf[10];
  int clen;


  Display *display;
  Window window;
  XSetWindowAttributes attrib;
  int ret;
  
  // Open X display
  if((display = XOpenDisplay(0)) == NULL) {
    fprintf(stderr, "kgrab: cannot open display\n");
    exit(1);
  }

  attrib.override_redirect = True;

  window = XCreateWindow(
      display,
      DefaultRootWindow(display),
      0, 0, 1, 1, 0,
      CopyFromParent,
      InputOnly,
      CopyFromParent,
      CWOverrideRedirect,
      &attrib
  );

  XSelectInput(display, window, KeyPressMask|KeyReleaseMask);
  XMapWindow(display, window);

  ret = XGrabKeyboard(
      display,
      window,
      False,
      GrabModeAsync,
      GrabModeAsync,
      CurrentTime
  );
  if (ret != GrabSuccess) {
    fprintf(stderr, "kgrab: cannot grab keyboard\n");
  }

  struct timeval tv;
  tv.tv_sec=0;
  tv.tv_usec=0;
  select(1, NULL, NULL, NULL, &tv);
  for(;;){
    XNextEvent(display, &ev);
    switch(ev.type){
      case KeyPress:
        clen = XLookupString(&ev.xkey,cbuf,9, &ks,0);
        switch(ks){
            case XK_Escape: case XK_Clear:
              exit(0);
        }
        printf("len=%d,%s\n",clen,cbuf);
        break;
      case KeyRelease:
      default:
        if (keyHold) {
            // Handle key hold actions here
            printf("Key held\n");
        }
        break;
        printf("%d",ev.type);
    }
  }
}
