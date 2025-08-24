extends Control

@export var hover_cursor: Texture2D
@export var hover_cursor2: Texture2D
var inventory_ui_opened = false
@onready var inventory_ui: CanvasLayer = $inv_ui

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()	
		
func _on_change_city_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_1.tscn")

func _on_change_city_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_3.tscn")

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

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory") and inventory_ui_opened == false:
		inventory_ui.visible = true
		inventory_ui_opened = true
	elif Input.is_action_just_pressed("Inventory") and inventory_ui_opened == true:
		inventory_ui.visible = false
		inventory_ui_opened = false
