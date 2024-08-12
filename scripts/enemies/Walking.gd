extends State
class_name EnemyWalk
@export var base_enemy: BaseEnemy

@onready var label_3d = %Label3D

func state_enter():
	label_3d.text = "state is walk"
	base_enemy.set_physics_process(true)

func _on_area_3d_body_exited(body):
	transitioned.emit(self,'walk')
