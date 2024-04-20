extends CharacterBody2D 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimatedSprite2D")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Deletes the player when it dies
	if Player.is_dead():
		queue_free()

	# Taking damage when you jump of the map.
	var viewport_rect = get_viewport_rect()
	if position.y > viewport_rect.position.y + viewport_rect.size.y:
		take_damage(10)  

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		get_node("AnimatedSprite2D").play("Jump")
		
	# Handle base attack.
	if Input.is_action_just_pressed("base_attack"):
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = false
	else:
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = true
		
	if Input.is_action_just_pressed("stun"):
		var collision = get_node("Stun/Stun")
		collision.disabled = false
	else:
		var collision = get_node("Stun/Stun")
		collision.disabled = true
		
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1: 
		get_node("AnimatedSprite2D").flip_h = true;
		if $Attack/BaseAttack.position.x > 0:
			$Attack/BaseAttack.position.x *= -1
	elif direction:
		get_node("AnimatedSprite2D").flip_h = false;
		if $Attack/BaseAttack.position.x < 0:
			$Attack/BaseAttack.position.x *= -1
	
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			get_node("AnimatedSprite2D").play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			get_node("AnimatedSprite2D").play("Idle")
	
	if velocity.y > 0:
		pass

	move_and_slide()
	
	
func take_damage(damage):
	Player.take_damage(damage)
	
	$AnimatedSprite2D.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite2D.modulate = Color.WHITE
	
	
func stun(duration: int):
	pass
