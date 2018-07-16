ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = LabelHider
LabelHider_FILES = Tweak.xm
LabelHider_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += labelhider
include $(THEOS_MAKE_PATH)/aggregate.mk
