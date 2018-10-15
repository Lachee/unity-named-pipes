using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Lachee.IO.Exceptions
{
    public class NamedPipeConnectionException : Exception
    {
        internal NamedPipeConnectionException(string message) : base(message) { }
    }
}
