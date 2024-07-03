class_name Interactable
extends CollisionObject3D

signal interacted(body)

@export var prompt_message: String = "Interact"
@export var input: String = "interact"

func get_prompt() -> String:
	return prompt_message + "\n[" + input + "]"

func interact(body) -> void:
	interacted.emit(body)
