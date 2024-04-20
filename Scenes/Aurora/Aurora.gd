extends CharacterBody2D 

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
@export var attacking: bool = false
var cooldown_stun_attack: bool = false
var cooldown_base_attack: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = get_node("AnimationPlayer")
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
		
	# Handle base attack.
	if Input.is_action_just_pressed("base_attack") and not cooldown_base_attack:
		cooldown_base_attack = true
		attacking = true
		animation.play("Attack")
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = false
		base_attack()
	else:
		var collision = get_node("Attack/BaseAttack")
		collision.disabled = true
		

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle ability.
	if Input.is_action_just_pressed("stun") and not cooldown_stun_attack:
		attacking = true
		animation.play("Stun")
		var collision = get_node("Stun/Stun")
		collision.disabled = false
		stun_ability()
	else:
		var collision = get_node("Stun/Stun")
		collision.disabled = true
		
		
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1: 
		get_node("Sprite").flip_h = true;
		if $Attack/BaseAttack.position.x > 0:
			$Attack/BaseAttack.position.x *= -1
	elif direction:
		get_node("Sprite").flip_h = false;
		if $Attack/BaseAttack.position.x < 0:
			$Attack/BaseAttack.position.x *= -1
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	update_animation()
	move_and_slide()
	
	
func update_animation():
	if attacking:
		return
	if velocity.x != 0:
		animation.play("Run")	
	else:
		animation.play("Idle")
		
	if velocity.y < 0:
		animation.play("Up")
	if velocity.y > 0:
		animation.play("Down")
	
	
func take_damage(damage):
	Player.take_damage(damage)
	
	$Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite.modulate = Color.WHITE
	
	
func stun_ability():
	cooldown_stun_attack = true 
	await get_tree().create_timer(5.0).timeout
	cooldown_stun_attack = false
	
func base_attack():
	cooldown_base_attack = true
	await get_tree().create_timer(0.6).timeout
	cooldown_base_attack = false
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack" or anim_name == "Stun":
		attacking = false