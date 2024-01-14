APK_PATH := apks/
APK_FILES := $(wildcard $(APK_PATH)*.apk)

define add-apk
include $(CLEAR_VARS)
LOCAL_MODULE := $(basename $(notdir $(1)))
LOCAL_SRC_FILES := $(1)
LOCAL_MODULE_CLASS := OVERLAYS
LOCAL_MODULE_TAGS := optional
LOCAL_CERTIFICATE := PRESIGNED
LOCAL_MODULE_PATH := $(TARGET_OUT)/product/overlay
LOCAL_MODULE_SUFFIX := .apk
include $(BUILD_PREBUILT)
endef

$(foreach apk,$(APK_FILES),$(eval $(call add-apk,$(apk))))