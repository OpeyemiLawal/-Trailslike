extends Area2D

@onready var conversation_ui: CanvasLayer = $ConversationUI
@onready var conversation_1: Control = $ConversationUI/Conversation/Conversation1
@onready var conversation_2: Control = $ConversationUI/Conversation/Conversation2
@onready var tradingUI: Control = $ConversationUI/Trading
@onready var conversationUI: Control = $ConversationUI/Conversation
@onready var qtyDropdrown: OptionButton = $ConversationUI/Trading/UI/column1/QtyOption
@onready var item_dropdown: OptionButton = $ConversationUI/Trading/UI/column1/ItemDropdown
@onready var item_price: Label = $ConversationUI/Trading/UI/Price
@onready var player_price: Label = $ConversationUI/Trading/UI/PlayerPrice
@onready var item_price_label: Label = $ConversationUI/ItemPriceLabel

@export var hover_cursor: Texture2D

var current_npc_id := "npc1"  
var current_item_data := {}
var current_price_keys: Array = []
var current_price_index: int = 0


func _ready() -> void:
	GameState.npc2_stock()
	_populate_items()

	# Connect signals
	item_dropdown.item_selected.connect(_on_item_selected)
	qtyDropdrown.item_selected.connect(_on_quantity_selected)
	GameState.connect("inventory_changed", Callable(self, "_refresh_ui"))  # auto-refresh when GameState changes


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

func _on_trade_pressed() -> void:
	conversationUI.visible = false
	tradingUI.visible = true


# ---------------- Populate Items ----------------
func _populate_items() -> void:
	item_dropdown.clear()
	var stock = GameState.npc_stocks.get(current_npc_id, [])
	for item in stock:
		item_dropdown.add_item(item["name"])
	
	if stock.size() > 0:
		current_item_data = stock[0]
		current_price_keys = current_item_data["prices"].keys()
		current_price_index = 0
		_populate_quantity(current_item_data["quantity"])
		_update_item_price()

# ---------------- Populate Quantity ----------------
func _populate_quantity(max_quantity: int) -> void:
	qtyDropdrown.clear()
	for i in range(1, max_quantity + 1):
		qtyDropdrown.add_item(str(i))

# ---------------- Item Selection ----------------
func _on_item_selected(index: int) -> void:
	var stock = GameState.npc_stocks.get(current_npc_id, [])
	if index < 0 or index >= stock.size():
		return
	
	current_item_data = stock[index]
	current_price_keys = current_item_data["prices"].keys()
	current_price_index = 0
	_update_item_price()
	_populate_quantity(current_item_data["quantity"])

func _on_quantity_selected(index: int) -> void:
	if index < 0:
		return
	_update_item_price()

# ---------------- Haggle ----------------
func _on_haggle_pressed() -> void:
	if current_price_keys.is_empty():
		return
	current_price_index = (current_price_index + 1) % current_price_keys.size()
	_update_item_price()

# ---------------- Update Price ----------------
func _update_item_price() -> void:
	if current_item_data.is_empty():
		return

	var qty := 1
	if qtyDropdrown.selected >= 0:
		qty = int(qtyDropdrown.get_item_text(qtyDropdrown.selected))

	var price_key: String = str(current_price_keys[current_price_index])
	var unit_price = current_item_data["prices"].get(price_key, 1)
	var total_price = unit_price * qty

	# --- NPC offer ---
	if price_key == "$":
		item_price.text = str(total_price) + " $"
	else:
		item_price.text = str(total_price) + " " + str(price_key)

	# --- Player balance ---
	var player_balance = GameState.cash if price_key == "$" else GameState.inventory.get(price_key, 0)
	if price_key == "$":
		player_price.text = "You have: " + str(GameState.cash) + " $"
	else:
		player_price.text = "You have: " + str(player_balance) + " " + price_key

# ---------------- Buy Item ----------------
func _on_buy_item_pressed() -> void:
	if current_item_data.is_empty():
		item_price_label.text = "Select an item first."
		return

	var qty := 1
	if qtyDropdrown.selected >= 0:
		qty = int(qtyDropdrown.get_item_text(qtyDropdrown.selected))

	var price_key: String = str(current_price_keys[current_price_index])
	var unit_price := int(current_item_data["prices"].get(price_key, 1))
	var total_cost := unit_price * qty

	var npc_have := int(current_item_data["quantity"])
	if qty > npc_have:
		item_price_label.text = "Not enough stock!"
		_refresh_ui()
		return

	var player_has := GameState.cash if price_key == "$" else int(GameState.inventory.get(price_key, 0))
	if player_has < total_cost:
		item_price_label.text = "Not enough %s!" % price_key
		_refresh_ui()
		return

	# Deduct payment
	if price_key == "$":
		GameState.change_cash(-total_cost)
	else:
		GameState.inventory[price_key] = int(GameState.inventory.get(price_key, 0)) - total_cost
		GameState.emit_signal("inventory_changed")

	# Add purchased items
	var item_name := String(current_item_data["name"])
	GameState.inventory[item_name] = int(GameState.inventory.get(item_name, 0)) + qty
	GameState.emit_signal("inventory_changed")

	# Reduce NPC stock
	current_item_data["quantity"] = npc_have - qty

	# Save instantly
	SaveManager.save_game()


	# Refresh UI
	_refresh_ui()
	item_price_label.text = "Bought %s x%d (paid %d %s)" % [item_name, qty, total_cost, price_key]


func _refresh_ui() -> void:
	_update_item_price()
	if not current_item_data.is_empty():
		_populate_quantity(int(current_item_data["quantity"]))


func _on_no_pressed() -> void:
	conversation_ui.visible = false
	conversationUI.visible = true
	tradingUI.visible = false
