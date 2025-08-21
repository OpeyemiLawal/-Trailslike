extends Control


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/character_creation_screen.tscn")


func _on_load_game_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/load_game.tscn")


func _on_quick_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/inventory.tscn")
