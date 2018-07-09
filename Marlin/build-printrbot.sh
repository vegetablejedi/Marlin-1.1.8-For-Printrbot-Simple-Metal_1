#! /bin/bash
IDE_VERSION=$(xip list ArduinoIde | cut -d/ -f2 | tr '.' '0')

set -e

#
# Assumptions:
#     using a Ubis 13s hotend
#     using a heated bed
#

mkdir -p /var/tmp/PrintrBotFirmware

for extruder in EXTRUDER_OLD EXTRUDER_GEARHEAD; do
	extrudername=extold
	[[ $extruder != EXTRUDER_GEARHEAD ]] || extrudername=extgh
	for zrod in ZROD_STANDARD ZROD_SUPER_Z; do
		zrodname=origz
		[[ $zrod != ZROD_SUPER_Z ]] || zrodname=superz
		for axis in X_AXIS_STANDARD X_AXIS_UPGRADE; do
			axisname=origx
			[[ $axis != X_AXIS_UPGRADE ]] || axisname=xupg
			for rod in ZROD_QUARTER ZROD_FOUR_START_8MM; do
				rodname=quarter
				[[ $rod != ZROD_FOUR_START_8MM ]] || rodname=fs8
				for pulley in PULLEY_XY_20T PULLEY_XY_16T; do
					pulleyname=20t
					[[ $pulley != PULLEY_XY_16T ]] || pulleyname=16t
					cat > PrintrBotConfig.h <<END
#define $rod 1
#define $pulley 1
#define $extruder 1
#define $axis 1
#define $zrod 1
END
					make clean
					make -j8 -f Makefile V=1 ARDUINO_VERSION=$IDE_VERSION ARDUINO_INSTALL_DIR=/opt/arduino AVR_TOOLS_PATH=/usr/bin/ HARDWARE_MOTHERBOARD=811 NEOPIXEL=1
					cp applet/Marlin.hex /var/tmp/PrintrBotFirmware/$extrudername-$zrodname-$axisname-$rodname-$pulleyname.hex
				done
			done
		done
	done
done

cp LEGEND.txt /var/tmp/PrintrBotFirmware

