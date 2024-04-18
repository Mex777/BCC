extends CharacterBody2D

var health = 10

func take_damage(damage: int):
	health = max(health - damage, 0)
	if health == 0:
		queue_free()
		
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
func _physics_process(delta):
	if Input.is_action_just_pressed("base_attack"):
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = false
	else:
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = true
