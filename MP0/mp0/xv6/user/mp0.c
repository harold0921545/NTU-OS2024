#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/syscall.h"
#include "kernel/fcntl.h"

int count(char *path, char key){
  int res = 0;
  for (int i = 0; i < strlen(path); ++i)
    res += (path[i] == key);
  return res;
}

int traverse(char *path, char key){
  int fd = open(path, 0);
  struct dirent dir;
  struct stat st;
  if (fd < 0){
    fprintf(2, "wtf\n");
    close(fd);
    return 0;
  }
  if (fstat(fd, &st) < 0){
    fprintf(2, "wtf\n");
    close(fd);
  }

  printf("%s %d\n", path, count(path, key));

  int ret = 0;
  if (st.type == T_DIR){
    ret = 100;
    char buf[512] = {0}, *p;
    strcpy(buf, path);
    p = buf + strlen(buf);
    *p++ = '/';
    while (read(fd, &dir, sizeof(dir)) == sizeof(dir)){
      if (dir.inum == 0 || (strlen(dir.name) == 1 && dir.name[0] == '.') || (strlen(dir.name) == 2 && dir.name[0] == '.' && dir.name[1] == '.'))
        continue;
      memmove(p, dir.name, DIRSIZ);
      p[DIRSIZ] = 0;
      ret += traverse(buf, key);
    }
  }
  else
    ret = 1;
  close(fd);
  return ret;
}

int main(int argc, char *argv[]){
  char *dir_name = argv[1];
  
  int pipefd[2];
  if (pipe(pipefd) == -1){
    fprintf(2, "pipe error\n");
    exit(0);
  }

  if (fork() == 0){ // child
    close(pipefd[0]);
    int fd = open(dir_name, 0);
    struct stat st;
    if (fd < 0){
      printf("%s [error opening dir]\n", dir_name);
      close(fd);
      exit(0);
    }
    if (fstat(fd, &st) < 0 || st.type != T_DIR){
      printf("%s [error opening dir]\n", dir_name);
      close(fd);
      exit(0);
    }
    close(fd);
    
    int ret = traverse(dir_name, argv[2][0]);
    write(pipefd[1], &ret, sizeof(ret));
    close(pipefd[1]);
    exit(0);
  }
  else{ // parent
    close(pipefd[1]);
    int ret;
    read(pipefd[0], &ret, sizeof(int));
    if (ret >= 100)
      ret -= 100;
    printf("\n%d directories, %d files\n", ret / 100, ret % 100);
    close(pipefd[0]);
    exit(0);
  }
}
