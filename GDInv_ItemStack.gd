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

# Get data from dictionary taken from JSON.
func from_json(json_data: Dictionary):
	var item_id = json_data.get("item", "null");
	var size = json_data.get("stackSize", null);
	var caps = json_data.get("capabilities", {})

	if (typeof(item_id) == TYPE_STRING and item_id != "null"):
		item = GDInv_ItemDB.get_item_by_id(item_id);

	if (typeof(caps) == TYPE_DICTIONARY):
		capabilities = caps;

	if (typeof(size) == TYPE_REAL):
		stackSize = int(size);

# Returns json string that should be enough to represent this item.
func to_json() -> String:
	var Data: Dictionary = {};

	# Put data into dictionary.
	if (item == null):
		Data["item"] = null;
	else:
		Data["item"] = item.identifier;
	Data["stackSize"] = stackSize;
	Data["capabilities"] = capabilities;

	return to_json(Data); # Serialize as json.
