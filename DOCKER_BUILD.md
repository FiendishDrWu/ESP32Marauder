# Building ESP32 Marauder with Docker

This guide explains how to build ESP32 Marauder firmware locally using Docker, without needing to push to GitHub.

## Prerequisites

1. **Docker Desktop** (or Docker Engine) installed on your computer
   - Windows: Download from [docker.com](https://www.docker.com/products/docker-desktop)
   - Mac: Download from [docker.com](https://www.docker.com/products/docker-desktop)
   - Linux: Install via your package manager

2. **Git** (to clone/download the repository)

## Quick Start

1. **Make the build script executable** (Linux/Mac):
   chmod +x build.sh
   2. **Build for a specific board**:
   
   ./build.sh v6
      Or on Windows (PowerShell):wershell
   bash build.sh v6
   ## Available Boards (All 20 Supported)

- `flipper` - Flipper Zero WiFi Dev Board
- `multiboardS3` - Flipper Zero Multi Board S3
- `v4` - OG Marauder
- `v6` - Marauder v6 (default)
- `v6_1` - Marauder v6.1
- `kit` - Marauder Kit
- `mini` - Marauder Mini
- `esp32_lddb` - ESP32 LDDB
- `dev_board_pro` - Marauder Dev Board Pro
- `m5stickc` - M5StickC Plus
- `m5stickcp2` - M5StickC Plus 2
- `rev_feather` - ESP32-S2 Reverse Feather
- `v7` - Marauder v7
- `cyd_micro` - Marauder CYD 2432S028
- `cyd_guition` - Marauder CYD 2432S024 GUITION
- `cyd_2usb` - Marauder CYD 2432S028 2 USB
- `cyd_3_5_inch` - Marauder CYD 3.5inch
- `v7_1` - Marauder v7.1
- `m5cardputer` - M5 Cardputer
- `c5` - ESP32-C5-DevKitC-1

## How It Works

1. **First time**: Docker builds an image with all the tools (Arduino CLI, Python, etc.)
2. **Every build**: Docker runs a container that:
   - Downloads all required libraries fresh to a temporary directory (not cached)
   - Configures the build environment
   - Compiles your code in a temporary build directory
   - Copies the compiled `.bin` file to your local filesystem

The `.bin` file will be in: `esp32_marauder/build/[board_name]/`

For example, building for `v6` creates: `esp32_marauder/build/v6/esp32_marauder_v1_9_0_20240101_v6.bin`

## Managing Updates and Cache

### Docker Volumes

The build system uses Docker volumes to cache the Arduino CLI data between builds:
- `marauder_arduino15` - Stores Arduino cores, board definitions, and platform files
- `marauder_arduino_cache` - Stores Arduino CLI cache files

These volumes persist between container runs, so the ESP32 core only needs to be downloaded once. This significantly speeds up subsequent builds.

### When Libraries or Tools Update

**Important**: Libraries are downloaded fresh on every build (to `/tmp` inside the container), so library updates are automatically picked up. However, if you need to update the Docker image itself or clear the Arduino cache:

# Force rebuild the Docker image and clear Arduino cache
./build.sh v6 --rebuildThis will:
- Remove and rebuild the Docker image
- Clear the Arduino CLI cache volumes
- Force a fresh download of the ESP32 core on the next build

Or manually clear volumes:h
docker volume rm marauder_arduino15 marauder_arduino_cache
### What Gets Cached vs. Fresh

- **Cached in Docker image**: Arduino CLI, Python, system packages
- **Cached in Docker volumes**: ESP32 Arduino core, board definitions (persists between builds)
- **Fresh every build**: All libraries (ESP32Ping, AsyncTCP, TFT_eSPI, etc.) - downloaded to `/tmp`
- **Fresh every build**: Your source code (mounted from your local directory)
- **Fresh every build**: Build artifacts (compiled in `/tmp`, then copied to host)

This means:
- ✅ Library updates are automatically used (downloaded fresh each time)
- ✅ Your code changes are immediately reflected
- ✅ ESP32 core is cached (faster builds after first run)
- ⚠️ Tool updates (Arduino CLI, Python packages) require rebuilding the image
- ⚠️ ESP32 core updates require using `--rebuild` to clear the cache

### Updating the Build Version

If you modify the Dockerfile or need to force a complete rebuild, you can increment the `BUILD_VERSION` in the Dockerfile. This helps Docker know when to invalidate its cache.

## Troubleshooting

**"Docker command not found"**
- Make sure Docker Desktop is installed and running
- On Windows, you may need to restart your terminal after installing Docker

**"Permission denied" on build.sh**
- Linux/Mac: Run `chmod +x build.sh`
- Windows: Use `bash build.sh` instead

**Build fails with library errors**
- Make sure you're in the repository root directory
- Try rebuilding the Docker image and clearing cache: `./build.sh v6 --rebuild`

**Build uses old libraries**
- Libraries are downloaded fresh each build, so this shouldn't happen
- If you suspect caching issues, try: `./build.sh v6 --rebuild`

**Build output not found**
- Check `esp32_marauder/build/[board_name]/` directory
- The build script will show error details if the `.bin` file isn't found

**Windows line ending issues**
- The build script handles Windows line endings automatically
- If you encounter issues, ensure Git is configured to handle line endings properly

**Want to add more boards?**
- Edit `build.sh` and add a new case statement following the same pattern

## Advanced Usage

You can also run Docker directly with custom settings:
ash
docker run --rm \
  -v "$(pwd):/workspace" \
  -v marauder_arduino15:/root/.arduino15 \
  -v marauder_arduino_cache:/root/.cache/arduino \
  -e BOARD_FLAG="MARAUDER_V6" \
  -e BOARD_FBQN="esp32:esp32:d32:PartitionScheme=min_spiffs" \
  -e BOARD_FILE_NAME="v6" \
  -e BOARD_TFT="true" \
  -e BOARD_TFT_FILE="User_Setup_og_marauder.h" \
  -e BOARD_BUILD_DIR="d32" \
  -e BOARD_IDF_VER="2.0.11" \
  -e BOARD_NIMBLE_VER="1.3.8" \
  esp32-marauder-builder:latest \
  bash /usr/local/bin/docker-build.sh## Notes

- The first build will take longer (downloading ESP32 core and libraries)
- Subsequent builds are much faster (ESP32 core is cached in Docker volumes)
- Libraries are always downloaded fresh to ensure you get the latest compatible versions
- Your source code is mounted into the container, so changes are reflected immediately
- Build artifacts are compiled in a temporary directory, then copied to your local filesystem
- The build output location is organized by board name: `esp32_marauder/build/[board_name]/`
- Windows line endings are automatically handled by the build script
