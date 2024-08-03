extends State
class_name EnemyIdle
@export var base_enemy: BaseEnemy

@onready var label_3d = %Label3D


func state_enter():
	label_3d.text = "Idle"
	base_enemy.set_physics_process(false)
	


func _on_area_3d_body_entered(body):
	transitioned.emit(self,"walk")
