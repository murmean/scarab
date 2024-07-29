extends Node3D
@export var file :PackedScene
@export var player:BasePlayer

func change_scene(body):
	player.fade()
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_packed(file)
	
