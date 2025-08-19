#include <stdio.h>
#include <ctype.h>

int main(void) {
    int c, in_word = 0;
    long lines = 0, words = 0, chars = 0;

    while ((c = getchar()) != EOF) {
        chars++;
        if (c == '\n') lines++;
        if (isalpha((unsigned char)c)) {
            if (!in_word) { words++; in_word = 1; }
        } else {
            in_word = 0;
        }
    }
    printf("%8ld%8ld%8ld\n", lines, words, chars);
    return 0;
}
