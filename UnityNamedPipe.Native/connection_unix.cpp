#include "connection.h"

#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/un.h>
#include <unistd.h>

#ifdef MSG_NOSIGNAL
static int MsgFlags = MSG_NOSIGNAL;
#else
static int MsgFlags = 0;
#endif

class NamedPipeClientUnix : BaseNamedPipeClient
{
public:
	NamedPipeClientUnix()
	{
		sock = -1;
		isOpened = false;
	}

	bool isConnected() override
	{
		return isOpened && sock != -1;
	}

	int readFrame(unsigned char* buffer, int length) override
	{
		if (length == 0) return 0;
		if (!isConnected()) return -1;

		size_t bytesLength = (size_t)length;
		int res = (int)recv(sock, buffer, bytesLength, MsgFlags);
		if (res < 0) return -1 * (xn_getlasterror());

		return res;
	}

	int writeFrame(unsigned char* buffer, int length) override
	{
		if (length == 0) return 0;
		if (!isConnected()) return -1;

		size_t bytesLength = (size_t)length;
		ssize_t sentBytes = send(sock, buffer, length, MsgFlags);
		if (sentBytes < 0) return (int)sentBytes - 1;
		return (int)sentBytes;
	}

	int open(char* pipename) override
	{
		sockaddr_un addr;
		addr.sun_family = AF_UNIX;

		//Create the socket
		sock = socket(AF_UNIX, SOCK_STREAM, 0);
		if (sock == -1) return -1;

		//Yes.. do what this does
		fcntl(sock, F_SETFL, O_NONBLOCK);

#ifdef SO_NOSIGPIPE
		int optval = 1;
		setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, &optval, sizeof(optval));
#endif

		//Update the address
		snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", pipename);
		int err = connect(sock, (const sockaddr*)&addr, sizeof(addr));
		if (err == 0) {
			isOpened = true;
			return 0;
		}

		close();
		return err;
	}

	void close(void) override
	{
		if (isConnected()) ::close(sock);
		sock = -1;
		isOpened = false;
	}


private:
	int sock;
	bool isOpened;
};

BaseNamedPipeClient* BaseNamedPipeClient::create() { return (BaseNamedPipeClient*)(new NamedPipeClientUnix()); }