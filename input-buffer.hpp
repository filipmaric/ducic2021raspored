#ifndef __INPUT_BUFFER_HPP__
#define __INPUT_BUFFER_HPP__


class InputBuffer {
public:
  InputBuffer() 
    : pos(MAX_BUFF) {
  }

  char getc() {
    if (pos == MAX_BUFF)
      load();
    return _buff[pos++];
  }

  bool gets(char s[], size_t max) {
    char c;
    while ((c = getc()) == ' ' || c == '\t')
      ;

    if (c == EOF)
      return false;

    if (c == '\n') {
      s[0] = '\0';
      return true;
    }

    size_t p = 0;
    do {
      s[p++] = c;
      c = getc();
    } while (p < max - 1 && 
	     c != ' ' && 
	     c != '\t' && 
	     c != '\r' && 
	     c != '\n' && 
	     c != EOF);
    ungetc();
    s[p] = '\0';
    return true;
  }
  
  void skipline() {
    char c;
    while((c = getc()) != '\n' && c != EOF)
      ;
  }

private:
  static const size_t MAX_BUFF = 65536;

  void ungetc() {
    pos--;
  }

  void load() {
    pos = 0;
    size_t r = fread(_buff, 1, MAX_BUFF, stdin);
    if (r < MAX_BUFF)
      _buff[r] = EOF;
  }

  size_t pos;
  char _buff[MAX_BUFF];
};

#endif
