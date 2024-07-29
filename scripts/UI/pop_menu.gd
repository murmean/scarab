extends Control

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("pop_menu"):
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


func _on_button_pressed():
	get_tree().reload_current_scene()
