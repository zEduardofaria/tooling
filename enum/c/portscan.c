#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s ip_address\n", argv[0]);
        exit(1);
    }

    char *address = argv[1];
    struct addrinfo hints, *res, *p;
    int status, sockfd;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if ((status = getaddrinfo(address, NULL, &hints, &res)) != 0) {
        fprintf(stderr, "Error resolving address: %s\n", gai_strerror(status));
        exit(2);
    }

    for (p = res; p != NULL; p = p->ai_next) {
        if ((sockfd = socket(p->ai_family, p->ai_socktype, p->ai_protocol)) == -1) {
            perror("socket");
            continue;
        }

        if (connect(sockfd, p->ai_addr, p->ai_addrlen) == -1) {
            close(sockfd);
            continue;
        }

        printf("Open port: %d\n", ntohs(((struct sockaddr_in *)p->ai_addr)->sin_port));
        close(sockfd);
    }

    freeaddrinfo(res);

    return 0;
}