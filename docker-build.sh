#!/usr/bin/env bash

set -e  # Exit on any error
strip_crlf() { printf "%s" "$1" | tr -d '\r\n'; }

# Get board configuration from environment variables (passed from build.sh)
# These MUST be set - no defaults that force a specific board
if [ -z "$BOARD_FLAG" ] || [ -z "$BOARD_FBQN" ] || [ -z "$BOARD_FILE_NAME" ]; then
    echo "ERROR: Required environment variables not set!"
    echo "Please use build.sh script or set:"
    echo "  BOARD_FLAG, BOARD_FBQN, BOARD_FILE_NAME"
    echo "  BOARD_TFT, BOARD_TFT_FILE, BOARD_BUILD_DIR"
    echo "  BOARD_IDF_VER, BOARD_NIMBLE_VER"
    exit 1
fi

# Sanitize required vars
BOARD_FLAG="$(strip_crlf "$BOARD_FLAG")"
BOARD_FBQN="$(strip_crlf "$BOARD_FBQN")"
BOARD_FILE_NAME="$(strip_crlf "$BOARD_FILE_NAME")"

# Apply defaults and sanitize optional variables
BOARD_TFT="$(strip_crlf "${BOARD_TFT:-false}")"
BOARD_TFT_FILE="$(strip_crlf "${BOARD_TFT_FILE:-}")"
BOARD_BUILD_DIR="$(strip_crlf "${BOARD_BUILD_DIR:-d32}")"
BOARD_IDF_VER="$(strip_crlf "${BOARD_IDF_VER:-2.0.11}")"
BOARD_NIMBLE_VER="$(strip_crlf "${BOARD_NIMBLE_VER:-1.3.8}")"

echo "=========================================="
echo "Building ESP32 Marauder"
echo "Board Flag: $BOARD_FLAG"
echo "Board FQBN: $BOARD_FBQN"
echo "Output Name: $BOARD_FILE_NAME"
echo "TFT: $BOARD_TFT"
echo "TFT File: $BOARD_TFT_FILE"
echo "Build Dir: $BOARD_BUILD_DIR"
echo "IDF Version: $BOARD_IDF_VER"
echo "NimBLE Version: $BOARD_NIMBLE_VER"
echo "=========================================="

# Install ESP32 core via platform URL (same as GitHub Actions)
echo "Installing ESP32 core v$BOARD_IDF_VER..."
arduino-cli core update-index --additional-urls https://github.com/espressif/arduino-esp32/releases/download/$BOARD_IDF_VER/package_esp32_dev_index.json
arduino-cli core install esp32:esp32@$BOARD_IDF_VER --additional-urls https://github.com/espressif/arduino-esp32/releases/download/$BOARD_IDF_VER/package_esp32_dev_index.json

# Download all required libraries (always fresh - not cached in image)
LIB_ROOT="/tmp/marauder-libs"
rm -rf "$LIB_ROOT"
mkdir -p "$LIB_ROOT"

echo "Downloading libraries..."

# ESP32Ping
git clone --depth 1 --branch 1.6 https://github.com/marian-craciunescu/ESP32Ping.git "$LIB_ROOT/CustomESP32Ping"

# AsyncTCP
git clone --depth 1 --branch v3.4.8 https://github.com/ESP32Async/AsyncTCP.git "$LIB_ROOT/CustomAsyncTCP"

# MicroNMEA
git clone --depth 1 --branch v2.0.6 https://github.com/stevemarple/MicroNMEA.git "$LIB_ROOT/CustomMicroNMEA"

# ESPAsyncWebServer
git clone --depth 1 --branch v3.8.1 https://github.com/ESP32Async/ESPAsyncWebServer.git "$LIB_ROOT/CustomESPAsyncWebServer"

# TFT_eSPI
git clone --depth 1 --branch V2.5.34 https://github.com/Bodmer/TFT_eSPI.git "$LIB_ROOT/CustomTFT_eSPI"

# XPT2046_Touchscreen
git clone --depth 1 --branch v1.4 https://github.com/PaulStoffregen/XPT2046_Touchscreen.git "$LIB_ROOT/CustomXPT2046_Touchscreen"

# lv_arduino
git clone --depth 1 --branch 3.0.0 https://github.com/lvgl/lv_arduino.git "$LIB_ROOT/Customlv_arduino"

# JPEGDecoder
git clone --depth 1 --branch 1.8.0 https://github.com/Bodmer/JPEGDecoder.git "$LIB_ROOT/CustomJPEGDecoder"

# NimBLE-Arduino (version depends on board)
git clone --depth 1 --branch $BOARD_NIMBLE_VER https://github.com/h2zero/NimBLE-Arduino.git "$LIB_ROOT/CustomNimBLE-Arduino"

# Adafruit_NeoPixel
git clone --depth 1 --branch 1.12.0 https://github.com/adafruit/Adafruit_NeoPixel.git "$LIB_ROOT/CustomAdafruit_NeoPixel"

# ArduinoJson
git clone --depth 1 --branch v6.18.2 https://github.com/bblanchon/ArduinoJson.git "$LIB_ROOT/CustomArduinoJson"

# LinkedList
git clone --depth 1 --branch v1.3.3 https://github.com/ivanseidel/LinkedList.git "$LIB_ROOT/CustomLinkedList"

# EspSoftwareSerial
git clone --depth 1 --branch 8.1.0 https://github.com/plerup/espsoftwareserial.git "$LIB_ROOT/CustomEspSoftwareSerial"

# Adafruit_BusIO
git clone --depth 1 --branch 1.15.0 https://github.com/adafruit/Adafruit_BusIO.git "$LIB_ROOT/CustomAdafruit_BusIO"

# Adafruit_MAX1704X
git clone --depth 1 --branch 1.0.2 https://github.com/adafruit/Adafruit_MAX1704X.git "$LIB_ROOT/CustomAdafruit_MAX1704X"

echo "Libraries downloaded successfully!"

# Configure TFT_eSPI
echo "Configuring TFT_eSPI..."
rm -f "$LIB_ROOT/CustomTFT_eSPI/User_Setup_Select.h"
cp User*.h "$LIB_ROOT/CustomTFT_eSPI/" 2>/dev/null || echo "No User_*.h files to copy"

# Configure TFT_eSPI User_Setup_Select.h if needed
if [ "$BOARD_TFT" = "true" ] && [ -n "$BOARD_TFT_FILE" ]; then
    echo "Enabling TFT setup: $BOARD_TFT_FILE"
    if [ -f "$LIB_ROOT/CustomTFT_eSPI/User_Setup_Select.h" ]; then
        sed -i "s|^//#include <$BOARD_TFT_FILE>|#include <$BOARD_TFT_FILE>|" "$LIB_ROOT/CustomTFT_eSPI/User_Setup_Select.h"
    fi
fi

# Modify platform.txt for IDF version
echo "Modifying platform.txt for IDF v$BOARD_IDF_VER..."
if [ "$BOARD_IDF_VER" = "2.0.11" ]; then
    for i in $(find ~/.arduino15/packages/esp32/hardware/esp32/ -name "platform.txt"); do
        sed -i 's/compiler.c.elf.libs.esp32c3=/compiler.c.elf.libs.esp32c3=-zmuldefs /' "$i"
        sed -i 's/compiler.c.elf.libs.esp32s3=/compiler.c.elf.libs.esp32s3=-zmuldefs /' "$i"
        sed -i 's/compiler.c.elf.libs.esp32s2=/compiler.c.elf.libs.esp32s2=-zmuldefs /' "$i"
        sed -i 's/compiler.c.elf.libs.esp32=/compiler.c.elf.libs.esp32=-zmuldefs /' "$i"
    done
elif [ "$BOARD_IDF_VER" = "3.3.4" ]; then
    for i in $(find ~/.arduino15/packages/esp32/hardware/esp32/ -name "platform.txt"); do
        sed -i 's/compiler.c.elf.extra_flags=/compiler.c.elf.extra_flags=-Wl,-zmuldefs /' "$i"
    done
fi

# Build the sketch

HOST_BUILD_DIR="./esp32_marauder/build/$BOARD_FILE_NAME"
TMP_BUILD_DIR="/tmp/marauder-build/$BOARD_FILE_NAME"

# Clean directories so old artifacts don’t linger
rm -rf "$HOST_BUILD_DIR" "$TMP_BUILD_DIR"
mkdir -p "$HOST_BUILD_DIR" "$TMP_BUILD_DIR"

echo "Building sketch..."
arduino-cli compile \
	--fqbn "$BOARD_FBQN" \
	--warnings none \
	--build-property "compiler.cpp.extra_flags=-D$BOARD_FLAG" \
	--build-path "$TMP_BUILD_DIR" \
	--output-dir "$TMP_BUILD_DIR" \
	--export-binaries \
	--library "$LIB_ROOT/CustomESP32Ping" \
	--library "$LIB_ROOT/CustomAsyncTCP" \
	--library "$LIB_ROOT/CustomMicroNMEA" \
	--library "$LIB_ROOT/CustomESPAsyncWebServer" \
	--library "$LIB_ROOT/CustomTFT_eSPI" \
	--library "$LIB_ROOT/CustomXPT2046_Touchscreen" \
	--library "$LIB_ROOT/Customlv_arduino" \
	--library "$LIB_ROOT/CustomJPEGDecoder" \
	--library "$LIB_ROOT/CustomNimBLE-Arduino" \
	--library "$LIB_ROOT/CustomAdafruit_NeoPixel" \
	--library "$LIB_ROOT/CustomArduinoJson" \
	--library "$LIB_ROOT/CustomLinkedList" \
	--library "$LIB_ROOT/CustomEspSoftwareSerial" \
	--library "$LIB_ROOT/CustomAdafruit_BusIO" \
	--library "$LIB_ROOT/CustomAdafruit_MAX1704X" \
	esp32_marauder/esp32_marauder.ino

# Copy exported artifacts back onto the host-mounted folder.
cp -f "$TMP_BUILD_DIR"/* "$HOST_BUILD_DIR"/ 2>/dev/null || true

# Rename output file
VERSION=$(grep '#define MARAUDER_VERSION' ./esp32_marauder/configs.h | sed -E 's/.*"v([^"]+)"/v\1/' | tr '.' '_' | tr -d '\r\n')
DATE=$(date +%Y%m%d)
OUTPUT_BIN=esp32_marauder_${VERSION}_${DATE}_${BOARD_FILE_NAME}.bin

# Find the firmware bin
INPUT_BIN="$(find "$HOST_BUILD_DIR" -maxdepth 1 -type f -name "*.ino.bin" -size +0c | head -n 1)"

if [ -f "$INPUT_BIN" ]; then
    mv "$INPUT_BIN" "$HOST_BUILD_DIR/$OUTPUT_BIN"
    echo "=========================================="
    echo "Build successful!"
    echo "Output: $HOST_BUILD_DIR/$OUTPUT_BIN"
    echo "=========================================="
else
    echo "ERROR: Build output not found at $INPUT_BIN"
    echo "Build directory contents:"
    find "$HOST_BUILD_DIR" -maxdepth 1 -type f -printf '%s %p\n' | sort -n | sed 's|^|  |'
    echo "Temp build directory contents:"
    find "$TMP_BUILD_DIR" -maxdepth 1 -type f -printf '%s %p\n' | sort -n | sed 's|^|  |'
    exit 1
fi


