extends Resource

class_name Inventory

signal update

@export var slots: Array[InvSlot]

func insert(item: InvItem):
	var item_slots = slots.filter(func(slot): return slot.item == item)
	if !item_slots.is_empty():
		item_slots[0].amount +=1 
	else:
		var empty_slots = slots.filter(func(slot): return slot.item == null)
		if !empty_slots.is_empty():
			empty_slots[0].item = item
			empty_slots[0].amount = 1
	update.emit()
func remove_slot(inventary_slot:InvSlot):
	var index = slots.find(inventary_slot)
	if index < 0: return
	
	slots[index] = InvSlot.new()
	
func insert_slot(index:int, inventory_slot: InvSlot):
	slots[index] = inventory_slot
