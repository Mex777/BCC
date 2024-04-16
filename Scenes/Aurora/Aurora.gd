extends CharacterBody2D 

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimatedSprite2D")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if Player.is_dead():
		queue_free()


	# Taking damage when you jump of the map.
	var viewport_rect = get_viewport_rect()
	if position.y > viewport_rect.position.y + viewport_rect.size.y:
		Player.take_damage(10)  

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		get_node("AnimatedSprite2D").play("Jump")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1: 
		get_node("AnimatedSprite2D").flip_h = true;
	elif direction:
		get_node("AnimatedSprite2D").flip_h = false;
		
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


func take_damage(amount):
	health -= amount
	if health <= 0:
		die()

func die():
	# queue_free()
	pass
	
