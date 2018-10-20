class BaseNamedPipeClient
{
public:
	static BaseNamedPipeClient* create();

	virtual ~BaseNamedPipeClient() = default;

	virtual bool isConnected() = 0;
	virtual int readFrame(unsigned char* buffer, int length) = 0;
	virtual int writeFrame(unsigned char* buffer, int length) = 0;

	virtual int open(char* pipename) = 0;
	virtual void close(void) = 0;
};