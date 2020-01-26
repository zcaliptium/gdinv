# Copyright (c) 2019-2020 ZCaliptium.
extends Object

const PROP_PATHS = "PluginSettings/gdinv/ItemJsonPaths";
const PROP_LOADONREADY = "PluginSettings/gdinv/LoadOnReady";

const PROPERTIES: Array = [
	{
	    "name": PROP_PATHS,
	    "type": TYPE_STRING_ARRAY,
	    "hint": PROPERTY_HINT_DIR
	},
	{
	    "name": PROP_LOADONREADY,
	    "type": TYPE_BOOL
	}
];

# Loads settings related to this plugin.
static func load_settings() -> void:
	set_default(PROP_PATHS, {});
	set_default(PROP_LOADONREADY, true);

	for i in range(0, PROPERTIES.size()):
		var property_info: Dictionary = PROPERTIES[i];
		ProjectSettings.add_property_info(property_info);
	
static func get_option(name: String):
	return ProjectSettings.get(name);

# Sets project property if not exists.
static func set_default(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);