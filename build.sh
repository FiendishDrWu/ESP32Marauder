#!/usr/bin/env bash
set -e

# Simple script to build ESP32 Marauder using Docker
# Usage: ./build.sh [board_name]
# Example: ./build.sh flipper

# Default board (Marauder v6)
BOARD="${1:-v6}"

# Board configurations (matching GitHub Actions - ALL 20 boards)
case "$BOARD" in
    flipper)
        export BOARD_FLAG="MARAUDER_FLIPPER"
        export BOARD_FBQN="esp32:esp32:esp32s2:PartitionScheme=min_spiffs,FlashSize=4M,PSRAM=enabled"
        export BOARD_FILE_NAME="flipper"
        export BOARD_TFT="false"
        export BOARD_TFT_FILE=""
        export BOARD_BUILD_DIR="esp32s2"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    multiboardS3)
        export BOARD_FLAG="MARAUDER_MULTIBOARD_S3"
        export BOARD_FBQN="esp32:esp32:esp32s3:PartitionScheme=min_spiffs,FlashSize=4M"
        export BOARD_FILE_NAME="multiboardS3"
        export BOARD_TFT="false"
        export BOARD_TFT_FILE=""
        export BOARD_BUILD_DIR="esp32s3"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    v4|old_hardware)
        export BOARD_FLAG="MARAUDER_V4"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="old_hardware"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_og_marauder.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    v6)
        export BOARD_FLAG="MARAUDER_V6"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="v6"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_og_marauder.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    v6_1)
        export BOARD_FLAG="MARAUDER_V6_1"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="v6_1"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_og_marauder.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    kit)
        export BOARD_FLAG="MARAUDER_KIT"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="kit"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_og_marauder.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    mini)
        export BOARD_FLAG="MARAUDER_MINI"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="mini"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_marauder_mini.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    esp32_lddb|lddb)
        export BOARD_FLAG="ESP32_LDDB"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="esp32_lddb"
        export BOARD_TFT="false"
        export BOARD_TFT_FILE=""
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    dev_board_pro|marauder_dev_board_pro)
        export BOARD_FLAG="MARAUDER_DEV_BOARD_PRO"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="marauder_dev_board_pro"
        export BOARD_TFT="false"
        export BOARD_TFT_FILE=""
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    m5stickc|m5stickc_plus)
        export BOARD_FLAG="MARAUDER_M5STICKC"
        export BOARD_FBQN="esp32:esp32:m5stick-c:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="m5stickc_plus"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_marauder_m5stickc.h"
        export BOARD_BUILD_DIR="m5stick-c"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    m5stickcp2|m5stickc_plus2)
        export BOARD_FLAG="MARAUDER_M5STICKCP2"
        export BOARD_FBQN="esp32:esp32:m5stick-c:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="m5stickc_plus2"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_marauder_m5stickcp2.h"
        export BOARD_BUILD_DIR="m5stick-c"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    rev_feather)
        export BOARD_FLAG="MARAUDER_REV_FEATHER"
        export BOARD_FBQN="esp32:esp32:esp32s2:PartitionScheme=min_spiffs,FlashSize=4M,PSRAM=enabled"
        export BOARD_FILE_NAME="rev_feather"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_marauder_rev_feather.h"
        export BOARD_BUILD_DIR="esp32s2"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    v7|marauder_v7)
        export BOARD_FLAG="MARAUDER_V7"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="marauder_v7"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_dual_nrf24.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    cyd_micro|cyd_2432S028)
        export BOARD_FLAG="MARAUDER_CYD_MICRO"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="cyd_2432S028"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_cyd_micro.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    cyd_guition|cyd_2432S024_guition)
        export BOARD_FLAG="MARAUDER_CYD_GUITION"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="cyd_2432S024_guition"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_cyd_guition.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    cyd_2usb|cyd_2432S028_2usb)
        export BOARD_FLAG="MARAUDER_CYD_2USB"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="cyd_2432S028_2usb"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_cyd_2usb.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    cyd_3_5_inch|cyd_3_5inch)
        export BOARD_FLAG="MARAUDER_CYD_3_5_INCH"
        export BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs"
        export BOARD_FILE_NAME="cyd_3_5_inch"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_cyd_3_5_inch.h"
        export BOARD_BUILD_DIR="d32"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    v7_1|marauder_v7_1)
        export BOARD_FLAG="MARAUDER_V7_1"
        export BOARD_FBQN="esp32:esp32:dfrobot_firebeetle2_esp32e:FlashSize=16M,PartitionScheme=min_spiffs,PSRAM=enabled"
        export BOARD_FILE_NAME="marauder_v7_1"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_dual_nrf24.h"
        export BOARD_BUILD_DIR="dfrobot_firebeetle2_esp32e"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    m5cardputer|cardputer)
        export BOARD_FLAG="MARAUDER_CARDPUTER"
        export BOARD_FBQN="esp32:esp32:esp32s3:PartitionScheme=min_spiffs,FlashSize=8M,PSRAM=disabled"
        export BOARD_FILE_NAME="m5cardputer"
        export BOARD_TFT="true"
        export BOARD_TFT_FILE="User_Setup_marauder_m5cardputer.h"
        export BOARD_BUILD_DIR="esp32s3"
        export BOARD_IDF_VER="2.0.11"
        export BOARD_NIMBLE_VER="1.3.8"
        ;;
    c5|esp32c5devkitc1|esp32c5)
        export BOARD_FLAG="MARAUDER_C5"
        export BOARD_FBQN="esp32:esp32:esp32c5:FlashSize=8M,PartitionScheme=min_spiffs,PSRAM=enabled"
        export BOARD_FILE_NAME="esp32c5devkitc1"
        export BOARD_TFT="false"
        export BOARD_TFT_FILE=""
        export BOARD_BUILD_DIR="esp32c5"
        export BOARD_IDF_VER="3.3.4"
        export BOARD_NIMBLE_VER="2.3.6"
        ;;
    *)
        echo "Unknown board: $BOARD"
        echo ""
        echo "Available boards (20 total):"
        echo "  flipper          - Flipper Zero WiFi Dev Board"
        echo "  multiboardS3     - Flipper Zero Multi Board S3"
        echo "  v4               - OG Marauder"
        echo "  v6               - Marauder v6 (default)"
        echo "  v6_1             - Marauder v6.1"
        echo "  kit              - Marauder Kit"
        echo "  mini             - Marauder Mini"
        echo "  esp32_lddb       - ESP32 LDDB"
        echo "  dev_board_pro    - Marauder Dev Board Pro"
        echo "  m5stickc         - M5StickC Plus"
        echo "  m5stickcp2       - M5StickC Plus 2"
        echo "  rev_feather      - ESP32-S2 Reverse Feather"
        echo "  v7               - Marauder v7"
        echo "  cyd_micro        - Marauder CYD 2432S028"
        echo "  cyd_guition      - Marauder CYD 2432S024 GUITION"
        echo "  cyd_2usb         - Marauder CYD 2432S028 2 USB"
        echo "  cyd_3_5_inch     - Marauder CYD 3.5inch"
        echo "  v7_1             - Marauder v7.1"
        echo "  m5cardputer      - M5 Cardputer"
        echo "  c5               - ESP32-C5-DevKitC-1"
        echo ""
        echo "Usage: ./build.sh [board_name]"
        exit 1
        ;;
esac

# Build Docker image if it doesn't exist or if --rebuild flag is set
REBUILD=false
if [ "$2" = "--rebuild" ] || [ "$1" = "--rebuild" ]; then
    REBUILD=true
    echo "Forcing full rebuild (image + Arduino core cache)..."

    # Remove Docker image
    docker rmi esp32-marauder-builder:latest 2>/dev/null || true

    # Remove Arduino CLI cache volumes
    docker volume rm marauder_arduino15 marauder_arduino_cache 2>/dev/null || true
fi


if ! docker image inspect esp32-marauder-builder:latest >/dev/null 2>&1 || [ "$REBUILD" = true ]; then
    echo "Building Docker image (this only happens once or when --rebuild is used)..."
    docker build --pull --no-cache -t esp32-marauder-builder:latest .
fi

# Run the build
echo "Building for board: $BOARD"
docker run --rm \
    -v "$(pwd):/workspace" \
    -v marauder_arduino15:/root/.arduino15 \
    -v marauder_arduino_cache:/root/.cache/arduino \
    -e BOARD_FLAG \
    -e BOARD_FBQN \
    -e BOARD_FILE_NAME \
    -e BOARD_TFT \
    -e BOARD_TFT_FILE \
    -e BOARD_BUILD_DIR \
    -e BOARD_IDF_VER \
    -e BOARD_NIMBLE_VER \
    esp32-marauder-builder:latest \
    bash /usr/local/bin/docker-build.sh

echo ""
echo "Build complete! Check the esp32_marauder/build/ directory for your .bin file"


