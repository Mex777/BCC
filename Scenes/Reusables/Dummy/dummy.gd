extends CharacterBody2D

var health:  = 10
var SPEED = 10
@export var stunned = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func take_damage(damage: int):
	health = max(health - damage, 0)
	if health == 0:
		queue_free()
		
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
	
func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false
	
	
func _physics_process(delta):
	if Input.is_action_just_pressed("base_attack"):
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = false
	else:
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = true
	
	velocity.x = SPEED
	if not stunned:
		get_node("AnimatedSprite2D").play("Run")
	else:
		get_node("AnimatedSprite2D").play("Idle")
	
	if not is_on_floor():
		velocity.y += gravity * delta
