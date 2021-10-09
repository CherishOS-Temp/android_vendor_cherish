# Gapps
ifeq ($(WITH_GMS),true)
$(call inherit-product, vendor/gms/gms_full.mk)

# Common Overlay
DEVICE_PACKAGE_OVERLAYS += \
    vendor/cherish/overlay-gapps/common

# Exclude RRO Enforcement
PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS +=  \
    vendor/cherish/overlay-gapps

$(call inherit-product, vendor/cherish/config/rro_overlays.mk)
endif
