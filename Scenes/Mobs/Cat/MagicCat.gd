extends Mob
class_name MagicCat

# Exported variable for the name of the dialogue.
@export var dialogue_name: String = "1"


func _ready() -> void:
	# Connect the signal_event signal from the Dialogic singleton to the dialogic_signal function.
	Dialogic.signal_event.connect(dialogic_signal)
	

# Function for handling when a body enters the chat area.
func _on_chat_area_body_entered(body: CharacterBody2D) -> void:
	# When Aurora enters the chat area, the dialog starts.
	if body.name == "Aurora":
		var layout = Dialogic.start(dialogue_name)
		# Adds the cat and Aurora as characters to the dialog
		layout.register_character(load("res://Dialogic/Characters/MagicCat.dch"), $".")
		layout.register_character(load("res://Dialogic/Characters/Aurora.dch"), body)


func dialogic_signal(name: String) -> void:
	if name == dialogue_name:
		$AnimationPlayer.play("Despawn")


func die() -> void:
	queue_free()
