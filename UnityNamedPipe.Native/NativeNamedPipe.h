// NativeNamedPipe.h : Include file for standard system include files,
// or project specific include files.

#pragma once

#include "connection.h"
#include <iostream>

#  if defined(_WIN32)
#    define NATIVEPIPE_API __declspec(dllexport)
#  else
#    define NATIVEPIPE_API __attribute__((visibility("default")))
#  endif

extern "C" NATIVEPIPE_API BaseNamedPipeClient* createClient();
extern "C" NATIVEPIPE_API void destroyClient(BaseNamedPipeClient* client);

extern "C" NATIVEPIPE_API bool isConnected(BaseNamedPipeClient* client);
extern "C" NATIVEPIPE_API int readFrame(BaseNamedPipeClient* client, unsigned char* buffer, int length);
extern "C" NATIVEPIPE_API int writeFrame(BaseNamedPipeClient* client, unsigned char* buffer, int length);
extern "C" NATIVEPIPE_API int open(BaseNamedPipeClient* client, char* pipename);
extern "C" NATIVEPIPE_API void close(BaseNamedPipeClient* client);
extern "C" NATIVEPIPE_API bool test(int a, int b, int* out) 
{
	*out = a + b;
	return *out == 0;
}