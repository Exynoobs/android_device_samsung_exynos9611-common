#
# Copyright (C) 2020 The LineageOS Project
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

BUILD_TOP := $(shell pwd)

PLATFORM_PATH := device/samsung/exynos9611-common

### BOARD
TARGET_BOARD_PLATFORM := universal9611
TARGET_SLSI_VARIANT := bsp
TARGET_SOC := exynos9611
TARGET_BOOTLOADER_BOARD_NAME := exynos9611
TARGET_BOARD_PLATFORM_GPU := mali-g72

# build/make/core/Makefile
TARGET_NO_BOOTLOADER := true

# Enable hardware/samsung
BOARD_VENDOR := samsung

### PROCESSOR
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := cortex-a53
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

### RELASETOOLS
TARGET_RELEASETOOLS_EXTENSIONS := $(PLATFORM_PATH)/releasetools

### RENDERSCRIPT
OVERRIDE_RS_DRIVER := libRSDriverArm.so

### HARDWARE INCLUDE
TARGET_SPECIFIC_HEADER_PATH := $(PLATFORM_PATH)/hardware/include

### KERNEL
TARGET_KERNEL_SOURCE = kernel/samsung/exynos9611/
TARGET_KERNEL_CLANG_COMPILE := true

BOARD_CUSTOM_BOOTIMG         := true
BOARD_CUSTOM_BOOTIMG_MK      := $(PLATFORM_PATH)/kernel/mkbootimg.mk
BOARD_KERNEL_BASE            := 0x10000000
# See `bbootimg -i boot.img`
BOARD_KERNEL_PAGESIZE        := 2048
# Looks like Samsung's sboot doesn't suppored a zipped Kernel
BOARD_KERNEL_IMAGE_NAME      := Image
# Build a device tree overlay
BOARD_KERNEL_SEPARATED_DTBO  := true
BOARD_DTBO_CFG               := $(PLATFORM_PATH)/kernel/$(TARGET_DEVICE).cfg

# See `bbootimg -i boot.img`
BOARD_DTB_OFFSET              := 0x00000000
BOARD_KERNEL_OFFSET          := 0x00008000
BOARD_KERNEL_RAMDISK_OFFSET  := 0x01000000
BOARD_KERNEL_TAGS_OFFSET     := 0x00000100

# See `bbootimg -i boot.img`
BOARD_BOOT_HEADER_VERSION    := 2
BOARD_BOOT_HEADER_NAME       := SRPSL20A002KU

BOARD_MKBOOTIMG_ARGS := --dtb_offset $(BOARD_DTB_OFFSET)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_KERNEL_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --board $(BOARD_BOOT_HEADER_NAME)

### BINDER
# build/make/core/config.mk
TARGET_USES_64_BIT_BINDER := true

### VNDK
BOARD_VNDK_VERSION := current

### SYSTEM
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
# system/core and build/make
AB_OTA_UPDATER := false

BOARD_ROOT_EXTRA_FOLDERS := \
    efs \
    dqmdbg \
    omr \
    prism \
    optics

# /metadata
BOARD_USES_METADATA_PARTITION := true

### VENDOR
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

### ODM
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_ODM := odm

### PRODUCT
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_PRODUCT := product

### CACHE
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4

### USERDATA
TARGET_USERIMAGES_USE_EXT4 := true

### AUDIO
USE_XML_AUDIO_POLICY_CONF := 1

### CHARGER
BOARD_CHARGER_ENABLE_SUSPEND := true

### BLUETOOTH
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(PLATFORM_PATH)/hardware/bluetooth
BOARD_CUSTOM_BT_CONFIG := $(PLATFORM_PATH)/hardware/bluetooth/libbt_vndcfg.txt

### DISPLAY
TARGET_SCREEN_DENSITY := 420

### GRAPHICS
# hardware/interfaces/configstore/1.1/default/surfaceflinger.mk
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3

### HIDL
DEVICE_MANIFEST_FILE += $(PLATFORM_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(PLATFORM_PATH)/compatibility_matrix.xml

### KEYMASTER
TARGET_KEYMASTER_VARIANT := samsung

### SHIMS
TARGET_LD_SHIM_LIBS += \
    /vendor/lib/vndk/libstagefright_omx_utils.so|libshim_stagefright_foundation.so \
    /vendor/lib/libsensorlistener.so|libshim_sensorndkbridge.so

### SEPOLICY
include device/lineage/sepolicy/exynos/sepolicy.mk

BOARD_SEPOLICY_TEE_FLAVOR := teegris
include device/samsung_slsi/sepolicy/sepolicy.mk

BOARD_SEPOLICY_DIRS += $(PLATFORM_PATH)/sepolicy/vendor

### PARTITIONS
BOARD_FLASH_BLOCK_SIZE := 4096
BOARD_BOOTIMAGE_PARTITION_SIZE := 61865984
BOARD_CACHEIMAGE_PARTITION_SIZE := 209715200
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 71106560
BOARD_DTBOIMG_PARTITION_SIZE := 8388608

# Dynamic Partitions
BOARD_SUPER_PARTITION_SIZE := 6585057280
BOARD_SUPER_PARTITION_GROUPS := samsung_dynamic_partitions
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_SIZE := 6580862976
BOARD_SAMSUNG_DYNAMIC_PARTITIONS_PARTITION_LIST := \
    system \
    vendor \
    product \
    odm

BOARD_PRODUCTIMAGE_PARTITION_RESERVED_SIZE := 1887436800
BOARD_SYSTEMIMAGE_PARTITION_RESERVED_SIZE := 1887436800

### PROPERTIES
TARGET_SYSTEM_PROP += $(PLATFORM_PATH)/system.prop
TARGET_PRODUCT_PROP += $(PLATFORM_PATH)/product.prop
TARGET_VENDOR_PROP += $(PLATFORM_PATH)/vendor.prop

### ANDROID VERIFIED BOOT
BOARD_AVB_ENABLE := true
ifeq ($(BOARD_AVB_ENABLE), true)
ifneq ($(LINEAGE_AVB_KEY_PATH),)
BOARD_AVB_KEY_PATH := $(LINEAGE_AVB_KEY_PATH)
BOARD_AVB_ALGORITHM := SHA256_RSA2048
endif
BOARD_AVB_ROLLBACK_INDEX := $(PLATFORM_SECURITY_PATCH_TIMESTAMP)
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flag 2
endif # BOARD_AVB_ENABLE

### WIFI
BOARD_WLAN_DEVICE                := slsi
BOARD_WPA_SUPPLICANT_DRIVER      := NL80211
BOARD_HOSTAPD_DRIVER             := NL80211
WIFI_DRIVER_FW_PATH_PARAM        := /sys/module/scsc_mx/parameters/base_dir

PRODUCT_CFI_INCLUDE_PATHS        += hardware/samsung_slsi/scsc_wifibt/wpa_supplicant_lib

WIFI_HIDL_FEATURE_DUAL_INTERFACE := true

# hardware/broadcom/wlan/bcmdhd/config/Android.mk
# external/wpa_supplicant_8/Android.mk
WPA_SUPPLICANT_VERSION           := VER_0_8_X

# frameworks/opt/net/wifi/libwifi_hal/Android.mk
# hardware/samsung/wifiloader/Android.mk
WIFI_DRIVER_FW_PATH_PARAM        := "/sys/module/bcmdhd/parameters/firmware_path"

### RIL
# Use stock RIL stack
ENABLE_VENDOR_RIL_SERVICE := true

### ALLOW VENDOR FILE OVERRIDE
BUILD_BROKEN_DUP_RULES := true

### RECOVERY
BOARD_HAS_DOWNLOAD_MODE := true
TARGET_RECOVERY_PIXEL_FORMAT := "ABGR_8888"
BOARD_INCLUDE_RECOVERY_DTBO := true
TARGET_RECOVERY_FSTAB := $(PLATFORM_PATH)/recovery/etc/recovery.fstab
