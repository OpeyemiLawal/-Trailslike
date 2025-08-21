extends Node2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_overwrite()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")
