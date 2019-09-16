# Copyright (c) 2019 ZCaliptium.
tool
extends EditorPlugin

const PATHS_OPTION = "PluginSettings/gdinv/ItemJsonPaths";

# When plugin got loaded.
func _enter_tree() -> void:
	add_autoload_singleton("GDInv_ItemDB", "res://addons/gdinv/GDInv_ItemDB.gd");
	add_custom_type("GDInv_Inventory", "Node", load("res://addons/gdinv/GDInv_Inventory.gd"), load("res://addons/gdinv/GDInv_Inventory.png"));

	ProjectSettings_set_if_ne(PATHS_OPTION, {});

	var property_info = {
	    "name": PATHS_OPTION,
	    "type": TYPE_STRING_ARRAY,
	    "hint": PROPERTY_HINT_DIR
	}

	ProjectSettings.add_property_info(property_info);

# Sets project property if not exists.
func ProjectSettings_set_if_ne(name: String, value) -> void:
	if (!ProjectSettings.has_setting(name)):
		ProjectSettings.set(name, value);

# When plugin going to be unloaded.
func _exit_tree() -> void:
	remove_autoload_singleton("GDInv_ItemDB");
	remove_custom_type("GDInv_Inventory");
