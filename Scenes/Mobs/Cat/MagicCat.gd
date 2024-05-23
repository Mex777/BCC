extends "res://Scenes/Reusables/Mob/Mob.gd"

# Exported variable for the name of the dialogue.
@export var dialogue_name = "1"


func _ready():
	# Connect the signal_event signal from the Dialogic singleton to the dialogic_signal function.
	Dialogic.signal_event.connect(dialogic_signal)
	

# Function for handling when a body enters the chat area.
func _on_chat_area_body_entered(body):
	# When Aurora enters the chat area, the dialog starts.
	if body.name == "Aurora":
		var layout = Dialogic.start(dialogue_name)
		# Adds the cat and Aurora as characters to the dialog
		layout.register_character(load("res://Dialogic/Characters/MagicCat.dch"), $".")
		layout.register_character(load("res://Dialogic/Characters/Aurora.dch"), body)


func dialogic_signal(name):
	if name == dialogue_name:
		$AnimationPlayer.play("Despawn")


func die():
	queue_free()
