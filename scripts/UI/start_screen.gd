extends Control

#WHAT EACH BUTTON OPENS
@export var play_page: PackedScene
@export var options_page: PackedScene
@export var about_page: PackedScene



func _on_play_btn_pressed():
	get_tree().change_scene_to_packed(play_page)


func _on_options_btn_pressed():
	get_tree().change_scene_to_packed(options_page)


func _on_about_btn_pressed():
	get_tree().change_scene_to_packed(about_page)


func _on_exit_btn_pressed():
	get_tree().quit()
