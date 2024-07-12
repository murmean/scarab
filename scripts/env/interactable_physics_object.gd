class_name InteractablePhysicsObject
extends Interactable

@export var pull_power: float = 1

func interact(body) -> void:
	if body is ObjectPosition:
		body.pick(self)
