extends Control

@export var hover_cursor: Texture2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_change_city_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")

func _on_change_city_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)

func _on_change_city_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
