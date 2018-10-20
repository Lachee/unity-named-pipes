# CMakeList.txt : CMake project for NativeNamedPipe, include source and define
# project specific logic here.
#
cmake_minimum_required (VERSION 3.5)

# Add source to this project's executable.
set(BASE_SRC "NativeNamedPipe.cpp" "NativeNamedPipe.h" "connection.h")

# Add Window Def
if(WIN32)	
    add_definitions(-DNATIVEPIPE_WINDOWS)
    set(BASE_SRC ${BASE_SRC} "dllmain.cpp" "connection_win.cpp")
endif(WIN32)

# Add Unix Def
if(UNIX)
    add_definitions(-DNATIVEPIPE_UNIX)
    set(BASE_SRC ${BASE_SRC} "connection_unix.cpp")
endif(UNIX)

add_library(NativeNamedPipe SHARED ${BASE_SRC})