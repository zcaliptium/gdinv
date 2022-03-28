# Copyright (c) 2019-2022 ZCaliptium.
extends Node
class_name GDInv_Inventory

# Signals.
signal stack_added(slot);
signal stack_merged(slot, count);
signal stack_decreased(slot);
signal stack_removed(slot);
signal data_loaded();
signal cleaned_up();

# Fields.
export var InitOnReady: bool = true;
export var RestrictStackSize: bool = true;
export var MaxStacks: int = 0;
var STACKS: Array = [];

# Called when node enters tree.
func _ready() -> void:
	# If inventory should be auto-initialized on ready.
	if (InitOnReady):
		init();

# Should be called for any finite inventory.
func init() -> void:
	# warning-ignore:unused_variable
	for i in range(0, MaxStacks):
		STACKS.append(null);

# Removes all items from slots.
func clear() -> void:
	STACKS.clear(); # Remove all stacks.

	# Fill finite inventory with dummy stacks.
	if (MaxStacks > 0):
		init();

	emit_signal("cleaned_up");

# Tries to add item by identifier. Returns true on success, otherwise false.
func add_item_by_id(item_id: String, count: int = 1) -> bool:
	var item_def: GDInv_ItemDefinition = GDInv_ItemDB.get_item_by_id(item_id);
	
	if (item_def == null):
		return false;

	return add_item(item_def, count);

# Tries to add item by item definition reference.
# Returns true on success, otherwise false.
func add_item(item_def: GDInv_ItemDefinition, count: int = 1) -> bool:
	var new_stack = GDInv_ItemStack.new(item_def, count);
	return add_stack(new_stack);

# Tries to put stack into inventory.
# Returns true on success, otherwise false.
func add_stack(stack: GDInv_ItemStack) -> bool:
	var firstEmptySlot: int = -1;

	# Iterate trough inventory.
	for i in range(0, STACKS.size()):
		var element: GDInv_ItemStack = STACKS[i];

		# Remember first empty slot.
		if ((firstEmptySlot == -1) && (element == null)):
			firstEmptySlot = i;

		# If found stack with equal item definition.
		if (element != null && element.item == stack.item):
			# Ignore stack size.
			if (!RestrictStackSize || element.item.maxStackSize < 1):
				element.stackSize += stack.stackSize;
				emit_signal("stack_merged", i, stack.stackSize);
				return true;
				
			var maxStackSize: int = element.item.maxStackSize;

			# Skip full stacks.
			if (element.stackSize >= maxStackSize):
				continue;

			var neededToFill: int = maxStackSize - element.stackSize;
			
			# If can be merged into one stack completelly.
			if (neededToFill >= stack.stackSize):
				element.stackSize += stack.stackSize;
				emit_signal("stack_merged", i, stack.stackSize);
				return true;
			else:
				# Fill that stack.
				element.stackSize = maxStackSize;
				emit_signal("stack_merged", i, neededToFill);
				stack.stackSize -= neededToFill; # Change items at source stack.

	# If we can't find stack with same items then we put stack into first empty slot.
	if (firstEmptySlot != -1):
		STACKS[firstEmptySlot] = stack;
		emit_signal("stack_added", firstEmptySlot);
		return true;

	# If infinite inventory then we can expand it.
	if (MaxStacks <= 0):
		STACKS.append(stack);
		emit_signal("stack_added", STACKS.size() - 1);
		return true;

	return false;


# Tries to remove item by identifier.
# Returns amount of removed items. If -1 then it means item_def is null!
func remove_item_by_id(item_id: String, count: int = 1) -> int:
	var item_def: GDInv_ItemDefinition = GDInv_ItemDB.get_item_by_id(item_id);
	
	if (item_def == null):
		return -1;
	
	return remove_item(item_def, count);
	
# Tries to remove item by item definition reference.
# Returns amount of removed items. If -1 then it means item_def is null!
func remove_item(item_def: GDInv_ItemDefinition, count: int = 1) -> int:
	var removedItems: int = 0;
	
	# Iterate trough inventory.
	for i in range(0, STACKS.size()):
		var element: GDInv_ItemStack = STACKS[i];
		
		# Skip empty slots.
		if (element == null):
			continue;

		# If same definition.
		if (element.item == item_def):
			# If enough items. Then just decrement stack.
			if (element.stackSize > count):
				removedItems += count;
				element.stackSize -= count;
				emit_signal("stack_decreased", i);
				return removedItems;
			# If exactly needed item count. Then just remove stack.
			elif (element.stackSize == count):
				removedItems += count;
				STACKS[i] = null;
				emit_signal("stack_removed", i);
				return removedItems;
			
			# If not enough items in stack. And continue cycle.
			removedItems += element.stackSize;
			count -= element.stackSize;
			STACKS[i] = null;
			emit_signal("stack_removed", i);
		
	return removedItems;

# Returns slot number with item that has specified identifier. Otherwise -1.
func find_item_by_id(item_id: String, start: int = 0) -> int:
	var item_def: GDInv_ItemDefinition = GDInv_ItemDB.get_item_by_id(item_id);
	
	if (item_def == null):
		return -1;
	
	return find_item(item_def, start);

# Returns slot number with item that has specified ItemDefinition instance. Otherwise -1.
func find_item(item_def:GDInv_ItemDefinition, start: int = 0) -> int:
	var numStacks = STACKS.size();
	
	if (start >= numStacks):
		return -1;
	
	# Iterate trough inventory.
	for i in range(start, numStacks):
		var element: GDInv_ItemStack = STACKS[i];
		
		if (element != null && element.item == item_def):
			return i;
		
	return -1;

# Returns stack at slot. Returns null if stack isn't present or slot number is invalid.
func at_slot(slot_id: int) -> GDInv_ItemStack:
	if (slot_id < 0 || slot_id >= STACKS.size()):
		return null;
	
	var stack: GDInv_ItemStack = STACKS[slot_id];
	return stack;

# Returns reference to stack in slot. Removes stack from slot simultaneously.
func take_from_slot(slot_id: int) -> GDInv_ItemStack:
	if (slot_id < 0 || slot_id >= STACKS.size()):
		return null;
	
	var stack: GDInv_ItemStack = STACKS[slot_id];
	STACKS[slot_id] = null; # Remove from the slot.
	emit_signal("stack_removed", slot_id);
	return stack;

# Decrements item count at slot
func dec_in_slot(slot_id: int) -> void:
	if (slot_id < 0 || slot_id >= STACKS.size()):
		return;
		
	var stack: GDInv_ItemStack = STACKS[slot_id];
	
	if (stack == null):
		return;

	stack.stackSize -= 1;
	
	if (stack.stackSize <= 0):
		if (MaxStacks > 0):
			STACKS[slot_id] = null;
		else:
			STACKS.remove(slot_id);

		emit_signal("stack_removed", slot_id);

# Returns Dictionary that represents this inventory.
#   Use to_json on result to get JSON string.
func to_data() -> Dictionary:
	var data: Dictionary = {};
	var stacks_data: Array = [];
	
	# Iterate trough inventory.
	for i in range(0, STACKS.size()):
		if (STACKS[i] == null):
			stacks_data.append(null);
			continue;

		stacks_data.append(STACKS[i].to_data());

	data["stacks"] = stacks_data;

	return data;

# Get stack data from the Dictionary.
#   For example you can get such dictionary from JSON.
func from_data(json_data: Dictionary) -> void:
	var stacks_data = json_data.get("stacks", []);
	
	clear();
	
	if (typeof(stacks_data) == TYPE_ARRAY):
		# For finite inventory.
		if (RestrictStackSize):
			for i in range (0, stacks_data.size()):
				if (i >= STACKS.size()):
					break;

				# Skip invalid stacks (null elements in array).
				if (stacks_data[i] == null):
					continue;

				var new_stack = GDInv_ItemStack.new();
				new_stack.from_data(stacks_data[i]);
				STACKS[i] = new_stack;
		else:
			for i in range (0, stacks_data.size()):
				var new_stack = GDInv_ItemStack.new();
				new_stack.from_data(stacks_data[i]);
				STACKS[i].append(new_stack);

	emit_signal("data_loaded");
