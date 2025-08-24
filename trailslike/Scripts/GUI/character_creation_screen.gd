extends Control

@onready var nameInput: LineEdit = $"Name section/NameInput"
@onready var monthDropdown: OptionButton = $"Date Section/Month"
@onready var yearDropdown: OptionButton = $"Date Section/Year"
@onready var name_container: VBoxContainer = $Accompanies/accompanyNameContainer
@onready var count_dropdown: OptionButton = $Accompanies/count_dropdown
@onready var start_button: Button = $Start

# New nodes for job + cash
@onready var job_dropdown: OptionButton = $"Job Selection/job_dropdown"
@onready var cash_label: Label = $"Job Selection/cash_label"

# Job → Cash mapping
var jobs := {
	"Banker": 2000,
	"Soldier": 1500,
	"Farmer": 1000
}

func _ready() -> void:
	_populate_months()
	_populate_years()
	_populate_jobs()

	# Disable button by default
	start_button.disabled = true

	# Connect signals
	nameInput.text_changed.connect(_on_fields_changed)
	count_dropdown.item_selected.connect(_on_count_changed)
	job_dropdown.item_selected.connect(_on_job_selected)

	# Initialize with first job
	_on_job_selected(job_dropdown.selected)

func _populate_months() -> void:
	var months := [
		"January", "February", "March", "April",
		"May", "June", "July", "August",
		"September", "October", "November", "December"
	]
	monthDropdown.clear()
	for m in months:
		monthDropdown.add_item(m)

func _populate_years() -> void:
	var years := [
		"2015", "2016", "2017", "2018",
		"2019", "2020", "2021", "2022",
		"2023", "2024", "2025", "2026"
	]
	yearDropdown.clear()
	for y in years:
		yearDropdown.add_item(y)

	# Populate the count dropdown
	for i in range(0, 6): # allows 0–5 accompanies
		count_dropdown.add_item(str(i))

func _populate_jobs() -> void:
	job_dropdown.clear()
	for j in jobs.keys():
		job_dropdown.add_item(j)

func _on_count_changed(index: int) -> void:
	var num := int(count_dropdown.get_item_text(index))
	_generate_name_fields(num)

func _generate_name_fields(amount: int) -> void:
	# Clear old fields
	for child in name_container.get_children():
		child.queue_free()

	# Add rows with LineEdit + Label + OptionButton
	for i in range(amount):
		var row := HBoxContainer.new()
		row.custom_minimum_size = Vector2(500, 50)

		var name_field := LineEdit.new()
		name_field.placeholder_text = "Accompany " + str(i + 1) + " name"
		name_field.custom_minimum_size = Vector2(165, 55)
		name_field.text_changed.connect(_on_fields_changed) # important so button updates live

		var age_label := Label.new()
		age_label.text = ", age"
		age_label.custom_minimum_size = Vector2(50, 50)

		var age_dropdown := OptionButton.new()
		age_dropdown.custom_minimum_size = Vector2(80, 50)
		for age in range(10, 21): # 10–20 inclusive
			age_dropdown.add_item(str(age))

		row.add_child(name_field)
		row.add_child(age_label)
		row.add_child(age_dropdown)

		name_container.add_child(row)

func _on_fields_changed(_new_text: String = "") -> void:
	# Check main name
	if nameInput.text.strip_edges() == "":
		start_button.disabled = true
		return

	# Check all accompany LineEdits inside HBoxContainers
	for row in name_container.get_children():
		for child in row.get_children():
			if child is LineEdit and child.text.strip_edges() == "":
				start_button.disabled = true
				return

	# If all are valid
	start_button.disabled = false

func _on_job_selected(index: int) -> void:
	var job := job_dropdown.get_item_text(index)
	var cash: int = jobs[job]
	cash_label.text = "Starting Cash: $" + str(cash)

func _process(delta: float) -> void:
	if count_dropdown.selected == 0 :
		start_button.disabled = true

func _on_start_pressed() -> void:
	GameState.player_name = nameInput.text
	GameState.start_month = monthDropdown.get_item_text(monthDropdown.selected)
	GameState.start_year = int(yearDropdown.get_item_text(yearDropdown.selected))
	GameState.profession = job_dropdown.get_item_text(job_dropdown.selected)
	GameState.cash = jobs[GameState.profession]

	GameState.accompanies.clear()
	for row in name_container.get_children():
		var entry := {}
		for child in row.get_children():
			if child is LineEdit:
				entry["name"] = child.text
			elif child is OptionButton:
				entry["age"] = int(child.get_item_text(child.selected))
		GameState.accompanies.append(entry)

	# where a brand new game should continue after prologue
	GameState.last_scene = "res://Scenes/City/city_1.tscn"
	GameState.loaded_from_save = false
	GameState.current_save_path = ""       # force a new slot
	SaveManager.save_game()

	get_tree().change_scene_to_file("res://Scenes/GUI/prologue.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/GUI/menu.tscn")
