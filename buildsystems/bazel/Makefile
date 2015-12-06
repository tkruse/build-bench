# make magic not needed
export MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

ifndef ROOT_DIR
export ROOT_DIR=$(shell readlink -m $(shell pwd)/../..)
endif

ifndef BUILD_DIR
include $(ROOT_DIR)/include/includes.mk
endif

include $(ROOT_DIR)/include/generators.mk

.PHONY: default
default: bazel

include $(ROOT_DIR)/include/time.mk

export BAZEL_DIR=$(CACHE_DIR)/bazel

export BAZEL_OPTIONS:=--test_verbose_timeout_warnings --verbose_failures --javacopt='-extra_checks:off'

.PHONY: bazel
bazel: bazel$(BAZEL_DEFAULT_VERSION)

.PHONY: version
version: $(BAZEL_DIR)/bazel$(BAZEL_DEFAULT_VERSION)/bin/bazel
	$(BAZEL_DIR)/bazel$(BAZEL_DEFAULT_VERSION)/bin/bazel version

.NOTPARALLEL: bazel%
.PHONY: bazel%
bazel%: $(CONFIGURED_BUILD_ROOT)/bazel%/BUILD $(BAZEL_DIR)/bazel%/bin/bazel $(TIME)
	$(info ******* bazel start)
ifndef BAZEL_NO_PREFETCH
# fetch command has no spawn_strategy option, required on Travis CI
	cd $(CONFIGURED_BUILD_ROOT)/bazel$*; $(BAZEL_DIR)/bazel$*/bin/bazel --bazelrc=$(BAZEL_DIR)/bazel$*/bazel.bazelrc fetch -- :all
endif
	cd $(CONFIGURED_BUILD_ROOT)/bazel$*; $(TIME) $(BAZEL_DIR)/bazel$*/bin/bazel --bazelrc=$(BAZEL_DIR)/bazel$*/bazel.bazelrc test $(BAZEL_COMMAND_OPTIONS) $(BAZEL_OPTIONS) //:example-tests

.PRECIOUS: $(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh
$(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh:
	@mkdir -p $(BAZEL_DIR)
	@cd $(BAZEL_DIR); wget https://github.com/bazelbuild/bazel/releases/download/$*/bazel-$*-installer-linux-x86_64.sh
	@cd $(BAZEL_DIR); chmod u+x bazel-$*-installer-linux-x86_64.sh

.PRECIOUS: $(BAZEL_DIR)/bazel%/bazel.bazelrc
$(BAZEL_DIR)/bazel%/bazel.bazelrc:
	mkdir -p $(BAZEL_DIR)/bazel$*
	echo "build --package_path %workspace%:$(BAZEL_DIR)/bazel$*/lib/bazel/base_workspace\nfetch --package_path %workspace%:$(BAZEL_DIR)/bazel$*/lib/bazel/base_workspace" > $(BAZEL_DIR)/bazel$*/bazel.bazelrc

.PRECIOUS: $(BAZEL_DIR)/bazel%/bin/bazel
$(BAZEL_DIR)/bazel%/bin/bazel: $(BAZEL_DIR)/bazel-%-installer-linux-x86_64.sh $(BAZEL_DIR)/bazel%/bazel.bazelrc
	@mkdir -p $(BAZEL_DIR)
	cd $(BAZEL_DIR); ./bazel-$*-installer-linux-x86_64.sh --prefix=$(BAZEL_DIR)/bazel$* --bazelrc=$(BAZEL_DIR)/bazel$*/bazel.bazelrc
# touch so that make remebers next time
	@touch $(BAZEL_DIR)/bazel$*/bin/bazel

.PRECIOUS: $(CONFIGURED_BUILD_ROOT)/bazel%/BUILD
$(CONFIGURED_BUILD_ROOT)/bazel%/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/bazel $(CONFIGURED_BUILD_ROOT)/bazel$* --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)
