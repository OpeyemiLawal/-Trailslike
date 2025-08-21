extends Control

@export var hover_cursor: Texture2D
@onready var inventory_ui: CanvasLayer = $inv_ui

var inventory_ui_opened = false

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()

		
	print("Amount of cash available is " + str(GameState.cash))
func _on_change_city_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")

func _on_change_city_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)

func _on_change_city_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_quick_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/inventory.tscn")

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Inventory") and inventory_ui_opened == false:
		inventory_ui.visible = true
		inventory_ui_opened = true
	elif Input.is_action_just_pressed("Inventory") and inventory_ui_opened == true:
		inventory_ui.visible = false
		inventory_ui_opened = false
