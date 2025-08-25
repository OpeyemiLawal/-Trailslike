extends Control

@onready var describtion: Control = $MainSection/Describtion
@onready var debug_label: Label = $DebugLabel
@onready var npc_section: Control = $NPCSection
@onready var main_section: Control = $MainSection
@onready var buttons: Control = $NPCSection/Buttons
@onready var npc_1: Control = $NPCSection/Npc1
@onready var npc_2: Control = $NPCSection/Npc2
@onready var npc_3: Control = $NPCSection/Npc3
@onready var rest_ui: Control = $RestUI

func _ready() -> void:
	randomize()
	Input.set_custom_mouse_cursor(null)
	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Events/start_event.tscn")

func _on_describtion_pressed() -> void:
	describtion.visible = true

func _on_close_pressed() -> void:
	describtion.visible = false

func _on_rest_pressed() -> void:
	rest_ui.visible = true

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

func _on_action_pressed() -> void:
	var chance := randf() # Random between 0.0 - 1.0

	if chance <= 0.2:
		debug_label.text = "Successful! Didn't lose anything"
	else:
		if GameState.inventory.has("Blanket") and GameState.inventory["Blanket"] > 0:
			GameState.inventory["Blanket"] -= 1
			debug_label.text = "Failed! Lost 1 Blanket"
		else:
			if GameState.inventory.has("$"):
				GameState.inventory["$"] = max(GameState.inventory["$"] - 5, 0)
			debug_label.text = "Failed! No Blankets left, lost $5"

	# ✅ Mark this event as visited
	if not GameState.visited_events.has(GameState.last_scene):
		GameState.visited_events.append(GameState.last_scene)

	# ✅ Save state and return to coordinate scene
	GameState.last_scene = "res://Scenes/Scenes/cordinate.tscn"
	SaveManager.save_game()

	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Scenes/cordinate.tscn")
