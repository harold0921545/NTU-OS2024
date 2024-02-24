#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/syscall.h"
#include "kernel/fcntl.h"

const int MAX_NAME_LEN = 10;
const int MAX_FILE_NUM = 20;


char* fmtname(char *path){
  static char buf[DIRSIZ+1];
  char *p;
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

int count(char *path, char key){
  int res = 0;
  for (int i = 0; i < strlen(path); ++i)
    res += (path[i] == key);
  return res;
}

void traverse(char *path, char key){
  int fd = open(path, O_RDONLY);
  struct dirent dir;
  struct stat st;
  stat(path, &st);
  printf("%s %d\n", path, count(path, key));
  if (st.type == T_DIR){
    while (1){
      char buf[512] = {0}, *p;
      strcpy(buf, path);
      p = buf+strlen(buf);
      *p++ = '/';
      while(read(fd, &dir, sizeof(dir)) == sizeof(dir)){
        if (dir.inum == 0 || (strlen(dir.name) == 1 && dir.name[0] == '.') || (strlen(dir.name) == 2 && dir.name[0] == '.' && dir.name[1] == '.'))
          continue;
        memmove(p, dir.name, DIRSIZ);
        p[DIRSIZ] = 0;
        traverse(buf, key);
      }
    }
  }
  close(fd);
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
    int fd = open(dir_name, O_RDONLY);
    struct stat st;
    stat(dir_name, &st);
    if (fd == -1 || st.type != T_DIR){
      printf("%s [error opening dir]\n", dir_name);
      exit(0);
    }
    traverse(dir_name, argv[2][0]);
    close(pipefd[1]);
    exit(0);
  }
  else{ // parent
    close(pipefd[1]);
    close(pipefd[0]);
    exit(0);
  }
}
