extends Control

@onready var timer: Timer = $Timer
@onready var coord_label: Label = $CoordLabel   # Label in the scene to show coordinates

# Preload all event scenes
var event_scenes: Array[String] = [
	"res://Scenes/Events/event_1.tscn",
	"res://Scenes/Events/event_2.tscn",
	"res://Scenes/Events/event_3.tscn",
	"res://Scenes/Events/event_4.tscn",
	"res://Scenes/Events/event_5.tscn"
]

# Player position and movement
var pos: Vector2 = Vector2.ZERO
var last_dir: Vector2 = Vector2.ZERO

func _ready() -> void:
	randomize()
	timer.start()
	Input.set_custom_mouse_cursor(null)

	# Restore position if saved
	if GameState.position != Vector2.ZERO:
		pos = GameState.position
	else:
		GameState.position = pos

	if get_tree().current_scene:
		GameState.last_scene = get_tree().current_scene.scene_file_path
		SaveManager.save_game()

	_update_coord_label()

func _on_timer_timeout() -> void:
	# Move to a new coordinate
	var new_pos = random_grid_step()
	pos = new_pos
	GameState.position = pos  # Save latest position
	SaveManager.save_game()
	_update_coord_label()

	# Choose an unvisited event
	var unvisited = []
	for path in event_scenes:
		if not GameState.visited_events.has(path):
			unvisited.append(path)

	if unvisited.is_empty():
		coord_label.text = "Coordinates: (%d, %d) - All events completed!" % [pos.x, pos.y]
		timer.stop()
		return

	var chosen_scene = unvisited[randi() % unvisited.size()]
	get_tree().change_scene_to_file(chosen_scene)

func random_grid_step() -> Vector2:
	var distance = randi_range(1, 5)

	var directions = [
		Vector2(0, 1),  # North
		Vector2(0, -1), # South
		Vector2(1, 0),  # East
		Vector2(-1, 0)  # West
	]

	# Exclude opposite of last_dir
	if last_dir != Vector2.ZERO:
		var opposite = -last_dir
		directions.erase(opposite)

	# Pick new direction
	var dir = directions[randi() % directions.size()]
	last_dir = dir
	return pos + dir * distance

func _update_coord_label() -> void:
	coord_label.text = "Coordinates: (%d, %d)" % [pos.x, pos.y]
