extends Control

@onready var describtion: Control = $MainSection/Describtion
@onready var debug_label: Label = $DebugLabel
@onready var npc_section: Control = $NPCSection
@onready var main_section: Control = $MainSection
@onready var buttons: Control = $NPCSection/Buttons
@onready var npc_1: Control = $NPCSection/Npc1
@onready var npc_2: Control = $NPCSection/Npc2
@onready var npc_3: Control = $NPCSection/Npc3

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Events/start_event.tscn")


func _on_describtion_pressed() -> void:
	describtion.visible = true


func _on_close_pressed() -> void:
	describtion.visible = false


func _on_rest_pressed() -> void:
	debug_label.text = " Resting "


func _on_npc_pressed() -> void:
	main_section.visible = false
	npc_section.visible = true

func _on_talk_pressed() -> void:
	buttons.visible = false
	if npc_1.visible == true:
		$NPCSection/Npc1/EventNPC1.visible = true
	elif npc_2.visible:
		$NPCSection/Npc2/NPC2.visible = true
	elif npc_3.visible:
		$NPCSection/Npc3/npc3.visible = true

func _on_other_npc_pressed() -> void:
	if npc_1.visible:
		npc_1.visible = false
		npc_2.visible = true
	elif npc_2.visible:
		npc_2.visible = false
		npc_3.visible = true
	elif  npc_3.visible:
		npc_3.visible = false
		npc_1.visible = true

func _on_done_pressed() -> void:
	npc_section.visible = false
	main_section.visible = true
