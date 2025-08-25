extends Control

@onready var rest_days_dropdown: OptionButton = $RestDaysDropdown
@onready var rest_ui: Control = $"."

func _ready() -> void:
	rest_days_dropdown.clear()
	
	# Add options 1 to 5
	for i in range(1, 6):
		rest_days_dropdown.add_item(str(i))
		
func _on_rest_days_dropdown_item_selected(index: int) -> void:
	var selected_value = int(rest_days_dropdown.get_item_text(index))
	GameState.advance_day(selected_value)

	
	$RestUIDebugLabel.text = "You have rested for" + str(selected_value)+ " " +"Days" + "Current Date: %s %d, %d" % [
		GameState.start_month, GameState.current_day, GameState.start_year
	]

func _on_close_pressed() -> void:
	rest_ui.visible = false
