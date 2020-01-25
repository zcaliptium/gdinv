# Copyright (c) 2019-2020 ZCaliptium.
tool
extends EditorPlugin

const ITEMDB_NAME = "GDInv_ItemDB";
const INVENTORY_NAME = "GDInv_Inventory";
const PluginSettings = preload("GDInv_Settings.gd");

# When plugin got loaded.
func _enter_tree() -> void:
	add_autoload_singleton(ITEMDB_NAME, "res://addons/gdinv/GDInv_ItemDB.gd");
	add_custom_type(INVENTORY_NAME, "Node", load("res://addons/gdinv/GDInv_Inventory.gd"), load("res://addons/gdinv/GDInv_Inventory.png"));

	PluginSettings.load_settings();

# When plugin going to be unloaded.
func _exit_tree() -> void:
	remove_autoload_singleton(ITEMDB_NAME);
	remove_custom_type(INVENTORY_NAME);
