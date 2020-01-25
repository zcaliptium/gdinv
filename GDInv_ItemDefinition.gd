# Copyright (c) 2019-2020 ZCaliptium.
extends Object
class_name GDInv_ItemDefinition

# Fields.
var identifier: String;
var maxStackSize: int = 0;
var attributes: Dictionary = {};

# Constructor.
func _init(id: String) -> void:
	identifier = id;
	
func get_attribute(key: String, default = null):
	return attributes.get(key, default);
