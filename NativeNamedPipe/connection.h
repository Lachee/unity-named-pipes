

struct NamedPipeClient
{ 
public: 
	NamedPipeClient();

	bool isConnected();
	int readFrame(unsigned char* buffer, int length);
	int writeFrame(unsigned char* buffer, int length);

	int open(char* pipename);
	void close(void);
	
private: 
	void* handle;
	bool isOpened;
};