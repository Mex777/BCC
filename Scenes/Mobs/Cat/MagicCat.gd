extends "res://Scenes/Reusables/Mob/Mob.gd"

@export var dialogue_name = "Start"
var player = null

func _ready():
	Dialogic.signal_event.connect(dialogic_signal)
	
func _on_chat_area_body_entered(body):
	if body.name == "Aurora":
		body.in_cutscene = true
		if dialogue_name == "0":
			await get_tree().create_timer(3).timeout
		player = body
		Dialogic.start(dialogue_name)
		
func dialogic_signal(name):
	if name == dialogue_name:
		$AnimationPlayer.play("Despawn")

func die():
	queue_free()
