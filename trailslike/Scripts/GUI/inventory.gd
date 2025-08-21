extends Control

@onready var cash_label: Label = $InventoryList/CashLabel
@onready var items_list: VBoxContainer = $ItemsList

func _ready() -> void:
	# Connect to GameState signal
	GameState.connect("inventory_changed", Callable(self, "_update_inventory_display"))
	# Initial draw
	_update_inventory_display()

func _update_inventory_display() -> void:
	# Update cash
	cash_label.text = "Cash: " + str(GameState.cash) + " $"

	# Clear old items
	for child in items_list.get_children():
		child.queue_free()

	# Add each item from inventory (except $)
	for item_name in GameState.inventory.keys():
		if item_name == "$":
			continue
		var qty = GameState.inventory[item_name]
		var item_label := Label.new()
		item_label.text = item_name + ": " + str(qty)

		# Load the font
		var font: Font = load("res://Asset/Fonts/Oswald-Medium.ttf")

		# Apply per-control overrides
		if font:
			item_label.add_theme_font_override("font", font)
		item_label.add_theme_font_size_override("font_size", 20)
		item_label.add_theme_color_override("font_color", Color.BLACK)

		items_list.add_child(item_label)
