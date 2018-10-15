class BaseNamedPipeClient
{
public:
	static BaseNamedPipeClient* create();

	bool isConnected();
	int readFrame(unsigned char* buffer, int length);
	int writeFrame(unsigned char* buffer, int length);
	
	int open(char* pipename);
	void close(void);
};