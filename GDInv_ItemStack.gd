# Copyright (c) 2019-2020 ZCaliptium.
extends Object
class_name GDInv_ItemStack

# Fields.
var stackSize: int = 0;
var item: GDInv_ItemDefinition = null;
var capabilities: Dictionary = {};

# Constructor.
func _init(item_def = null, count = 1) -> void:
	if (item_def != null):
		item = item_def;

	if (count < 1):
		count = 1;

	stackSize = count;

func get_capability(key: String, default = null):
	return capabilities.get(key, default);