# unity-named-pipes
A native named pipe wrapper for Unity3D.

[![Build status](https://ci.appveyor.com/api/projects/status/s1qgn7qlrws7ugn3?svg=true)](https://ci.appveyor.com/project/Lachee/unity-named-pipes)


Unity is very special and is unable to use the `NamedPipeClientStream` provided by C# without crashing and dying horribly. Even in the latest versions it strugles with this simple task.

This library is here to resolve that. It utilises a native wrapper (which is run outside of unity apparently) around the pipes for both unix and windows and puts them in a nice streamable class for C# to use.
