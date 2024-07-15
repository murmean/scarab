extends Panel

class_name ItemStackGui

@onready var item_visual : Sprite2D = $item_display
@onready var amount_text: Label = $Label

var inventory_slot:InvSlot

func update():
	if !inventory_slot || !inventory_slot.item : return
		
	item_visual.visible = true
	item_visual.texture = inventory_slot.item.texture
	if inventory_slot.amount >1:
		amount_text.visible = true
		amount_text.text = str(inventory_slot.amount)
	else:
		amount_text.visible = false	
