extends Area2D

@onready var conversation_ui: CanvasLayer = $ConversationUI
@onready var conversation_1: Control = $ConversationUI/Conversation/Conversation1
@onready var conversation_2: Control = $ConversationUI/Conversation/Conversation2
@export var hover_cursor: Texture2D

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed:
		conversation_ui.visible = true


func _on_advice_pressed() -> void:
	conversation_1.visible = false
	conversation_2.visible = true


func _on_quit_pressed() -> void:
	conversation_ui.visible = false
	conversation_1.visible = true
	conversation_2.visible = false


func _on_mouse_entered() -> void:
	if hover_cursor:
		Input.set_custom_mouse_cursor(hover_cursor)


func _on_mouse_exited() -> void:
	Input.set_custom_mouse_cursor(null)
