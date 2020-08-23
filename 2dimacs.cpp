#include <map>
#include <cstdio>
#include <cctype>
#include <cstring>
#include <cstdlib>
#include <string>


#include "input-buffer.hpp"
#include "output-buffer.hpp"

std::map<std::string, size_t> codes;
size_t code = 1;

#define MAX_WORD 50
int main(int argc, char* argv[]) {
  if (argc < 2) {
    fprintf(stderr, "coding file expected\n");
    exit(EXIT_FAILURE);
  }
  FILE* CODING = fopen(argv[1], "w");

  InputBuffer ibuff;
  OutputBuffer obuff;

  char word[MAX_WORD];

  size_t clauses = 0;

  bool has_lits = false;;

  while (ibuff.gets(word, MAX_WORD)) {
    // skip // coments
    if (word[0] == '/' && word[1] == '/') {
      ibuff.skipline();
      continue;
    }
    
    // Empty words indicate EOL
    if (word[0] == '\0') {
      if (has_lits) {
	clauses++;
	obuff.puts("0\n");
	has_lits = false;
      }
      continue;
    }

    // Skip leading -
    char* p = word;
    if (*p == '-') {
      obuff.putc('-');
      p++;
    }

    // Find code
    size_t c;
    std::map<std::string, size_t>::const_iterator i;
    i = codes.find(p);
    if (i == codes.end()) {
      c = code++;
      fprintf(CODING, "%s\t%lu\n", p, c);
      codes[p] = c;
    } else {
      c = i->second;
    }
    has_lits = true;
    obuff.putu(c);
    obuff.putc(' ');
  }

  obuff.puts("p cnf ");
  obuff.putu(code - 1);
  obuff.putc(' ');
  obuff.putu(clauses);
  obuff.putc('\n');

  fclose(CODING);
}
