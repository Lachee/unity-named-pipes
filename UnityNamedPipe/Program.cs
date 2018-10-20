using System;
using System.IO;
using System.IO.Pipes;
using System.Runtime.InteropServices;
using System.Threading;
using System.Threading.Tasks;

namespace Lachee.IO
{
    class Program
    {
        const string LIBRARY_NAME = "NativeNamedPipe";
        const string PIPE_NAME = "testpipe";
        static CancellationTokenSource source;

        [DllImport(LIBRARY_NAME, EntryPoint = "test", CallingConvention = CallingConvention.Cdecl)]
        static extern bool test(int a, int b, IntPtr @out);

        static bool ValidateDll()
        {
            IntPtr ptr = Marshal.AllocHGlobal(sizeof(int));
            try
            {
                bool state = test(-10, 10, ptr);
                return state && Marshal.ReadInt32(ptr) == 0;
            }
            catch (Exception e)
            {
                Console.WriteLine("Failed DLL Test!");
                Console.WriteLine(e.Message);
                return false;
            }
            finally
            {
                Marshal.FreeHGlobal(ptr);
            }
        }
        static void TestPipe()
        {
            //using (var client = new System.IO.Pipes.NamedPipeClientStream(".", PIPE_NAME))
            using (var client = new Lachee.IO.NamedPipeClientStream(".", PIPE_NAME))
            {
                try
                {
                    Console.WriteLine("CLIENT: Connecting...");
                    client.Connect();

                    string message = "Hello World!";

                    Console.WriteLine("CLIENT: Sending '{0}'...", message);
                    byte[] msgbytes = System.Text.Encoding.ASCII.GetBytes(message);
                    client.Write(msgbytes, 0, msgbytes.Length);

                    Console.WriteLine("CLIENT: Sent. Reading message...");
                    message = "";
                    int bytesRead = 0;
                    byte[] buffer = new byte[2048];
                    while ((bytesRead = client.Read(buffer, 0, buffer.Length)) == 0)
                    {
                        Console.Write(".");
                        Thread.Sleep(1);
                    }
                    Console.WriteLine();
                    message = System.Text.Encoding.ASCII.GetString(buffer, 0, bytesRead);
#if USEMANAGED
                    byte[] buffer = new byte[2048];
                    int bytesRead = 0;
                    while ((bytesRead = client.Read(buffer, 0, buffer.Length)) > 0)
                    {
                        Console.WriteLine("CLIENT: Read {0} bytes", bytesRead);
                        string msg = System.Text.Encoding.ASCII.GetString(buffer, 0, bytesRead);
                        message += msg;
                    }
#endif

                    Console.WriteLine("CLIENT: Server said '{0}'", message);

                }
                catch (Exception e)
                {
                    Console.WriteLine("Failed pipe test: {0}", e.Message);
                }
            }
        }

        static void Main(string[] args)
        {
            if (!ValidateDll())
                return;

            Console.WriteLine("Starting Server...");
            source = new CancellationTokenSource();
            Task.Factory.StartNew(async () => await ServerIO(source.Token), source.Token);


            Console.WriteLine("How many times do you wish the test to be run?");
            string attempts = Console.ReadLine();
            if (string.IsNullOrWhiteSpace(attempts)) attempts = "1";

            int iterations = int.Parse(attempts);
            for (int i = 0; i < iterations; i++)
            {
                Console.WriteLine("Testing Pipe #{0}....", i);
                TestPipe();
            }

            Console.WriteLine("Canceling Token...");
            source.Cancel();
            source.Dispose();

            Console.WriteLine("Press any key to exit.");
            Console.ReadKey(true);
        }

        static async Task ServerIO(CancellationToken token)
        {
            using(var server = new NamedPipeServerStream(PIPE_NAME, PipeDirection.InOut))
            {
                while (!token.IsCancellationRequested)
                {
                    Console.WriteLine("SERVER: Waiting for connection...");
                    string message = "";
                    await server.WaitForConnectionAsync(token);

                    Console.WriteLine("SERVER: Connection established. Reading message...");

                    byte[] buffer = new byte[2048];
                    int bytesRead = await server.ReadAsync(buffer, 0, buffer.Length);

                    Console.WriteLine("SERVER: Read {0} bytes", bytesRead);
                    string msg = System.Text.Encoding.ASCII.GetString(buffer, 0, bytesRead);
                    message += msg;


                    //Update the message
                    char[] chars = message.ToCharArray();
                    Array.Reverse(chars);
                    message = new string(chars);

                    //Send it back
                    Console.WriteLine("SERVER: Message read. Returning message '{0}'...", message);
                    byte[] msgbytes = System.Text.Encoding.ASCII.GetBytes(message);
                    await server.WriteAsync(msgbytes, 0, msgbytes.Length);

                    Console.WriteLine("SERVER: Disconnecting...");
                    server.Disconnect();
                }
            }
        }
    }
}
