# Copyright (c) 2019 ZCaliptium.
extends Node

const TEST_OPTION = "PluginSettings/gdinv/ItemJsonPaths";

const ItemDefinition = preload("GDInv_ItemDefinition.gd");
var REGISTRY: Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var arr: Array = ProjectSettings.get(TEST_OPTION);
	
	print("Item JSON directories count... ", arr.size());

	# Iterate through array.
	for i in range(0, arr.size()):
		var path: String = arr[i];
		
		if (!path.empty()):
			print("  [", i, "] - ", path);
			load_items_from_dir(path);
		else:
			print("  [", i, "] - Empty");

# Tries to load JSON files from specified directory.
func load_items_from_dir(path: String) -> void:
	var dir = Directory.new();
	
	# If directory exist.
	if (dir.open(path) == OK):
		dir.list_dir_begin(true);
		var file_name = dir.get_next();
		
		# Until we have entries...
		while (file_name != ""):
			if (!dir.current_is_dir() && file_name.ends_with(".json")):
				print("    ", file_name);
				load_item(path + file_name);
			file_name = dir.get_next();
		
		print("    End");
	
func load_item(url: String) -> void:
	var file = File.new();
	
	if (!file.file_exists(url)):
		print("      Failed to open file! Doesn't exist!");
		return;
	
	if (file.open(url, File.READ)):
		print("      Failed to open file!");
		return;

	#print("test: ", file.get_as_text())

	var json_result = JSON.parse(file.get_as_text());
	file.close();

	if (json_result.error != 0):
		print("      Parse error (", json_result.error, ")");
		return;

	#print("      Data: ", json_result.result);
	var item_data:Dictionary = json_result.result;
	parse_item_data(item_data);
	
func parse_item_data(item_data: Dictionary) -> void:
	var item_id: String = item_data.get("id");

	if (item_id == null):
		print("      Malformed json! Missing identifier field!");
		return;

	var new_item = ItemDefinition.new(item_id);
	new_item.attributes = item_data.get("attributes", {});
	new_item.maxStackSize = new_item.attributes.get("maxStackSize", 0);
	REGISTRY[item_id] = new_item;
	
# Makes new stack instance and returns reference to it, otherwise returns null.
func make_stack_by_id(item_id: String, count: int = 1) -> GDInv_ItemStack:
	if (item_id == null):
		return null;
	
	# Get item definition.
	var item_def: GDInv_ItemDefinition = REGISTRY.get(item_id);
	if (item_def == null):
		return null;
		
	var new_stack = GDInv_ItemStack.new(item_def, count);
	return new_stack;

# Getter by key for definition registry.
func get_item_by_id(item_id: String) -> GDInv_ItemDefinition:
	return REGISTRY.get(item_id);