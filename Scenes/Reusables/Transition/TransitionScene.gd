extends CanvasLayer

signal on_transition_finished

# Background color
@onready var color_rect = $ColorRect

@onready var animation_player = $AnimationPlayer
@onready var text = $Label


# By default the transition is invisible
func _ready() -> void:
	color_rect.visible = false
	text.visible = false
	

# Runs transition
func transition(message: String) -> void:
	color_rect.visible = true
	text.visible = true
	text.text = message
	animation_player.play("FadeIn")


func _on_animation_player_animation_finished(anim_name: String) -> void:
	# After fade in finishes we run fade out
	if anim_name == "FadeIn":
		on_transition_finished.emit()
		animation_player.play("FadeOut")
		
	# After fade out finishes we make the transition invisible
	elif anim_name == "FadeOut":
		color_rect.visible = false
		text.visible = false
