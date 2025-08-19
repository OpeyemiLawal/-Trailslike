extends Control

@export var hover_cursor: Texture2D
@export var hover_cursor2: Texture2D

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_change_city_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_1.tscn")

func _on_change_city_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")

func _on_change_city_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)

func _on_change_city_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_change_city2_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)

func _on_change_city2_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_entrance_mouse_entered() -> void:
	if hover_cursor2:
		Input.set_custom_mouse_cursor(hover_cursor2)

func _on_entrance_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)

func _on_entrance_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/Scenes/oldStoreFront.tscn")


func _on_entrance_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/Scenes/town_square.tscn")
func _on_entrance_2_mouse_entered() -> void:
	if hover_cursor2:
		Input.set_custom_mouse_cursor(hover_cursor2)

func _on_entrance_2_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
