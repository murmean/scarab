extends RayCast3D

@onready var prompt = $Prompt
var disable = false

func _process(delta) -> void:
	prompt.text = ""
	
	if is_colliding() && !disable:
		var collider = get_collider()
		if collider is Interactable:
			prompt.text = collider.get_prompt()
			if Input.is_action_just_pressed(collider.input):
				collider.interact(owner)
		if collider is InteractablePhysicsObject:
			prompt.text = collider.get_prompt()
			if Input.is_action_just_pressed(collider.input):
				collider.interact($"../ObjectPosition")
