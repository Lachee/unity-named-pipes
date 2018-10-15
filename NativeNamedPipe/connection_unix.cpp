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


NamedPipeClient::NamedPipeClient()
{
	handle = NULL;
	isOpened = false;
}

bool NamedPipeClient::isConnected()
{
	return isOpened && handle != NULL && handle != -1;
}

int NamedPipeClient::open(char* pipename)
{
	sockaddr_un addr;
	addr.sun_family = AF_UNIX;

	//Create the socket
	handle = socket(AF_UNIX, SOCK_STREAM, 0);
	if (handle == -1) return -1;

	//Yes.. do what this does
	fcntl(handle, F_SETFL, O_NONBLOCK);

#ifdef SO_NOSIGPIPE
	int optval = 1;
	setsockopt(handle, SOL_SOCKET, SO_NOSIGPIPE, &optval, sizeof(optval));
#endif

	//Update the address
	snprintf(addr.sun_path, sizeof(addr.sun_path), "%s", pipename);
	int err = connect(handle, (const sockaddr*)&addr, sizeof(addr));
	if (err == 0) {
		isOpened = true;
		return 0;
	}

	close();
	return err;
}

void NamedPipeClient::close()
{
	if (handle != NULL && handle != -1)
		close(handle);

	handle = -1;
	isOpened = false;
}

int NamedPipeClient::readFrame(unsigned char* buffer, int length)
{
	if (length == 0) return 0;
	if (!isConnected()) return -1;

	size_t bytesLength = (size_t)length;
	int res = (int)recv(handle, data, bytesLength, MsgFlags);
	if (res < 0) return (int)res - 1;

	return res;
}

int NamedPipeClient::writeFrame(unsigned char* buffer, int length)
{
	if (length == 0) return 0;
	if (!isConnected()) return -1;

	size_t bytesLength = (size_t)length;
	ssize_t sentBytes = send(handle, buffer, length, MsgFlags);
	if (sentBytes < 0) return (int)sentBytes - 1;
	return (int)sentBytes;
}