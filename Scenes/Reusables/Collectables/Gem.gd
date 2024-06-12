extends Node2D

@export var cooldown_duration: int = 60
@export var amount: int = 10

var in_cooldown: bool = false

func _on_enter_box_body_entered(body) -> void:
	if body.name == "Aurora" and not in_cooldown:
		in_cooldown = true
		Game.add_coins(amount)
		$AnimatedSprite2D.hide()
		await get_tree().create_timer(cooldown_duration).timeout
		in_cooldown = false
		$AnimatedSprite2D.show()
		
