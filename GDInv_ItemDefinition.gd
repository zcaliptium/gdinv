# Copyright (c) 2019 ZCaliptium.
extends Object
class_name GDInv_ItemDefinition

# Fields.
var identifier: String;
var maxStackSize: int = 0;
var attributes: Dictionary = {};

# Constructor.
func _init(id: String) -> void:
	identifier = id;