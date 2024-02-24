#include "kernel/types.h"

#include "kernel/fcntl.h"
#include "kernel/stat.h"
#include "user/user.h"
void mkfile(char *filename) {
    int fd = open(filename, O_CREATE | O_RDWR);
    write(fd, "qqhahaha", 3);
    close(fd);
}

void mkd(char *dirname) {
    if (mkdir(dirname) < 0) {
        fprintf(2, "mkdir %s failed.", dirname);
        exit(1);
    }
}
void test0() {
    mkd("os2023");

    mkd("os2023/d1");
    mkd("os2023/d2");
    mkd("os2023/d3");

    mkd("os2023/d2/a");
    mkd("os2023/d2/b");
    mkfile("os2023/d2/c");

    mkd("os2023/d3/a");
    mkfile("os2023/d3/b");
}

void test1() {
    mkd("a");
    mkd("a/0");
    mkd("a/1");
    mkd("a/2");
    mkd("a/3");
    mkd("a/4");
    mkd("a/5");
    mkd("a/6");
    mkd("a/7");
    mkd("a/8");
    mkd("a/9");
    mkd("a/10");
}

void test2() {
    mkd("longstring");
    mkd("longstring/longstring");
    mkd("longstring/longstring/longstring");
    mkd("longstring/longstring/longstring/nevergonna");
    mkd("longstring/longstring/longstring/nevergonna/giveyouupp");
    mkd("longstring/longstring/shihhhhhhh");
    mkd("longstring/longstring/shihhhhhhh/guangggggg");
    mkd("longstring/longstring/shihhhhhhh/guangggggg/linggggggg");
    mkd("longstring/aaaaaaaaaa");
    mkd("longstring/aaaaaaaaaa/aaaaaaaaaa");
    mkd("longstring/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa");
    mkd("longstring/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa");
}

void test3() {
    mkd("b");
    mkfile("b/0");
    mkfile("b/1");
    mkfile("b/2");
    mkfile("b/3");
    mkfile("b/4");
    mkfile("b/5");
    mkfile("b/6");
    mkfile("b/7");
    mkfile("b/8");
    mkfile("b/9");
    mkfile("b/10");
}

int main(int argc, char *argv[]) {
    test0();
    test1();
    test2();
    test3();
    exit(0);
}
