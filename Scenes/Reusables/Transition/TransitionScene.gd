extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer
@onready var text = $Label

func _ready():
	color_rect.visible = false
	text.visible = false
	
func transition(message):
	color_rect.visible = true
	text.visible = true
	text.text = message
	animation_player.play("FadeIn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeIn":
		on_transition_finished.emit()
		animation_player.play("FadeOut")
	elif anim_name == "FadeOut":
		color_rect.visible = false
		text.visible = false
