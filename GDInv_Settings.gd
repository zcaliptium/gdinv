# Copyright (c) 2019-2020 ZCaliptium.
extends Object

const OPT_PATHS = "PluginSettings/gdinv/ItemJsonPaths";
const OPT_LOADONREADY = "PluginSettings/gdinv/LoadOnReady";

# Loads settings related to this plugin.
static func load_settings() -> void:
	set_default(OPT_PATHS, {});
	set_default(OPT_LOADONREADY, true);

	var property_info = {
	    "name": OPT_PATHS,
	    "type": TYPE_STRING_ARRAY,
	    "hint": PROPERTY_HINT_DIR
	}
	
	var property_info2 = {
	    "name": OPT_LOADONREADY,
	    "type": TYPE_BOOL
	}

	ProjectSettings.add_property_info(property_info);
	ProjectSettings.add_property_info(property_info2);
	
static func get_option(name: String):
	return ProjectSettings.get(name);

# Sets project property if not exists.
static func set_default(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);