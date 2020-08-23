#ifndef __OUTPUT_BUFFER__
#define __OUTPUT_BUFFER__

#include <cstdio>

class OutputBuffer {
public:
  OutputBuffer() 
    : pos(0) {
  }

  ~OutputBuffer() {
    flush();
  }

  void putc(char c) {
    if (pos == sizeof(_buff))
      flush();
    _buff[pos++] = c;
  }

  void puts(const char* c) {
    while(*c)
      putc(*c++);
  }

  void putu(unsigned n) {
    char digits[11];
    size_t i = 0;
    do {
      digits[i++] = '0' + n % 10;
      n /= 10;
    } while (n);
    while(i--)
      putc(digits[i]);
  }

  void flush() {
    fwrite(_buff, sizeof(char), pos, stdout);
    pos = 0;
  }

private:
  static const size_t MAX_BUFF = 65536;

  size_t pos;
  char _buff[MAX_BUFF];
};

#endif
