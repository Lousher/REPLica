#include <stdio.h>

typedef void (*CB)(char);

CB callbacks[256];

void cb_init(void) {
  int i;
  for (i = 0; i < 256; i += 1)
    callbacks[i] = (CB)0;
}

void register_callback(char c, CB cb) {
  callbacks[c] = cb;
}

void event_loop(void) {
  CB f; char c;

  for (;;) {
    c = getchar();
    if (c == EOF) break;
    f = callbacks[c];
    if (f != (CB)0) f(c);
  }
}
    
