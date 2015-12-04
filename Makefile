# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:


include configs/defaults.mk

.PHONY: default
default: all

.PHONY: clean-caches
clean-sources:
	rm -rf $(CACHE_DIR)

.PHONY: clean-builds
clean-builds:
	rm -rf $(BUILD_DIR)

# clean is synonym to clean-builds
.PHONY: clean
clean: clean-builds

.PHONY: clean-all
clean-all: clean-builds clean-caches


ifdef CONFIG
include $(CONFIG)
else
include $(DEFAULT_CONFIG)
endif

.PHONY: all
all: $(BUILDSYSTEMS)

# Run Makefile in generator subdir
.PRECIOUS: $(CONFIGURED_BUILD_SOURCE)
$(CONFIGURED_BUILD_SOURCE):
	$(MAKE) -C $(TEMPLATES_DIR)/$(SOURCE_PROJECT)

# copy project sources into buildsystem subdir
$(CONFIGURED_BUILD_ROOT)/%/src: $(CONFIGURED_BUILD_SOURCE)
	@mkdir -p $@/..
	@cd $@/..; cp -rf $(CONFIGURED_BUILD_SOURCE)/* .

# invoke buildsystem makefile to generate buildsystem sources and run benchmark
.PHONY: $(BUILDSYSTEMS)
$(BUILDSYSTEMS): % : $(CONFIGURED_BUILD_ROOT)/%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/$@



.PHONY: versions
versions:
	java -version
	mvn --version
	gradle --version
	sbt sbtVersion
	buildr --version
	buck --version
	ant -version
	bazel version
	cd $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/pants; pants --version
