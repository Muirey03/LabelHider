include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = LabelHider
LabelHider_FILES = MRYRootListController.m
LabelHider_INSTALL_PATH = /Library/PreferenceBundles
LabelHider_FRAMEWORKS = UIKit
LabelHider_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/LabelHider.plist$(ECHO_END)
