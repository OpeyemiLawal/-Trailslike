extends Node

signal inventory_changed

# ---------------- Player Info ----------------
var player_name: String = ""
var start_month: String
var start_year: int
var current_day: int = 1 
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

# ---------------- Events ----------------
var visited_events: Array = []   # Stores finished event scene paths

# ---------------- Coordinates ----------------
var position: Vector2 = Vector2.ZERO
var last_dir: Vector2 = Vector2.ZERO


# ---------------- Month Handling ----------------
var months: Array[String] = [
	"January", "February", "March", "April", "May", "June", 
	"July", "August", "September", "October", "November", "December"
]

var days_in_month: Dictionary = {
	"January": 31,
	"February": 28,
	"March": 31,
	"April": 30,
	"May": 31,
	"June": 30,
	"July": 31,
	"August": 31,
	"September": 30,
	"October": 31,
	"November": 30,
	"December": 31
}


# ---------------- Notifications ----------------
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		if get_tree().current_scene:
			GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()
		get_tree().quit()

# ---------------- Cash Management ----------------
func change_cash(amount: int):
	cash += amount
	inventory["$"] = cash
	emit_signal("inventory_changed")
	_save_if_needed()

# ---------------- Initialize Player Inventory ----------------
func init_inventory() -> void:
	if inventory.size() == 0:
		inventory["$"] = cash
		var all_items = ["Blanket", "Potion", "Sword", "Apple", "Shield", "Water", "Herbs", "Arrow", "Boots", "Map", "Helmet"]
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

# ---------------- NPC Stock Management ----------------
func load_npc_stock(npc_id: String, path: String) -> void:
	if not npc_stocks.has(npc_id):
		var file = FileAccess.open(path, FileAccess.READ)
		if file:
			var stock_data = JSON.parse_string(file.get_as_text())
			if typeof(stock_data) == TYPE_ARRAY:
				npc_stocks[npc_id] = stock_data

func reduce_npc_stock(npc_id: String, item_name: String, qty: int) -> void:
	if not npc_stocks.has(npc_id):
		return
	for item in npc_stocks[npc_id]:
		if item["name"] == item_name:
			item["quantity"] = max(0, item["quantity"] - qty)
			_save_if_needed()
			break

# ---------------- Calendar Helpers ----------------
func advance_day(days: int = 1) -> void:
	current_day += days
	var max_days = days_in_month[start_month]

	if current_day > max_days:
		current_day = 1
		_next_month()

func _next_month() -> void:
	var idx = months.find(start_month)
	if idx == -1:
		start_month = months[0] # fallback to January
	else:
		idx += 1
		if idx >= months.size():
			idx = 0
			start_year += 1
		start_month = months[idx]

	
# ---------------- Helpers ----------------
func _save_if_needed() -> void:
	SaveManager.save_game()
