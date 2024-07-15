class_name ObjectPosition
extends Marker3D

var obj
var pull_power = 1
@onready var timer = $Timer
var hold = true
@onready var interaction_ray_cast = $"../InteractionRayCast"

func _process(delta):
	if obj:
		var a = obj.global_transform.origin
		var b = global_transform.origin
		obj.set_linear_velocity((b - a) * pull_power)
		if Input.is_action_just_pressed("interact") && !hold:
			drop()

func pick(body) -> void:
	obj = body
	pull_power = body.pull_power
	timer.start()
	hold = true
	interaction_ray_cast.disable = true

func drop() -> void:
	interaction_ray_cast.disable = false
	obj = null

func _on_timer_timeout() -> void:
	hold = false
