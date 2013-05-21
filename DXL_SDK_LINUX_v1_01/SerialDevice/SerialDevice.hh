#ifndef SERIAL_DEVICE_HH
#define SERIAL_DEVICE_HH

#include <iostream>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <termios.h>
#include <sys/time.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/stat.h>
#include <string.h>


#define MAX_DEVICE_NAME_LENGTH 128
#define DEFAULT_READ_TIMEOUT_US 1000000

//list the io modes here
enum {
	IO_BLOCK_W_TIMEOUT,
	IO_NONBLOCK_POLL_W_DELAY_W_TIMEOUT,
	IO_BLOCK_WO_TIMEOUT,
	IO_NONBLOCK_WO_TIMEOUT,
	IO_BLOCK_W_TIMEOUT_W_TERM_SEQUENCE,
	IO_BLOCK_WO_TIMEOUT_W_TERM_SEQUENCE
};

#define DEFAULT_IO_MODE IO_BLOCK_W_TIMEOUT
#define MAX_NUM_TERM_CHARS 128

#define DEVICE_TYPE_SERIAL 0
#define DEVICE_TYPE_TCP 1

#define DEFAULT_TCP_BUFFER_SIZE 4096
#define DEFAULT_TCP_CONNECT_TIMEOUT_US 500000

class SerialDevice{
	public:

		SerialDevice();
		~SerialDevice();

		int ConnectSerial(const char * device, const int speed=0);
		int Connect(const char * device, const char * speedStr);
		int ConnectTCP(const char * device, const int port, const int buff_size = DEFAULT_TCP_BUFFER_SIZE);
		int Connect(const char * device, const int speed=0);	//connect to the device and set the baud rate
		int Disconnect();										//disconnect from the device
		int SetBaudRate(const int baud);						//set the baud rate

		bool IsConnected();

		int FlushInputBuffer();									//flush input buffer

		int ReadChars(char * data, int byte_count, int timeout_us=DEFAULT_READ_TIMEOUT_US);	//read a number of characters
		int WriteChars(const char * data, int byte_count, int delay_us=0);					//write a number of characters

		int Set_IO_BLOCK_W_TIMEOUT();
		int Set_IO_NONBLOCK_POLL_W_DELAY_W_TIMEOUT(int delay);
		int Set_IO_BLOCK_WO_TIMEOUT();
		int Set_IO_NONBLOCK_WO_TIMEOUT();
		int Set_IO_BLOCK_W_TIMEOUT_W_TERM_SEQUENCE(const char * termSequence, int numTermChars, bool retTermSequence=true);
		int Set_IO_BLOCK_WO_TIMEOUT_W_TERM_SEQUENCE(const char * termSequence, int numTermChars, bool retTermSequence=true);


	private:
		char _device[MAX_DEVICE_NAME_LENGTH];			//devince name
		speed_t _baud;									//baud rate
		int _fd;										//file descriptor
		bool _connected;								//status
		int _block;										//block / non-block IO
		int _port;										//port number for TCP/IP
		int _device_type;								//serial or TCP

		int _ioMode, _delay_us, _numTermChars;
		char _termSequence[MAX_NUM_TERM_CHARS];
		bool _retTermSequence;

		int _SetBlockingIO();							//set blocking IO
		int _SetNonBlockingIO();						//set non-blocking IO
		int _SpeedToBaud(int speed, speed_t & baud);	//convert integer speed to baud rate setting

		struct termios _oldterm,_newterm;				//terminal structs
};

#endif //SERIAL_DEVICE_HH
