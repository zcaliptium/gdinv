# GDInv
GDInv (Godot Inventory) - simple plugin that trying to be universal solution for adding inventory-system into your game(s).
That set of scripts appear to be generic. So it haven't any useless code for making inventory GUIs. That lays on your own because every game have own style.

Features:
 - Definition <> Stack based;
 - Lightweight solution;
 - Built-in item definition parser;
 - Item Database;
 - Basic Inventory node;

## How to use?
1. Create ``addons/`` folder at your project root.
2. Clone repository into that folder to have ``addons/gdinv/``.
 - If your project uses Git too then you can add this project as submodule.
3. Enable plugin at ``Project Setttings -> Plugins`` menu.
4. You should specify at least one path with item JSONs.
    - Go to ``Project Settings -> General``.
    - Find ``Plugin Settings -> Gdinv``.
    - Add path. For example: ``res://assets/data/items/``
5. Congrats! You can use it. Feel free to integrate into your mechanics.

## Example of JSON file:
```json
{
    "id": "knife",
    "attributes": {
        "maxStackSize": 1,
        "type": "weapon",
        "minDamage": 1,
        "maxDamage": 2
    }
}
```

## Components
### GDInv_ItemDefinition
Class that is like template for some specific items.

It has such fields:
 - Identifier (String);
 - Max Stack Size
 - Attributes (Dictionary).
 
``Attributes`` appear to be most-generic way to store properties of specific item type.

### GDInv_ItemDB
Singleton class. Automatically will be added into autoload when you enable the plugin.  
Contains ``Dictionary`` container for all the ``GDINv_ItemDefinition`` instances. Perfoms parsing of JSONs. 

### GDInv_ItemStack
Item instance inside of some sort of inventory.
That has such fields:
 - Stack Size
 - Item (Reference)
 - Capabilities (Dictionary)
 
``Capabilities`` have nearly-same purpose as ``Attributes``. Just called with another word to be less confusing. Designed store stuff specific for one stack instance.  
Case of usage: RPG game can have items enchanted. Then you make something with key ``enchantements`` at capabilities dictionary.  
Then you can easilly get it from stack from any place of your game logic code.

### GDInv_Inventory
Node that can be accessed from "Create A Node" menu. Basic implementation of some kind of inventory (player, chest, etc.).
If you don't like it you can always write your own or extend this one.

Inventory can be finite or infinite. There is ``MaxStacks`` property. Values less than 1 make inventory infinite, otherwise finite.

### GDInv_Plugin
Simply plugin routies. There is no reason to explain that it does.