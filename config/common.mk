PRODUCT_BRAND ?= CherishOS

ifeq ($(PRODUCT_GMS_CLIENTID_BASE),)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=android-google
else
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.com.google.clientidbase=$(PRODUCT_GMS_CLIENTID_BASE)
endif

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0

PRODUCT_PRODUCT_PROPERTIES += \
    ro.url.legal=http://www.google.com/intl/%s/mobile/android/basic/phone-legal.html \
    ro.url.legal.android_privacy=http://www.google.com/intl/%s/mobile/android/basic/privacy.html \

PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.build.selinux=1 \
    persist.sys.disable_rescue=true

# SetupWizard configuration
PRODUCT_PRODUCT_PROPERTIES += \
    ro.setupwizard.enterprise_mode=1 \
    ro.setupwizard.esim_cid_ignore=00000001 \
    ro.setupwizard.rotation_locked=true \
    setupwizard.feature.baseline_setupwizard_enabled=true \
    setupwizard.feature.day_night_mode_enabled=true \
    setupwizard.feature.portal_notification=true \
    setupwizard.feature.show_pai_screen_in_main_flow.carrier1839=false \
    setupwizard.feature.show_pixel_tos=true \
    setupwizard.feature.show_support_link_in_deferred_setup=false \
    setupwizard.feature.skip_button_use_mobile_data.carrier1839=true \
    setupwizard.theme=glif_v3_light

ifeq ($(TARGET_BUILD_VARIANT),eng)
# Disable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=0
else
# Enable ADB authentication
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += ro.adb.secure=1

# Disable extra StrictMode features on all non-engineering builds
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += persist.sys.strictmode.disable=true
endif

# GBoard
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_b=1

# Enable WiFi Display
PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.wfd.nohdcp=1 \
    persist.debug.wfd.enable=1 \
    persist.sys.wfd.virtual=0

# Blur
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.launcher.blur.appLaunch=false

# Enable one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/cherish/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/cherish/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/cherish/prebuilt/common/bin/50-cherish.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-cherish.sh

ifneq ($(strip $(AB_OTA_PARTITIONS) $(AB_OTA_POSTINSTALL_CONFIG)),)
PRODUCT_COPY_FILES += \
    vendor/cherish/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/cherish/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/cherish/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
ifneq ($(TARGET_BUILD_VARIANT),user)
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.ota.allow_downgrade=true
endif
endif

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# cherish-specific broadcast actions whitelist
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/cherish-sysconfig.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/cherish-sysconfig.xml

# Copy all cherish-specific init rc files
$(foreach f,$(wildcard vendor/cherish/prebuilt/common/etc/init/*.rc),\
	$(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Font service Permissions
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/privapp-permissions-cherish-system_ext.xml:$(TARGET_COPY_OUT_SYSTEM_EXT)/etc/permissions/privapp-permissions-cherish-system_ext.xml \

# Enable Android Beam on all targets
PRODUCT_COPY_FILES += \
    vendor/cherish/config/permissions/android.software.nfc.beam.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.nfc.beam.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Log privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=log

# Include AOSP audio files
include vendor/cherish/config/aosp_audio.mk

# Include cherish audio files
include vendor/cherish/config/cherish_audio.mk

# Include CherishOS Themes Styles
#include vendor/themes/themes.mk

# Pixel customization
TARGET_SUPPORTS_GOOGLE_RECORDER ?= true
TARGET_INCLUDE_STOCK_ARCORE ?= true
TARGET_INCLUDE_LIVE_WALLPAPERS ?= true
TARGET_SUPPORTS_QUICK_TAP ?= false
ifeq ($(TARGET_INCLUDE_LIVE_WALLPAPERS),true)
PRODUCT_PACKAGES += \
    PixelLiveWallpapersOverlay
endif

# Plugins
#include packages/apps/PotatoPlugins/plugins.mk

# TouchGestures
#PRODUCT_PACKAGES += \
    TouchGestures

# Packages
#PRODUCT_PACKAGES += \
    StatusBarLyricExt \
    StitchImage \
    StitchImageService \
    OPWeather

#OmniJaws
#PRODUCT_PACKAGES += \
    OmniJaws \
    WeatherIcons

#OmniStyle
#PRODUCT_PACKAGES += \
    OmniStyle

# Cutout control overlays
PRODUCT_PACKAGES += \
    HideCutout \
    StatusBarStock

# Bootanimation
ifeq ($(TARGET_BOOT_ANIMATION_RES),1080)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),1440)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1440.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else ifeq ($(TARGET_BOOT_ANIMATION_RES),720)
     PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_720.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
else
    ifeq ($(TARGET_BOOT_ANIMATION_RES),)
        $(warning "CherishStyle: TARGET_BOOT_ANIMATION_RES is undefined, assuming 1080p")
    else
        $(warning "CherishStyle: Current bootanimation res is not supported, forcing 1080p")
    endif
    PRODUCT_COPY_FILES += vendor/cherish/bootanimation/bootanimation_1080.zip:$(TARGET_COPY_OUT_PRODUCT)/media/bootanimation.zip
endif

# Versioning
include vendor/cherish/config/main_version.mk

# Do not include art debug targets
PRODUCT_ART_TARGET_INCLUDE_DEBUG_BUILD := false

# Strip the local variable table and the local variable type table to reduce
# the size of the system image. This has no bearing on stack traces, but will
# leave less information available via JDWP.
PRODUCT_MINIMIZE_JAVA_DEBUG_INFO := true

# Disable vendor restrictions
PRODUCT_RESTRICT_VENDOR_FILES := false

# Bootanimation
TARGET_SCREEN_WIDTH ?= 1080
TARGET_SCREEN_HEIGHT ?= 1920

# Themes
PRODUCT_PACKAGES += \
    ThemePicker

# Config
PRODUCT_PACKAGES += \
    SimpleDeviceConfig

# Packages
PRODUCT_PACKAGES += \
    Seedvault 

# Extra tools in cherish
PRODUCT_PACKAGES += \
    7z \
    bash \
    curl \
    getcap \
    htop \
    lib7z \
    libsepol \
    nano \
    pigz \
    setcap \
    unrar \
    vim \
    wget \
    zip

# Filesystems tools
PRODUCT_PACKAGES += \
    fsck.ntfs \
    mke2fs \
    mkfs.ntfs \
    mount.ntfs

# Openssh
PRODUCT_PACKAGES += \
    scp \
    sftp \
    ssh \
    sshd \
    sshd_config \
    ssh-keygen \
    start-ssh

# rsync
PRODUCT_PACKAGES += \
    rsync

# Storage manager
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.storage_manager.enabled=true

# These packages are excluded from user builds
PRODUCT_PACKAGES_DEBUG += \
    procmem

# Root
PRODUCT_PACKAGES += \
    adb_root
ifneq ($(TARGET_BUILD_VARIANT),user)
ifeq ($(WITH_SU),true)
PRODUCT_PACKAGES += \
    su
endif
endif

# Gboard side padding
PRODUCT_PRODUCT_PROPERTIES += \
    ro.com.google.ime.kb_pad_port_l=4 \
    ro.com.google.ime.kb_pad_port_r=4 \
    ro.com.google.ime.kb_pad_land_l=64 \
    ro.com.google.ime.kb_pad_land_r=64 

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI 

# Charger
PRODUCT_PACKAGES += \
    charger_res_images \
    product_charger_res_images

# Face Unlock
TARGET_FACE_UNLOCK_SUPPORTED ?= true
ifeq ($(TARGET_FACE_UNLOCK_SUPPORTED),true)
PRODUCT_PACKAGES += \
    FaceUnlockService
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.face_unlock_service.enabled=$(TARGET_FACE_UNLOCK_SUPPORTED)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.biometrics.face.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.hardware.biometrics.face.xml
endif

# FOD Animations
ifeq ($(TARGET_WANTS_FOD_ANIMATIONS),true)
PRODUCT_PACKAGES += \
    FodAnimationResources
endif

# Enable support of one-handed mode
PRODUCT_PRODUCT_PROPERTIES += \
    ro.support_one_handed_mode=true

# IORap
PRODUCT_PROPERTY_OVERRIDES += \
    iorapd.perfetto.enable=true \
    iorapd.readahead.enable=true \
    persist.device_config.runtime_native_boot.iorap_perfetto_enable=true \
    persist.device_config.runtime_native_boot.iorap_readahead_enable=true \
    ro.iorapd.enable=true

# Google Apps
include vendor/cherish/config/gapps.mk

# OTA
$(call inherit-product, vendor/cherish/config/ota.mk)

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/cherish/overlay
DEVICE_PACKAGE_OVERLAYS += vendor/cherish/overlay/common
-include $(WORKSPACE)/build_env/image-auto-bits.mk
-include vendor/cherish/config/partner_gms.mk
