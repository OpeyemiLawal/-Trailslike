extends Control

@onready var event_npc_1: Control = $"."
@onready var conversation_ui: Control = $Conversation
@onready var conversation_1_ui: Control = $Conversation/Conversation1
@onready var conversation_2_ui: Control = $Conversation/Conversation2
@onready var tradingUI: Control = $Trading
@onready var qtyDropdrown: OptionButton = $Trading/UI/column1/QtyOption
@onready var item_dropdown: OptionButton = $Trading/UI/column1/ItemDropdown
@onready var item_price: Label = $Trading/UI/Price
@onready var player_price: Label = $Trading/UI/PlayerPrice
@onready var item_price_label: Label = $Trading/ItemPriceLabel
@onready var timer: Timer = $Trading/Timer
@onready var buttons: Control = $"../../Buttons"
@onready var event_npc: Control = $"."

var npc_id: String = "npc3"
var current_item_data: Dictionary = {}
var current_price_keys: Array = []   # generic array to avoid type mismatch
var current_price_index: int = 0

@export var stock_file: String = "res://Data/EventsNPC/npc2.json"

func _ready() -> void:
	conversation_1_ui.visible = true
	GameState.load_npc_stock(npc_id, stock_file)
	_populate_items()
	item_dropdown.item_selected.connect(_on_item_selected)
	qtyDropdrown.item_selected.connect(_on_quantity_selected)
	GameState.connect("inventory_changed", Callable(self, "_refresh_ui"))

func _on_more_pressed() -> void:
	conversation_1_ui.visible = false
	conversation_2_ui.visible = true

func _on_quit_pressed() -> void:
	buttons.visible = true
	event_npc.visible = false

func _on_advice_pressed() -> void:
	print("Advice to be giving")


func _on_pardon_pressed() -> void:
	pass # Replace with function body.


func _on_trade_pressed() -> void:
	tradingUI.visible = true
	conversation_2_ui.visible = false

# --- Items ---
func _populate_items() -> void:
	item_dropdown.clear()
	var stock: Array = GameState.npc_stocks.get(npc_id, [])
	if stock.is_empty():
		current_item_data.clear()
		item_price.text = ""
		player_price.text = ""
		return

	for item in stock:
		item_dropdown.add_item(item["name"])

	_set_current_item(0)

func _set_current_item(index: int) -> void:
	var stock: Array = GameState.npc_stocks.get(npc_id, [])
	if index < 0 or index >= stock.size():
		return
	current_item_data = stock[index]
	current_price_keys = current_item_data.get("prices", {}).keys().duplicate()
	current_price_index = 0
	_populate_quantity(int(current_item_data.get("quantity", 0)))
	_update_item_price()

func _populate_quantity(max_quantity: int) -> void:
	qtyDropdrown.clear()
	for i in range(1, max_quantity + 1):
		qtyDropdrown.add_item(str(i))
	if max_quantity > 0:
		qtyDropdrown.select(0)

# --- Selection ---
func _on_item_selected(index: int) -> void:
	_set_current_item(index)

func _on_quantity_selected(index: int) -> void:
	_update_item_price()

# --- Haggle ---
func _on_haggle_pressed() -> void:
	if current_price_keys.is_empty():
		return
	current_price_index = (current_price_index + 1) % current_price_keys.size()
	_update_item_price()

# --- Price Update ---
func _update_item_price() -> void:
	if current_item_data.is_empty() or current_price_keys.is_empty():
		return

	var qty: int = 1
	if qtyDropdrown.selected >= 0:
		qty = int(qtyDropdrown.get_item_text(qtyDropdrown.selected))

	var price_key: String = str(current_price_keys[current_price_index])
	var unit_price: float = float(current_item_data["prices"].get(price_key, 1))
	var total_price: float = unit_price * qty

	item_price.text = "%d %s" % [total_price, (price_key if price_key != "$" else "$")]

	var player_balance: float = GameState.cash if price_key == "$" else float(GameState.inventory.get(price_key, 0))
	player_price.text = "You have: %d %s" % [player_balance, (price_key if price_key != "$" else "$")]

# --- Buy ---
func _on_buy_item_pressed() -> void:
	timer.start()
	item_price_label.visible = true

	if current_item_data.is_empty():
		item_price_label.text = "Select an item first."
		return

	var qty: int = 1
	if qtyDropdrown.selected >= 0:
		qty = int(qtyDropdrown.get_item_text(qtyDropdrown.selected))

	var price_key: String = str(current_price_keys[current_price_index])
	var unit_price: float = float(current_item_data["prices"].get(price_key, 1))
	var total_cost: float = unit_price * qty

	var npc_have: int = int(current_item_data.get("quantity", 0))
	if qty > npc_have:
		item_price_label.text = "Not enough stock!"
		_refresh_ui()
		return

	var player_has: float = GameState.cash if price_key == "$" else float(GameState.inventory.get(price_key, 0))
	if player_has < total_cost:
		item_price_label.text = "Not enough %s!" % price_key
		_refresh_ui()
		return

	# Pay
	if price_key == "$":
		GameState.change_cash(-total_cost)
	else:
		GameState.inventory[price_key] = max(0, int(GameState.inventory.get(price_key, 0)) - total_cost)
		GameState.emit_signal("inventory_changed")

	# Add item
	var item_name: String = current_item_data["name"]
	GameState.inventory[item_name] = int(GameState.inventory.get(item_name, 0)) + qty
	GameState.emit_signal("inventory_changed")

	# Reduce NPC stock
	current_item_data["quantity"] = npc_have - qty
	var stock: Array = GameState.npc_stocks.get(npc_id, [])
	var index := stock.find(current_item_data)
	if index != -1:
		stock[index] = current_item_data
	GameState.npc_stocks[npc_id] = stock

	SaveManager.save_game()

	_refresh_ui()
	item_price_label.text = "Bought %s x%d (paid %d %s)" % [item_name, qty, total_cost, price_key]

# --- UI Refresh ---
func _refresh_ui() -> void:
	if not current_item_data.is_empty():
		_populate_quantity(int(current_item_data.get("quantity", 0)))
		_update_item_price()

func _on_no_pressed() -> void:
	event_npc.visible = false
	buttons.visible = true

func _on_timer_timeout() -> void:
	item_price_label.visible = false


func _on_yes_pressed() -> void:
	pass # Replace with function body.
