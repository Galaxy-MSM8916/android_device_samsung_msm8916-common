# Inherit common Android Go configurations
$(call inherit-product, build/target/product/go_defaults.mk)
$(call inherit-product, vendor/gapps-go/gapps-go.mk)
