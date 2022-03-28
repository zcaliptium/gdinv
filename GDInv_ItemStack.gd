# Copyright (c) 2019-2022 ZCaliptium.
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

# Get stack data from the Dictionary.
#   For example you can get such dictionary from JSON.
func from_data(json_data: Dictionary):
	var item_id = json_data.get("item", "null");
	var size = json_data.get("stackSize", 0);
	var caps = json_data.get("capabilities", {})

	if (typeof(item_id) == TYPE_STRING and item_id != "null"):
		item = GDInv_ItemDB.get_item_by_id(item_id);

	if (typeof(caps) == TYPE_DICTIONARY):
		capabilities = caps;

	if (typeof(size) == TYPE_REAL or typeof(size) == TYPE_INT):
		stackSize = int(size);

# Returns Dictionary that represents this stack.
#   Use to_json on result to get JSON string.
func to_data():
	var data: Dictionary = {};

	# Put data into dictionary.
	if (item == null):
		data["item"] = null;
	else:
		data["item"] = item.identifier;
	data["stackSize"] = stackSize;
	data["capabilities"] = capabilities;

	return data; # Serialize as json.
