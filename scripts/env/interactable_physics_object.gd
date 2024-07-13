class_name InteractablePhysicsObject
extends Interactable

@export var pull_power: float = 1
var old_position: Vector3
var b_is_first_frame: bool = true
@export var speed_threshold: float = 0.001
var obj_position
@export var obj_health: float = 1

func _ready() -> void:
	old_position = global_position
	b_is_first_frame = false

func interact(body) -> void:
	if body is ObjectPosition:
		body.pick(self)
		obj_position = body

var distance: float
var b_is_breaking: bool = false

func _process(delta):
	if !b_is_first_frame:
		distance = global_position.distance_to(old_position)
		if distance > speed_threshold:
			var damage = pow(snapped(distance, 0.1) * 10, 2) / 10
			obj_health -= damage
		old_position = global_position


func _on_area_3d_body_entered(body):
	if obj_health <= 0:
		obj_position.drop()
		$MeshInstance3D.visible = false
		$CollisionShape3D.disabled = true
		$GPUParticles3D.emitting = true
		await get_tree().create_timer($GPUParticles3D.lifetime).timeout
		queue_free()
