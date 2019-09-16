# Copyright (c) 2019 ZCaliptium.
tool
extends EditorPlugin

const PluginSettings = preload("GDInv_Settings.gd");

# When plugin got loaded.
func _enter_tree() -> void:
	add_autoload_singleton("GDInv_ItemDB", "res://addons/gdinv/GDInv_ItemDB.gd");
	add_custom_type("GDInv_Inventory", "Node", load("res://addons/gdinv/GDInv_Inventory.gd"), load("res://addons/gdinv/GDInv_Inventory.png"));

	PluginSettings.load_settings();

# When plugin going to be unloaded.
func _exit_tree() -> void:
	remove_autoload_singleton("GDInv_ItemDB");
	remove_custom_type("GDInv_Inventory");
