ifndef ROOT_DIR
$(error ROOT_DIR is not set)
endif

include $(ROOT_DIR)/configs/defaults.mk

# file gets loaded if present, else no error
-include $(ROOT_DIR)/custom.mk

ifdef CONFIG
include $(CONFIG)
else
# simple sample project to check everything is fine
include $(DEFAULT_CONFIG)
endif

.PHONY: default
default:

.PHONY: clean-builds
clean-builds:
	rm -rf $(BUILD_DIR)

# clean is synonym to clean-builds
.PHONY: clean
clean: clean-builds

.PHONY: clean-sources
clean-sources:
	rm -rf $(CACHE_DIR)

.PHONY: clean-all
clean-all: clean-builds clean-caches
