.PHONY: default
default: $(CONFIGURED_BUILD_SOURCE)

$(CONFIGURED_BUILD_SOURCE): $(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT)
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(CONFIGURED_BUILD_SOURCE)
# softlinking causes problems with some tools (pants)
	@cd $(BUILD_DIR); cp -rf $(DOWNLOAD_SOURCES_DIR)/generated/$(SOURCE_PROJECT) $(CONFIGURED_BUILD_SOURCE)


include $(INCLUDE_DIR)/jinja2_generate.mk
