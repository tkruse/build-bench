# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

.PHONY: default
default: bazel

include ../../include/time.mk

export BAZEL_DIR=$(CACHE_DIR)/bazel
export BAZELRC_PATH=$(BAZEL_DIR)/bazel_home

.PHONY: bazel
bazel: bazel$(BAZEL_DEFAULT_VERSION)

.PHONY: version
version: $(BAZEL_DIR)/bazel$(BAZEL_DEFAULT_VERSION)/bin/bazel
	$(BAZEL_DIR)/bazel$(BAZEL_DEFAULT_VERSION)/bin/bazel version

.NOTPARALLEL: bazel%
.PHONY: bazel%
bazel%: $(CONFIGURED_BUILD_ROOT)/bazel%/BUILD $(BAZEL_DIR)/bazel%/bin/bazel $(TIME)
	$(info ******* bazel start)
	cd $(CONFIGURED_BUILD_ROOT)/bazel$*; $(BAZEL_DIR)/bazel$*/bin/bazel fetch -- :all
	cd $(CONFIGURED_BUILD_ROOT)/bazel$*; $(TIME) $(BAZEL_DIR)/bazel$*/bin/bazel test --verbose_failures --javacopt='-extra_checks:off' //:example-tests

.PRECIOUS: $(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh
$(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh:
	@mkdir -p $(BAZEL_DIR)
	@cd $(BAZEL_DIR); wget https://github.com/bazelbuild/bazel/releases/download/$*/bazel-$*-installer-linux-x86_64.sh
	@cd $(BAZEL_DIR); chmod u+x bazel-$*-installer-linux-x86_64.sh

.PRECIOUS: $(BAZEL_DIR)/bazel%/bin/bazel
$(BAZEL_DIR)/bazel%/bin/bazel: $(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh
	@mkdir -p $(BAZEL_DIR)
	@mkdir -p $(BAZELRC_PATH)
	cd $(BAZEL_DIR); ./bazel-$*-installer-linux-x86_64.sh --prefix=$(BAZEL_DIR)/bazel$* --bazelrc=$(BAZELRC_PATH)/bazel.bazelrc


.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/bazel%/BUILD
$(CONFIGURED_BUILD_ROOT)/bazel%/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/bazel $(CONFIGURED_BUILD_ROOT)/bazel$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

