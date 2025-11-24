#include <stdio.h>

int count_chars(const char *str) {
    int count = 0;

    while (*str != '\0') {   // loop until null terminator
        count++;             // increase counter
        str++;               // move to next character
    }

    return count;
}

int main() {
    char text[] = "Hello world!";
    int length = count_chars(text);

    printf("Length = %d\n", length);
    return 0;
}
