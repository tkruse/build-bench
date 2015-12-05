# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

# only works when running make in root folder :-(
export ROOT_DIR=$(shell pwd)


# load config files to set variables
include include/includes.mk

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


.PHONY: all
all: $(BUILDSYSTEMS)

# Run Makefile in generator subdir
.PRECIOUS: $(CONFIGURED_BUILD_SOURCE)
$(CONFIGURED_BUILD_SOURCE):
	$(MAKE) -C $(TEMPLATES_DIR)/$(SOURCE_PROJECT)

# copy project sources into buildsystem subdir
.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/%/src
$(CONFIGURED_BUILD_ROOT)/%/src: $(CONFIGURED_BUILD_SOURCE)
	@mkdir -p $(CONFIGURED_BUILD_ROOT)/$*
	@cd $(CONFIGURED_BUILD_ROOT)/$*; cp -rf $(CONFIGURED_BUILD_SOURCE)/* .



# invoke specific buildsystem version. TODO: Find out how to generify this with makefile

.PHONY: gradle
gradle:gradle$(GRADLE_DEFAULT_VERSION)

.PHONY: gradle%
gradle%: $(CONFIGURED_BUILD_ROOT)/gradle%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/gradle $@


.PHONY: ant_ivy
ant_ivy:ant_ivy$(ANT_DEFAULT_VERSION)

.PHONY: ant_ivy%
ant_ivy%: $(CONFIGURED_BUILD_ROOT)/ant_ivy%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/ant_ivy $@


.PHONY: maven
maven:maven$(MAVEN_DEFAULT_VERSION)

.PHONY: maven%
maven%: $(CONFIGURED_BUILD_ROOT)/maven%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/maven $@


.PHONY: buildr
buildr:buildr$(BUILDR_DEFAULT_VERSION)

.PHONY: buildr%
buildr%: $(CONFIGURED_BUILD_ROOT)/buildr%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/buildr $@


.PHONY: buck
buck:buck$(BUCK_DEFAULT_VERSION)

.PHONY: buck%
buck%: $(CONFIGURED_BUILD_ROOT)/buck%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/buck $@


.PHONY: sbt
sbt:sbt$(SBT_DEFAULT_VERSION)

.PHONY: sbt%
sbt%: $(CONFIGURED_BUILD_ROOT)/sbt%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/sbt $@


.PHONY: leiningen
leiningen:leiningen$(LEININGEN_DEFAULT_VERSION)

.PHONY: leiningen%
leiningen%: $(CONFIGURED_BUILD_ROOT)/leiningen%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/leiningen $@


.PHONY: lein-sub
lein-sub:lein-sub$(LEININGEN_DEFAULT_VERSION)

.PHONY: lein-sub%
lein-sub%: $(CONFIGURED_BUILD_ROOT)/lein-sub%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/lein-sub lein-sub$*


.PHONY: bazel
bazel:bazel$(BAZEL_DEFAULT_VERSION)

.PHONY: bazel%
bazel%: $(CONFIGURED_BUILD_ROOT)/bazel%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/bazel $@


.PHONY: pants
pants:pants$(PANTS_DEFAULT_VERSION)

.PHONY: pants%
pants%: $(CONFIGURED_BUILD_ROOT)/pants%/src
	$(MAKE) -C $(BUILDSYSTEMS_DIR)/pants $@


.PHONY: versions
versions:
	java -version
	$(foreach LOOP_SYSTEM,$(BUILDSYSTEMS),$(MAKE) -C $(BUILDSYSTEMS_DIR)/$(LOOP_SYSTEM) version;)
