extends Node2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")
