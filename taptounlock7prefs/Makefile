export ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = TapToUnlock7Prefs
TapToUnlock7Prefs_FILES = TapToUnlock7Prefs.mm
TapToUnlock7Prefs_INSTALL_PATH = /Library/PreferenceBundles
TapToUnlock7Prefs_FRAMEWORKS = UIKit
TapToUnlock7Prefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TapToUnlock7Prefs.plist$(ECHO_END)
