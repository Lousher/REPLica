#include <stdio.h>
#include <stdlib.h>
#include "scheme.h"

int main(int argc, char* argv[]) {
  Sscheme_init(0);
  Sregister_boot_file("petite.boot");
  Sregister_boot_file("scheme.boot");
  Sregister_boot_file("replica.boot");

  Sbuild_heap(argv[0], 0);

  Sscheme_program(argv[0], argc, (const char **)argv);

  Sscheme_deinit();
  return 0;
}
