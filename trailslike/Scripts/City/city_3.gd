extends Control

@export var hover_cursor: Texture2D
@export var hover_cursor2: Texture2D
@onready var debug_label: Label = $DebugLabel

func _on_exit_town_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var required := {
			"Apple": 1,
			"Blanket": 3,
			"Helmet": 2,
			"Sword": 2,
		}

		var missing_msgs: Array[String] = []

		for item_name in required.keys():
			var need := int(required[item_name])
			var have := _get_inv_qty_case_insensitive(item_name)
			if have < need:
				missing_msgs.append("You need %d more %s" % [need - have, item_name])

		if missing_msgs.is_empty():
			print("City exited ")
			get_tree().change_scene_to_file("res://Scenes/Events/start_event.tscn")
		else:
			var msg := ", ".join(missing_msgs)
			# Show it wherever you prefer; falls back to print if no label is present
			if has_node("DebugLabel"):
				debug_label.text = msg
			print(msg)

# Helper: fetch quantity regardless of key capitalization
func _get_inv_qty_case_insensitive(name: String) -> int:
	if GameState.inventory.has(name):
		return int(GameState.inventory[name])
	var lname := name.to_lower()
	for k in GameState.inventory.keys():
		if String(k).to_lower() == lname:
			return int(GameState.inventory[k])
	return 0


func _on_exit_town_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)


func _on_exit_town_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_change_city_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://Scenes/City/city_2.tscn")


func _on_change_city_mouse_entered() -> void:
	if hover_cursor2:
		Input.set_custom_mouse_cursor(hover_cursor2)

func _on_change_city_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
