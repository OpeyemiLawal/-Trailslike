extends Node

const SAVE_DIR := "user://saves/"
var visited_events: Array[String] = []

# ---------------- Ensure Save Directory ----------------
func _ensure_save_dir() -> void:
	if not DirAccess.dir_exists_absolute(SAVE_DIR):
		DirAccess.make_dir_absolute(SAVE_DIR)

func _get_save_path(player_name: String) -> String:
	# Replace spaces and sanitize filename
	var safe_name = player_name.strip_edges().replace(" ", "_")
	return SAVE_DIR + safe_name.to_lower() + ".save"

# ---------------- Build Save Payload ----------------
func _build_payload() -> Dictionary:
	return {
		"player_name": GameState.player_name,
		"start_month": GameState.start_month,
		"start_year": GameState.start_year,
		"current_day": GameState.current_day,
		"profession": GameState.profession,
		"cash": GameState.cash,
		"accompanies": GameState.accompanies,
		"last_scene": GameState.last_scene,
		"npc_stocks": GameState.npc_stocks,
		"inventory": GameState.inventory,
		"visited_events": GameState.visited_events
	}

# ---------------- Save Game ----------------
func save_game() -> void:
	_ensure_save_dir()
	var save_path = _get_save_path(GameState.player_name)
	GameState.current_save_path = save_path

	var file = FileAccess.open(save_path, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(_build_payload(), "\t"))
		file.close()

# ---------------- Load Game ----------------
func load_game(player_name: String) -> bool:
	var save_path = _get_save_path(player_name)
	if not FileAccess.file_exists(save_path):
		return false

	var file = FileAccess.open(save_path, FileAccess.READ)
	if not file:
		return false

	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)
	if result == null:
		return false

	# ✅ Restore into GameState
	GameState.player_name = result.get("player_name", "")
	GameState.start_month = result.get("start_month", "January")
	GameState.start_year = result.get("start_year", 1843)
	GameState.current_day = result.get("current_day", 1) 
	GameState.profession = result.get("profession", "Farmer")
	GameState.cash = result.get("cash", 1000)
	GameState.accompanies = result.get("accompanies", [])
	GameState.last_scene = result.get("last_scene", "res://Scenes/City/city_1.tscn")
	GameState.npc_stocks = result.get("npc_stocks", {})
	GameState.inventory = result.get("inventory", {})
	GameState.visited_events = result.get("visited_events", [])

	GameState.init_inventory() 
	GameState.current_save_path = save_path
	GameState.loaded_from_save = true

	return true
