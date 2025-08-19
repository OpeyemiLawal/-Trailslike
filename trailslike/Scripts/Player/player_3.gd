extends Area2D

@onready var conversation_ui: CanvasLayer = $ConversationUI

@export var hover_cursor: Texture2D

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		conversation_ui.visible = true

func _on_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)


func _on_cancel_pressed() -> void:
	conversation_ui.visible = false

func _on_purchsase_pressed() -> void:
	conversation_ui.visible = false
