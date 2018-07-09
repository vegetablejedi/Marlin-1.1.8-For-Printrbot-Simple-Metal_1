#! /bin/bash
IDE_VERSION=$(xip list ArduinoIde | cut -d/ -f2 | tr '.' '0')

set -e

#
# Assumptions:
#     using a Ubis 13s hotend
#     using a heated bed
#

sed -i -e 's/#define INVERT_E0_DIR false/#define INVERT_E0_DIR true/' Configuration.h

cat > PrintrBotConfig.h <<END
#define ZROD_FOUR_START_8MM 1
#define PULLEY_XY_16T 1
#define EXTRUDER_GEARHEAD 1
#define X_AXIS_STANDARD 1
#define ZROD_SUPER_Z 1
END
make clean
make -j8 -f Makefile V=1 ARDUINO_VERSION=$IDE_VERSION ARDUINO_INSTALL_DIR=/opt/arduino AVR_TOOLS_PATH=/usr/bin/ HARDWARE_MOTHERBOARD=811 NEOPIXEL=1
cp applet/Marlin.hex /tmp/XilkaMarlin.hex

sed -i -e 's/#define INVERT_E0_DIR true/#define INVERT_E0_DIR false/' Configuration.h

