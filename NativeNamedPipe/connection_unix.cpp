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

BaseNamedPipeClient* BaseNamedPipeClient::create() { return (BaseNamedPipeClient*)(new NamedPipeClientUnix()); }

class NamedPipeClientUnix : BaseNamedPipeClient
{
public:
	NamedPipeClientUnix()
	{
		socket = -1;
		isOpened = false;
	}

	bool isConnected();
	int readFrame(unsigned char* buffer, int length);
	int writeFrame(unsigned char* buffer, int length);

	int open(char* pipename);
	void close(void);

private:
	int socket;
	bool isOpened;
};



NamedPipeClientUnix::NamedPipeClient()
{
	socket = -1;
	isOpened = false;
}

bool NamedPipeClientUnix::isConnected()
{
	return isOpened && socket != -1;
}

int NamedPipeClientUnix::open(char* pipename)
{
	sockaddr_un addr;
	addr.sun_family = AF_UNIX;

	//Create the socket
	socket = socket(AF_UNIX, SOCK_STREAM, 0);
	if (socket == -1) return -1;

	//Yes.. do what this does
	fcntl(socket, F_SETFL, O_NONBLOCK);

#ifdef SO_NOSIGPIPE
	int optval = 1;
	setsockopt(socket, SOL_SOCKET, SO_NOSIGPIPE, &optval, sizeof(optval));
#endif

	//Update the address
	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", pipename);
	int err = connect(socket, (const sockaddr*)&addr, sizeof(addr));
	if (err == 0) {
		isOpened = true;
		return 0;
	}

	close();
	return err;
}

void NamedPipeClientUnix::close()
{
	if (isConnected()) close(socket);
	socket = -1;
	isOpened = false;
}

int NamedPipeClientUnix::readFrame(unsigned char* buffer, int length)
{
	if (length == 0) return 0;
	if (!isConnected()) return -1;

	size_t bytesLength = (size_t)length;
	int res = (int)recv(socket, data, bytesLength, MsgFlags);
	if (res < 0) return (int)res - 1;

	return res;
}

int NamedPipeClientUnix::writeFrame(unsigned char* buffer, int length)
{
	if (length == 0) return 0;
	if (!isConnected()) return -1;

	size_t bytesLength = (size_t)length;
	ssize_t sentBytes = send(socket, buffer, length, MsgFlags);
	if (sentBytes < 0) return (int)sentBytes - 1;
	return (int)sentBytes;
}