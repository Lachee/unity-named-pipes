// NativeNamedPipe.cpp : Defines the entry point for the application.
//

#include "NativeNamedPipe.h"

extern "C" NATIVEPIPE_API NamedPipeClient* CreateNamedPipeClient()
{
	return new NamedPipeClient();
}

extern "C" NATIVEPIPE_API void DestroyNamedPipeClient(NamedPipeClient* client) 
{
	if (client != NULL) 
	{
		delete client;
		client = NULL;
	}
}

extern "C" NATIVEPIPE_API bool isConnected(NamedPipeClient* client) { return client->isConnected(); }
extern "C" NATIVEPIPE_API int readFrame(NamedPipeClient* client, unsigned char* buffer, int length) { return client->readFrame(buffer, length); }
extern "C" NATIVEPIPE_API int writeFrame(NamedPipeClient* client, unsigned char* buffer, int length) { return client->writeFrame(buffer, length); }
extern "C" NATIVEPIPE_API int open(NamedPipeClient* client, char* pipename) { return client->open(pipename); }
extern "C" NATIVEPIPE_API void close(NamedPipeClient* client) { client->close(); }
