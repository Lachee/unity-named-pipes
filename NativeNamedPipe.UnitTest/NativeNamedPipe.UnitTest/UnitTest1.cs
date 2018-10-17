using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Threading;
using System.Threading.Tasks;
using System.Linq;

namespace NativeNamedPipe.UnitTest
{
    [TestClass]
    public class UnitTest1
    {
        private const string PIPE_NAME = "unittest-0";
        private static bool runserver;
        private static CancellationTokenSource cancellationTokenSource;
        private static System.IO.Pipes.NamedPipeServerStream server;
        private static Thread thread;

        [ClassInitialize]
        public static void ClassInitialization(TestContext context)
        {
            //Copy the library from the asset folder
            foreach (string path in System.IO.Directory.EnumerateFiles("../../../../../artifacts/", "*"))
                System.IO.File.Copy(path, System.IO.Path.GetFileName(path), true);

            cancellationTokenSource = new CancellationTokenSource();
            Task.Run(() =>
            {
                server = new System.IO.Pipes.NamedPipeServerStream(PIPE_NAME, System.IO.Pipes.PipeDirection.InOut);
                runserver = true;

                try
                {
                    while (runserver)
                    {
                        server.WaitForConnection();

                        int bytesRead = 0;
                        byte[] buffer = new byte[2048];
                        while ((bytesRead = server.Read(buffer, 0, buffer.Length)) > 0)
                        {
                            server.Write(buffer, 0, bytesRead);
                        }

                        server.Disconnect();
                    }
                }
                finally
                {
                    if (server != null)
                    {
                        server.Dispose();
                        server = null;
                    }
                }
            }, cancellationTokenSource.Token);            
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            runserver = false;
            if (cancellationTokenSource != null)
            {
                cancellationTokenSource.Cancel();
                cancellationTokenSource.Dispose();
            }
        }

        [System.Runtime.InteropServices.DllImport("NativeNamedPipe", EntryPoint = "isConnected")]
        private static extern bool IsConnected(System.IntPtr ptr);

        [TestMethod]
        public void TestMethod1()
        {
            bool res = IsConnected(System.IntPtr.Zero);
            Assert.IsFalse(res);
        }
    }
}
