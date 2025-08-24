extends Control

@onready var save_list: VBoxContainer = $SaveList

func _ready() -> void:
	_populate_save_buttons()

func _populate_save_buttons() -> void:
	# Clear old buttons
	for child in save_list.get_children():
		child.queue_free()
	
	var dir = DirAccess.open("user://saves")
	if dir:
		dir.list_dir_begin()
		var filename = dir.get_next()
		while filename != "":
			if filename.ends_with(".save"):
				var save_path = "user://saves/" + filename
				var save_data = FileAccess.open(save_path, FileAccess.READ)
				if save_data:
					var data = JSON.parse_string(save_data.get_as_text())
					if typeof(data) == TYPE_DICTIONARY and data.has("player_name"):
						var btn := Button.new()
						btn.text = data["player_name"]
						btn.custom_minimum_size = Vector2(50, 50)
						# Bind both player_name + save_path
						btn.pressed.connect(_on_save_button_pressed.bind(data["player_name"], save_path))
						save_list.add_child(btn)
			filename = dir.get_next()
		dir.list_dir_end()
	else:
		var no_saves := Label.new()
		no_saves.text = "No saved games found."
		save_list.add_child(no_saves)


func _on_save_button_pressed(player_name: String, save_path: String) -> void:
	# Load using player name (not raw path)
	if SaveManager.load_game(player_name):
		# Store the selected path so overwrite works later
		GameState.current_save_path = save_path

		# Always go through prologue first
		# Prologue will check GameState.loaded_from_save
		# If true, it skips intro and jumps to last_scene
		get_tree().change_scene_to_file("res://Scenes/GUI/prologue.tscn")
	else:
		print("Failed to load save file: ", save_path)


func _on_back_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/menu.tscn")
