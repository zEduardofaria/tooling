#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <netdb.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Usage: %s address\n", argv[0]);
        exit(1);
    }

    char *endereco = argv[1];
    struct addrinfo hints, *res;
    int status;

    memset(&hints, 0, sizeof(hints));
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM;

    if ((status = getaddrinfo(endereco, NULL, &hints, &res)) != 0) {
        fprintf(stderr, "Error when resolve the address: %s\n", gai_strerror(status));
        exit(2);
    }

    char ipstr[INET6_ADDRSTRLEN];
    void *addr;

    if (res->ai_family == AF_INET) {
        struct sockaddr_in *ipv4 = (struct sockaddr_in *)res->ai_addr;
        addr = &(ipv4->sin_addr);
    } else {
        struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *)res->ai_addr;
        addr = &(ipv6->sin6_addr);
    }

    inet_ntop(res->ai_family, addr, ipstr, sizeof(ipstr));
    printf("Address Resolved: %s -> %s\n", endereco, ipstr);

    freeaddrinfo(res);

    return 0;
}
