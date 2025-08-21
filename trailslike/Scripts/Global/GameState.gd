extends Node

signal inventory_changed  # 🔔 Emitted whenever inventory changes

# ---------------- Player Info ----------------
var player_name: String
var start_month: String
var start_year: int
var profession: String
var cash: int = 0
var accompanies: Array = []

# ---------------- Player Inventory ----------------
var inventory: Dictionary = {}   # Holds $ + items

# ---------------- Save Info ----------------
var last_scene: String = ""           
var current_save_path: String = ""     
var loaded_from_save: bool = false     

# ---------------- NPC Stocks ----------------
var npc_stocks: Dictionary = {}  # Holds all NPC inventories

# ---------------- Notifications ----------------
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if get_tree().current_scene:
			GameState.last_scene = get_tree().current_scene.scene_file_path
		
		if GameState.current_save_path != "":
			SaveManager.save_game()
		else:
			SaveManager.save_game()
		
		get_tree().quit()

# ---------------- Cash Management ----------------
func change_cash(amount: int):
	cash += amount
	inventory["$"] = cash  # keep inventory cash in sync
	emit_signal("inventory_changed")

	# Auto-save
	if current_save_path != "":
		SaveManager.save_game()
	else:
		SaveManager.save_game()

# ---------------- Initialize Player Inventory ----------------
func init_inventory() -> void:
	if inventory.size() == 0:  # Only initialize once
		inventory["$"] = cash
		var all_items = ["Blanket", "Potion", "Sword", "Apple", "Shield", "Water", "Herbs", "Arrow", "Boots", "Map"]
		for item in all_items:
			inventory[item] = 0

# ---------------- Inventory Management ----------------
func add_item(item_name: String, qty: int) -> void:
	if not inventory.has(item_name):
		inventory[item_name] = 0
	inventory[item_name] += qty
	emit_signal("inventory_changed")
	_save_if_needed()

func remove_item(item_name: String, qty: int) -> void:
	if not inventory.has(item_name):
		return
	inventory[item_name] = max(0, inventory[item_name] - qty)
	emit_signal("inventory_changed")
	_save_if_needed()

# ---------------- NPC Stock ----------------
func npc1_stock() -> void:
	if "npc1" not in npc_stocks:
		# Load from JSON (already created separately)
		var file = FileAccess.open("res://Data/npc1.json", FileAccess.READ)
		if file:
			var stock_data = JSON.parse_string(file.get_as_text())
			if typeof(stock_data) == TYPE_ARRAY:
				npc_stocks["npc1"] = stock_data

func npc2_stock() -> void:
	if "npc1" not in npc_stocks:
		# Load from JSON (already created separately)
		var file = FileAccess.open("res://Data/npc2.json", FileAccess.READ)
		if file:
			var stock_data = JSON.parse_string(file.get_as_text())
			if typeof(stock_data) == TYPE_ARRAY:
				npc_stocks["npc1"] = stock_data

func reduce_npc_stock(npc_id: String, item_name: String, qty: int) -> void:
	if not npc_stocks.has(npc_id):
		return
	for item in npc_stocks[npc_id]:
		if item["name"] == item_name:
			item["quantity"] = max(0, item["quantity"] - qty)
			_save_if_needed()
			break

# ---------------- Helpers ----------------
func _save_if_needed() -> void:
	if current_save_path != "":
		SaveManager.save_game()
	else:
		SaveManager.save_game()
