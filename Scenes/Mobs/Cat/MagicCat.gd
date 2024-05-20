extends "res://Scenes/Reusables/Mob/Mob.gd"

@export var dialogue_name = "Start"

func _ready():
	Dialogic.signal_event.connect(dialogic_signal)
	
func _on_chat_area_body_entered(body):
	if body.name == "Aurora":
		var layout = Dialogic.start(dialogue_name)
		layout.register_character(load("res://Dialogic/Characters/MagicCat.dch"), $".")
		layout.register_character(load("res://Dialogic/Characters/Aurora.dch"), body)
		
func dialogic_signal(name):
	if name == dialogue_name:
		$AnimationPlayer.play("Despawn")

func die():
	queue_free()
