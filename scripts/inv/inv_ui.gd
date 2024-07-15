extends Control

@onready var inv :Inventory = preload("res://scenes/inv/player_inventory.tres")
@onready var slots :Array = $NinePatchRect/GridContainer.get_children()
@onready var item_stack_gui_class = preload("res://scenes/inv/items_stack_gui.tscn")

var is_open = false
var item_in_hand : ItemStackGui
var item_stack_gui :ItemStackGui
func _ready():
	connectSlots()
	inv.update.connect(update)
	update()
	close()
	
func connectSlots():
	for i in range(slots.size()):
		var slot = slots[i]
		slot.index = i 
		
		var callable = Callable(onSlotClicked)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
	
func update():
	for i in range(min(inv.slots.size(),slots.size())):
		var inventory_slot: InvSlot = inv.slots[i]
		
		if !inventory_slot.item: continue
		
		var item_stack_gui:ItemStackGui = slots[i].item_stack_gui
		if !item_stack_gui:
			item_stack_gui = item_stack_gui_class.instantiate()
			slots[i].insert(item_stack_gui)
		
		item_stack_gui.inventory_slot = inventory_slot
		item_stack_gui.update()
	
func _process(delta):
	if Input.is_action_just_pressed("OpenInv"):
		if is_open:
			close()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			open()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func open():
	visible = true
	is_open = true
	
func close():
	visible = false
	is_open = false
	
func onSlotClicked(slot):
	if slot.is_empty():
		if !item_in_hand: return
		
		insert_item_in_slot(slot)
		return	
	if !item_in_hand:
		take_item_from_slot(slot)
		return
		
	if slot.item_stack_gui.inventory_slot.item.name == item_in_hand.inventory_slot.item.name:
		stack_items(slot)
		return
		
	swap_items(slot)

func take_item_from_slot(slot):
	item_in_hand = slot.take_item()
	add_child(item_in_hand)
	update_item_in_hand()
	
func insert_item_in_slot(slot):
	var item = item_in_hand
	remove_child(item_in_hand)
	item_in_hand = null
	slot.insert(item)

func swap_items(slot):
	var temp_item = slot.take_item()	
	
	insert_item_in_slot(slot)
	
	item_in_hand = temp_item
	add_child(item_in_hand)
	update_item_in_hand()

func stack_items(slot):
	var slot_item: ItemStackGui = slot.item_stack_gui
	var max_amount = slot_item.inventory_slot.item.max_amount_per_stack
	var total_amount = slot_item.inventory_slot.amount + item_in_hand.inventory_slot.amount
	
	if slot_item.inventory_slot.amount == max_amount:
		swap_items(slot)
		return
	if total_amount <= max_amount:
		slot_item.inventory_slot.amount = total_amount
		remove_child(item_in_hand)
		item_in_hand = null
	else: 
		slot_item.inventory_slot.amount = max_amount
		item_in_hand.inventory_slot.amount = total_amount - max_amount
	
	slot_item.update()
	if item_in_hand: item_in_hand.update()

func update_item_in_hand():
	if !item_in_hand: return
	item_in_hand.global_position = get_global_mouse_position() 
	
func _input(event):
	update_item_in_hand()
