extends Control

@onready var timer: Timer = $Timer

# Preload all event scenes into an array
var event_scenes: Array[PackedScene] = [
	preload("res://Scenes/Events/event_1.tscn"),
	preload("res://Scenes/Events/event_2.tscn"),
	preload("res://Scenes/Events/event_3.tscn"),
	preload("res://Scenes/Events/event_4.tscn"),
	preload("res://Scenes/Events/event_5.tscn")
]

func _ready() -> void:
	timer.start()
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()

func _on_timer_timeout() -> void:
	# Pick a random index from 0 to event_scenes.size() - 1
	var random_index = randi() % event_scenes.size()
	var chosen_scene = event_scenes[random_index]
	
	get_tree().change_scene_to_packed(chosen_scene)
