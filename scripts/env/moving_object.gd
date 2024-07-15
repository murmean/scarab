extends Node3D

@onready var path_follow_3d = $Path3D/PathFollow3D

@export var move_time: float = 10

var b_is_toggled: bool = false
var direction: float = 1
var tween: Tween

func toggle(body) -> void:
	if !b_is_toggled:
		tween = get_tree().create_tween()
		tween.tween_property(self, "b_is_toggled", true, 0.0)
		tween.tween_property(path_follow_3d, "progress_ratio", direction, move_time)
		tween.tween_property(self, "b_is_toggled", false, 0.0)
		direction = 0.0 if direction == 1.0 else 1.0
