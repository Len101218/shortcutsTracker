#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/keysym.h>
#include <X11/Xos.h>

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

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
  if ((display = XOpenDisplay(0)) == NULL) {
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

  XSelectInput(display, window, KeyPressMask | KeyReleaseMask);
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

  int pipe_fd[2];
  if (pipe(pipe_fd) == -1) {
    perror("Pipe creation failed");
    exit(1);
  }

  pid_t child_pid = fork();

  if (child_pid == -1) {
    perror("Fork failed");
    exit(1);
  }

  if (child_pid == 0) {
    // Child process (Python script)
    //close(pipe_fd[1]);  // Close the write end of the pipe

    //dup2(pipe_fd[0], STDIN_FILENO);  // Redirect standard input to the read end of the pipe
    //close(pipe_fd[0]);  // Close the read end of the pipe

    // Execute the Python script
    //execlp("python3", "python3", "script.py", NULL);
  } else {
    // Parent process (C program)
    //close(pipe_fd[0]);  // Close the read end of the pipe

    struct timeval tv;
    tv.tv_sec = 0;
    tv.tv_usec = 0;
    select(1, NULL, NULL, NULL, &tv);

    int keyHold = 0;  // Flag to indicate key hold

    for (int i =0;i < 100;i++) {
      XNextEvent(display, &ev);
      switch (ev.type) {
        case KeyPress:
          clen = XLookupString(&ev.xkey, cbuf, 9, &ks, 0);
          printf("len=%d,%s\n", clen, cbuf);

          // Write the captured keystroke to the pipe
          write(pipe_fd[1], cbuf, clen);
          keyHold = 1;  // Set the key hold flag
          break;

        case KeyRelease:
          keyHold = 0;  // Reset the key hold flag
          break;

        default:
          if (keyHold) {
            // Handle key hold actions here
            printf("Key held\n");
          }
          break;
      }
    }
  }

  return 0;
}

