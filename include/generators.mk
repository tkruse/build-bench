# Run Makefile in generator subdir
.PRECIOUS: $(CONFIGURED_BUILD_SOURCE)
$(CONFIGURED_BUILD_SOURCE):
ifndef SOURCE_PROJECT
	$(error SOURCE_PROJECT is not set, defines which sources to use)
endif
ifndef TARGET_NAME
	$(error TARGET_NAME is not set, defines where files are to be generated to)
endif
	$(MAKE) -C $(TEMPLATES_DIR)/$(SOURCE_PROJECT)
