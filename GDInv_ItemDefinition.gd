# Copyright (c) 2019-2022 ZCaliptium.
extends Object
class_name GDInv_ItemDefinition

# Fields.
var identifier: String;
var maxStackSize: int = 0;
var attributes: Dictionary = {};

# Constructor.
func _init(id : String = "null") -> void:
	identifier = id;
	
func get_attribute(key: String, default = null):
	return attributes.get(key, default);

func from_data(json_data: Dictionary) -> int:
	var item_id = json_data.get("id");
	var item_attributes = json_data.get("attributes", {});

	if (item_id == null or typeof(item_id) != TYPE_STRING):
		print("      Malformed json! Field 'id' is missing or invalid!");
		return 1;

	if (typeof(attributes) != TYPE_DICTIONARY):
		print("      Malformed json! Field 'attributes' is not map!");
		return 1;

	# Instantiate new item definition.
	identifier = item_id;
	attributes = item_attributes;
	maxStackSize = int(attributes.get("maxStackSize", 0));
	return 0;

func to_data():
	var data: Dictionary = {};
	data["id"] = identifier;
	data["attributes"] = attributes;
	return data;
