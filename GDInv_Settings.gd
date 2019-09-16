# Copyright (c) 2019 ZCaliptium.
extends Object

const PATHS_OPTION = "PluginSettings/gdinv/ItemJsonPaths";

# Loads settings related to this plugin.
static func load_settings() -> void:
	set_default(PATHS_OPTION, {});

	var property_info = {
	    "name": PATHS_OPTION,
	    "type": TYPE_STRING_ARRAY,
	    "hint": PROPERTY_HINT_DIR
	}

	ProjectSettings.add_property_info(property_info);
	
static func get_option(name: String):
	return ProjectSettings.get(name);

# Sets project property if not exists.
static func set_default(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);