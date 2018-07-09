#! /bin/bash

IDE_VERSION=$(xip list ArduinoIde | cut -d/ -f2 | tr '.' '0')

# turn on XON/XOFF support
sed -i -e 's!//#define RX_BUFFER_SIZE 1024!#define RX_BUFFER_SIZE 1024!' \
	-e 's!//#define SERIAL_XON_XOFF!#define SERIAL_XON_XOFF!' \
		Configuration_adv.h

make -j8 -f Makefile V=1 ARDUINO_VERSION=$IDE_VERSION ARDUINO_INSTALL_DIR=/opt/arduino AVR_TOOLS_PATH=/usr/bin/ HARDWARE_MOTHERBOARD=302 NEOPIXEL=1

# turn off XON/XOFF support
sed -i -e 's!#define RX_BUFFER_SIZE 1024!//#define RX_BUFFER_SIZE 1024!' \
	-e 's!#define SERIAL_XON_XOFF!//#define SERIAL_XON_XOFF!' \
		Configuration_adv.h

