extends Control

@onready var prologue_label: Label = $PrologueText
@onready var timer: Timer = $Timer

var profession_flavor := {
	"Banker": "As a wealthy banker, your fortune of ${cash} gives you a comfortable start, though many whisper that money alone won’t keep you alive on the trail.",
	"Soldier": "Your training as a soldier may prepare you for hardships, but with only ${cash} to your name, the trail will test your endurance and grit.",
	"Farmer": "As a humble farmer, your ${cash} savings aren’t much, but your resilience and practical skills may prove invaluable in the wilderness."
}

func _on_timer_timeout() -> void:
	if GameState.loaded_from_save and GameState.last_scene != "":
		get_tree().change_scene_to_file(GameState.last_scene)
	else:
		get_tree().change_scene_to_file("res://Scenes/City/city_1.tscn")

func _ready() -> void:
	timer.start()
	var year_text = "In the year " + str(GameState.start_year) + ", "
	var name_text = GameState.player_name + " began the journey westward."
	
	var base_text = ""
	if GameState.profession in profession_flavor:
		base_text = profession_flavor[GameState.profession]
	else:
		base_text = "With ${cash} to your name, you set out for Oregon with uncertain hopes."
	
	# Replace ${cash} dynamically
	base_text = base_text.replace("${cash}", str(GameState.cash))
	
	# Combine final text
	var prologue_text = year_text + "\n\n" + name_text + "\n\n" + base_text
	
	# Add companions if any
	if GameState.accompanies.size() > 0:
		var comp_list = []
		for c in GameState.accompanies:
			comp_list.append(c.name + " (" + str(c.age) + ")")
		prologue_text += "\n\nTraveling with you are: " + ", ".join(comp_list) + "."

	# Format into neat readable lines (≈ 10 words per line)
	prologue_label.text = wrap_text_by_words(prologue_text, 10)

func wrap_text_by_words(text: String, max_words: int = 10) -> String:
	var words = text.split(" ")
	var lines = []
	var current_line = []
	
	for word in words:
		current_line.append(word)
		if current_line.size() >= max_words:
			lines.append(" ".join(current_line))
			current_line.clear()
	
	# Add leftovers
	if current_line.size() > 0:
		lines.append(" ".join(current_line))
	
	return "\n".join(lines)
