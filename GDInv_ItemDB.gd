# Copyright (c) 2019-2022 ZCaliptium.
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
		
		if (!path.is_empty()):
			print("  [", i, "] - ", path);
			load_items_from_path(path);
		else:
			print("  [", i, "] - Empty");

# Tries to load JSON files from specified directory.
func load_items_from_path(path: String) -> void:
	var is_rec = PluginSettings.get_option(PluginSettings.PROP_RECLOAD);
	var files = find_all_at_path(path, is_rec);
	
	print("    Found files... ", files.size());
	
	for i in range(0, files.size()):
		var file = files[i];
		print("    ", file)
		load_item(file);

func find_all_at_path(path: String, recursive: bool = true) -> Array:
	var found_files := [];
	var dir_queue := [path];
	var dir: DirAccess;

	var file: String;
	while !file.is_empty() or not dir_queue.is_empty():
		if file:
			if dir.current_is_dir() and recursive:
				dir_queue.append("%s/%s" % [dir.get_current_dir(), file]);
			elif file.ends_with(".json"):
				found_files.append("%s/%s.%s" % [dir.get_current_dir(), file.get_basename(), file.get_extension()]);
		else:
			if dir:
				dir.list_dir_end();

			if dir_queue.is_empty():
				break;

			# Open next dir.
			dir = DirAccess.open(dir_queue.pop_front());
			dir.list_dir_begin() ;# TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547

		file = dir.get_next();

	return found_files;
	
func load_item(url: String) -> void:
	var file
	
	if (!FileAccess.file_exists(url)):
		print("      Failed to open file! Doesn't exist!");
		return;
	
	file = FileAccess.open(url, FileAccess.READ)
	
	if (!file):
		print("      Failed to open file!");
		return;

	#print("test: ", file.get_as_text())

	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text());
	var json_result = test_json_conv.get_data()
	file.close();

	if (json_result == null):
		print("      Parse error");
		return;

	#print("      Data: ", json_result);
	var item_data:Dictionary = json_result;
	var new_item = ItemDefinition.new();
	if (new_item.from_data(item_data) == 0):
		REGISTRY[new_item.identifier] = new_item;

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
