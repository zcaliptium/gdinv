# Copyright (c) 2019-2022 ZCaliptium.
extends Object

const PREFIX = "PluginSettings/gdinv/"

const PROP_PATHS = PREFIX + "ItemJsonPaths";
const PROP_LOADONREADY = PREFIX + "LoadOnReady";
const PROP_RECLOAD = PREFIX + "RecursiveLoad";

const PROPERTIES: Array = [
	{
		"name": PROP_PATHS,
		"type": TYPE_PACKED_STRING_ARRAY,
		"hint": PROPERTY_HINT_DIR
	},
	{
		"name": PROP_LOADONREADY,
		"type": TYPE_BOOL
	},
	{
		"name": PROP_RECLOAD,
		"type": TYPE_BOOL
	}
];

const DEFAULTS: Dictionary = {
	PROP_PATHS: {},
	PROP_LOADONREADY: true,
	PROP_RECLOAD: true
}

# Loads settings related to this plugin.
static func load_settings() -> void:
	for i in range(0, PROPERTIES.size()):
		var property_info: Dictionary = PROPERTIES[i];
		set_default(property_info["name"], DEFAULTS.get(property_info["name"]));
		ProjectSettings.add_property_info(property_info);

static func get_option(name: String):
	return ProjectSettings.get(name);

# Sets project property if not exists.
static func set_default(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);
