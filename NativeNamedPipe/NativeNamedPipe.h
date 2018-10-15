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

extern "C" NATIVEPIPE_API NamedPipeClient* CreateNamedPipeClient();
extern "C" NATIVEPIPE_API void DestroyNamedPipeClient(NamedPipeClient* client);

extern "C" NATIVEPIPE_API bool isConnected(NamedPipeClient* client);
extern "C" NATIVEPIPE_API int readFrame(NamedPipeClient* client, unsigned char* buffer, int length);
extern "C" NATIVEPIPE_API int writeFrame(NamedPipeClient* client, unsigned char* buffer, int length);
extern "C" NATIVEPIPE_API int open(NamedPipeClient* client, char* pipename);
extern "C" NATIVEPIPE_API void close(NamedPipeClient* client);