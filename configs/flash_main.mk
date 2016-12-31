# Copyright (C) 2017 Flash ROM
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

HOSTNAME := $(shell uname -n)
ifeq ($(HOSTNAME),flashbox)
    PRODUCT_DEFAULT_DEV_CERTIFICATE := .keys/releasekey
endif

# ROM versioning
FLASH_VERSION := $(PLATFORM_VERSION)-$(shell date +%Y%m%d-%H%M)

PRODUCT_PROPERTY_OVERRIDES += \
    ro.flash.version=$(FLASH_VERSION)

# Include overlays
PRODUCT_PACKAGE_OVERLAYS += \
    vendor/flash/overlay/common

# Main Required Packages
PRODUCT_PACKAGES += \
    Launcher3 \
    LiveWallpapersPicker \
    Turbo

# Include explicitly to work around Facelock issues
PRODUCT_PACKAGES += \
    libprotobuf-cpp-full

# Custom Packages
PRODUCT_PACKAGES += \
    ThemeInterfacer \
    OmniJaws \
    OmniStyle \
    OmniSwitch

# Prebuilt applications
PRODUCT_PACKAGES += \
    PixelLauncherPrebuilt \
    LiveWallpapersPicker \
    NexusWallpapersStubPrebuilt \
    WallpaperPickerGooglePrebuilt \
    NexusLauncherPrebuilt \
    WallpapersUsTwo

# wallpaper location prop
PRODUCT_PROPERTY_OVERRIDES += \
    ro.wallpapers_loc_request_suw=true

# live wallpapers arm64 only
ifneq ($(filter angler bullhead marlin sailfish,$(TARGET_DEVICE)),)
    PRODUCT_PACKAGES += \
        WallpapersBReel \
        libgdx.so \
        libgeswallpapers-jni.so \
        libjpeg.so

    PRODUCT_COPY_FILES += \
        vendor/flash/prebuilt/lib64/libgdx.so:system/lib64/libgdx.so \
        vendor/flash/prebuilt/lib64/libgeswallpapers-jni.so:system/lib64/libgeswallpapers-jni.so
endif

# Set Pixel blue light theme on Gboard
PRODUCT_PROPERTY_OVERRIDES += \
    ro.com.google.ime.theme_id=5

# ThemeInterfacer sig check override
# Default value is false
# Setting to true so that my debug APKs get recognized without toggling the
# switch in Advanced Settngs. Plus I don't care about security :P
PRODUCT_PROPERTY_OVERRIDES += \
    ro.interfacer.buildtype.check=true

# Build Substratum unless HAS_SUBSTRATUM is set to false
ifneq ($(HAS_SUBSTRATUM),false)
    PRODUCT_PACKAGES += \
        Substratum
endif

# Only build with Magisk if HAS_ROOT is not equal to false
ifneq ($(HAS_ROOT),false)
    # Magisk Manager
    PRODUCT_PACKAGES += \
        MagiskManager

    # Copy Magisk zip
    PRODUCT_COPY_FILES += \
        vendor/flash/prebuilt/zip/magisk.zip:system/addon.d/magisk.zip
endif

# DU Utils Library
PRODUCT_BOOT_JARS += \
    org.dirtyunicorns.utils

# DU Utils Library
PRODUCT_PACKAGES += \
    org.dirtyunicorns.utils

# Backup Tool and adb network files
PRODUCT_COPY_FILES += \
    vendor/flash/prebuilt/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/flash/prebuilt/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/flash/prebuilt/bin/50-base.sh:system/addon.d/50-base.sh \
    vendor/flash/prebuilt/etc/init.adb_network.rc:root/init.adb_network.rc

# Export optimization flags
O3_OPTS := true
STRICT_ALIASING := true
GRAPHITE_OPTS := true

# Don't compile SystemUITests
EXCLUDE_SYSTEMUI_TESTS := true

# XML packages
PRODUCT_PACKAGES += \
    libtinyxml \
    libxml2

# For stereo widening effect
ifneq ($(TARGET_NO_DSPMANAGER), true)
    PRODUCT_PACKAGES += \
        libcyanogen-dsp \
        audio_effects.conf
endif
