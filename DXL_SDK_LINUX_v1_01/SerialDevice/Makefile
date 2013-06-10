OBJS		= SerialDevice.o
SRCS		= $(OBJS:.o=.cc)
MEXEXT		= $(shell mexext)
INCLUDEDIRS	= -I./
CFLAGS		= $(INCLUDEDIRS) -Wall -O2

CC			= g++
	
%.o: %.cc
	$(CC) -c -fPIC $^ $(CFLAGS)

SerialDeviceAPI.$(MEXEXT): SerialDeviceAPI.cc SerialDevice.o
	mex -O $^  $(INCLUDEDIRS)
	
clean:
	rm -f $(OBJS) SerialDeviceAPI.$(MEXEXT)
	@echo "file deleted."
