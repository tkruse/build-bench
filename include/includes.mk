
include configs/defaults.mk

# file gets loaded if present, else no error
-include custom.mk

ifdef CONFIG
include $(CONFIG)
else
# simple sample project to check everything is fine
include $(DEFAULT_CONFIG)
endif
