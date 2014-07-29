export ARCHS = armv7 armv7s arm64
export SDKVERSION = 7.1
export THEOS_BUILD_DIR = build_dir

include theos/makefiles/common.mk

TWEAK_NAME = TapToUnlock7
TapToUnlock7_FILES = Tweak.xm UIColor_Categories.m
TapToUnlock7_FRAMEWORKS = UIKit QuartzCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += taptounlock7prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
