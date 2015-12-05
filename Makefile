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

# invoke specific buildsystem version. TODO: Find out how to generify this with makefile
.PHONY: gradle%
gradle%: $(CONFIGURED_BUILD_ROOT)/gradle/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/gradle $@

.PHONY: ant%
ant%: $(CONFIGURED_BUILD_ROOT)/ant/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/ant $@

.PHONY: maven%
maven%: $(CONFIGURED_BUILD_ROOT)/maven/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/maven $@

.PHONY: buildr%
buildr%: $(CONFIGURED_BUILD_ROOT)/buildr/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/buildr $@

.PHONY: buck%
buck%: $(CONFIGURED_BUILD_ROOT)/buck/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/buck $@

.PHONY: sbt%
sbt%: $(CONFIGURED_BUILD_ROOT)/sbt/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/sbt $@

.PHONY: leiningen%
leiningen%: $(CONFIGURED_BUILD_ROOT)/leiningen/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/leiningen $@

.PHONY: lein-sub%
lein-sub%: $(CONFIGURED_BUILD_ROOT)/lein-sub/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/lein-sub lein-sub$*

.PHONY: bazel%
bazel%: $(CONFIGURED_BUILD_ROOT)/bazel/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/bazel $@

.PHONY: pants%
pants%: $(CONFIGURED_BUILD_ROOT)/pants/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/pants $@


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
