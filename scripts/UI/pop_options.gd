extends Control

@export var options_page: PackedScene



func _on_options_btn_pressed():
	get_tree().change_scene_to_packed(options_page)


func _on_exit_btn_pressed():
	get_tree().quit()
