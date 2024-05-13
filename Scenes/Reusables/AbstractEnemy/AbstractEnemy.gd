extends CharacterBody2D

@export var health: float = 10
@export var speed: float = 150.0
var stunned: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

func take_damage(damage: int):
	health = max(health - damage, 0)
	if health == 0:
		queue_free()
		
	$AnimatedSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite.modulate = Color.WHITE
	
func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false
	
	
func _physics_process(delta):
	#if Input.is_action_just_pressed("base_attack"):
		#var collision = get_node("Attack/BaseAttack")
		#collision.disabled = false
	#else:
		#var collision = get_node("Attack/BaseAttack")
		#collision.disabled = true
	#
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip();
	
	velocity.x = speed
	if not stunned:
		get_node("AnimatedSprite").play("Running")
	else:
		get_node("AnimatedSprite").play("Idle")
		
	move_and_slide()
	


func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1;
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
