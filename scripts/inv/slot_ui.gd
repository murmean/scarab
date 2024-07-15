extends Button

@onready var center_container = $CenterContainer
@onready var inventory = preload("res://scenes/inv/player_inventory.tres")
var item_stack_gui :ItemStackGui
var index: int
func insert(isg: ItemStackGui):
	item_stack_gui = isg
	center_container.add_child(item_stack_gui)
	
	if !item_stack_gui.inventory_slot || inventory.slots[index] == item_stack_gui.inventory_slot:
		return
	inventory.insert_slot(index,item_stack_gui.inventory_slot)
	
	
func take_item():
	var item = item_stack_gui
	
	inventory.remove_slot(item_stack_gui.inventory_slot)
	
	if item != null:
		center_container.remove_child(item)
	item_stack_gui = null
	
	return item
	
func is_empty():
	return !item_stack_gui
