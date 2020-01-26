# Copyright (c) 2019-2020 ZCaliptium.
extends Node

# Fields.
const ItemDefinition = preload("GDInv_ItemDefinition.gd");
const PluginSettings = preload("GDInv_Settings.gd");
var REGISTRY: Dictionary = {};

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var isLoadOnReady: bool = PluginSettings.get_option(PluginSettings.PROP_LOADONREADY);
	
	if (isLoadOnReady):
		load_data();

# Loads all item definitions from specified paths.
func load_data() -> void:
	var paths: Array = PluginSettings.get_option(PluginSettings.PROP_PATHS);
	
	print("[gdinv] Item JSON directories count... ", paths.size());

	# Iterate through array.
	for i in range(0, paths.size()):
		var path: String = paths[i];
		
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
		print("      Malformed json! Missing 'id' field!");
		return;
		
	if (typeof(item_id) != TYPE_STRING):
		print("      Malformed json! Field 'id' is not string!");
		return;

	var attributes = item_data.get("attributes", {});

	if (typeof(attributes) != TYPE_DICTIONARY):
		print("      Malformed json! Field 'attributes' is not map!");
		return;

	var new_item = ItemDefinition.new(item_id);
	new_item.attributes = attributes;
	new_item.maxStackSize = int(new_item.attributes.get("maxStackSize", 0));
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
