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
#
# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common HavocOS stuff
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from RMX1805 device
$(call inherit-product, device/oppo/RMX1805/device.mk)

# Define first api level
$(call inherit-product, $(SRC_TARGET_DIR)/product/product_launched_with_o_mr1.mk)

PRODUCT_BRAND := oppo
PRODUCT_DEVICE := RMX1805
PRODUCT_MANUFACTURER := oppo
PRODUCT_NAME := lineage_RMX1805
PRODUCT_MODEL := Realme 2/C1

# PRODUCT_GMS_CLIENTID_BASE := android-oppo
TARGET_VENDOR := oppo
TARGET_VENDOR_PRODUCT_NAME := RMX1805

PRODUCT_BUILD_PROP_OVERRIDES += \
    PRODUCT_NAME="RMX1805"

#TARGET_GAPPS_ARCH := arm64
#WITH_GAPPS := true
#CHERISH_BUILD_TYPE := OFFICIAL
#CHERISH_NONGAPPS=true
IS_PHONE := true
#TARGET_INCLUDE_STOCK_ARCORE := false
TARGET_BOOT_ANIMATION_RES := 720
#TARGET_INCLUDE_LIVE_WALLPAPERS := false
TARGET_USES_BLUR := true
TARGET_FACE_UNLOCK_SUPPORTED := true

#PRODUCT_GENERIC_PROPERTIES += \
    #ro.cherish.maintainer=ABHINAV
