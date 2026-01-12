#include <stdio.h>
#include <stdlib.h>
#include "scheme.h"

int main(int argc, char* argv[]) {

  Sscheme_init(0);
  Sregister_boot_file("booter/mac/petite.boot");
  Sregister_boot_file("booter/mac/scheme.boot");

  Sbuild_heap(argv[0], 0);

  Sscheme_program("replica.mac.boot", argc, (const char **)argv);

  Sscheme_deinit();
  return 0;
}
