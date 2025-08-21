extends CanvasLayer

@export var npc_load_image: Texture2D
@export var NoOfConversation: int = 1   # how many conversations
@export var conversations: Array[String] = []   # store conversation texts

@onready var npc_image: Sprite2D = $Conversation/NPCImage
@onready var conversation_container: Control = $Conversation
@onready var label_holder: VBoxContainer = $Conversation/LabelHolder
@onready var conversation: Label = $Conversation/Conversation1/Conversation

func _ready() -> void:
	# set NPC image
	npc_image.texture = npc_load_image

	# ensure conversations array has enough slots
	while conversations.size() < NoOfConversation:
		conversations.append("")

	# create conversation controls dynamically
	for i in range(NoOfConversation):
		var conv = Control.new()
		conv.name = "Conversation" + str(i + 1)
		conv.custom_minimum_size = Vector2(642, 382)
		conversation_container.add_child(conv)

		# add a Label for the text
		var label = Label.new()
		label_holder.add_child(label)

		if i < conversations.size() and conversations[i] != "":
			var conversation1Label = Label.new()
			#conversation1Label.
			conversation1Label.text = format_conversation_text(conversations[i], 6)
		else:
			label.text = "Conversation " + str(i + 1)


func format_conversation_text(text: String, words_per_line: int = 6) -> String:
	var words = text.split(" ")
	var lines: Array[String] = []
	var current_line: Array[String] = []
	
	for i in range(words.size()):
		current_line.append(words[i])
		if current_line.size() >= words_per_line:
			lines.append(" ".join(current_line))
			current_line.clear()
	
	# add leftover words
	if current_line.size() > 0:
		lines.append(" ".join(current_line))
	
	return "\n".join(lines)
