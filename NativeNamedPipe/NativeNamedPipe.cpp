// NativeNamedPipe.cpp : Defines the entry point for the application.
//

#include "NativeNamedPipe.h"

extern "C" NATIVEPIPE_API BaseNamedPipeClient* CreateClient() { return BaseNamedPipeClient::create(); }

extern "C" NATIVEPIPE_API void DestroyClient(BaseNamedPipeClient* client)
{
	if (client != NULL) 
	{
		//close the client
		if (isConnected(client))
			close(client);

		//delete and nullify the client
		delete client;
		client = NULL;
	}
}

extern "C" NATIVEPIPE_API bool isConnected(BaseNamedPipeClient* client) { return isConnected(client); }
extern "C" NATIVEPIPE_API int readFrame(BaseNamedPipeClient* client, unsigned char* buffer, int length) { return readFrame(client, buffer, length); }
extern "C" NATIVEPIPE_API int writeFrame(BaseNamedPipeClient* client, unsigned char* buffer, int length) { return writeFrame(client, buffer, length); }
extern "C" NATIVEPIPE_API int open(BaseNamedPipeClient* client, char* pipename) { return open(client, pipename); }
extern "C" NATIVEPIPE_API void close(BaseNamedPipeClient* client) { close(client); }
