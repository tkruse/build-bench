.PHONY: default
default: bazel

.PHONY: bazel
bazel: $(CONFIGURED_BUILD_ROOT)/bazel/BUILD
	$(info ******* bazel start)
	cd $(CONFIGURED_BUILD_ROOT)/bazel; bazel fetch -- :all
	cd $(CONFIGURED_BUILD_ROOT)/bazel; time bazel test --javacopt='-extra_checks:off' //:example-tests


$(CONFIGURED_BUILD_ROOT)/bazel/BUILD: $(CONFIGURED_BUILD_SOURCE)
	@python $(SCRIPTS_DIR)/apply-templates.py $(BUILDTEMPLATES_DIR)/$(BUILD_DEFINITIONS)/bazel $(CONFIGURED_BUILD_ROOT)/bazel --subprojectnum=$(SUBPROJECT_NUM) --filenum=$(FILE_NUM)

