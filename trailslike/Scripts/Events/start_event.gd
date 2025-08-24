extends Control

@onready var npc_section: Control = $NPCSection
@onready var main_section: Control = $"1stSection"
@onready var npc_1: Control = $NPCSection/Npc1
@onready var npc_2: Control = $NPCSection/Npc2
@onready var npc_3: Control = $NPCSection/Npc3
@onready var buttons: Control = $NPCSection/Buttons

func _ready() -> void:
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()


		
func _on_go_into_town_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/City/city_3.tscn")


func _on_ready_to_go_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Scenes/cordinate.tscn")

func _on_rest_pressed() -> void:
	pass # Replace with function body.

func _on_npc_pressed() -> void:
	npc_section.visible = true
	main_section.visible = false


func _on_done_pressed() -> void:
	npc_section.visible = false
	main_section.visible = true


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

func _on_talk_pressed() -> void:
	buttons.visible = false
	if npc_1.visible == true:
		$NPCSection/Npc1/EventNPC1.visible = true
	elif npc_2.visible:
		$NPCSection/Npc2/NPC2.visible = true
	elif npc_3.visible:
		$NPCSection/Npc3/npc3.visible = true
		
		
