extends CharacterBody2D 

@export var camera_left_limit: int
@export var camera_right_limit: int
@export var camera_top_limit: int
@export var camera_bottom_limit: int

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var attacking: bool = false
var cooldown_stun_attack: bool = false
var cooldown_base_attack: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animation = get_node("AnimationPlayer")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()
@onready var camera = $Camera2D


func _ready():
	camera.limit_left = camera_left_limit
	camera.limit_right = camera_right_limit
	camera.limit_top = camera_top_limit
	camera.limit_bottom = camera_bottom_limit


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Deletes the player when it dies.
	if Player.is_dead():
		queue_free()
	
	# Handle cutscenes.
	if Game.is_in_cutscene():
		update_animation()
		move_and_slide()
		return
	
	# Handle base attack.
	if Input.is_action_just_pressed("base_attack") and not cooldown_base_attack:
		cooldown_base_attack = true
		attacking = true
		animation.play("Attack" + Player.get_skin())
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
		animation.play("Stun" + Player.get_skin())
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
	

# Function for updating the animation based on the character's state.
func update_animation():
	if attacking:
		return
	if velocity.x != 0:
		animation.play("Run" + Player.get_skin())	
	else:
		animation.play("Idle" + Player.get_skin())
		
	if velocity.y < 0:
		animation.play("Up" + Player.get_skin())
	if velocity.y > 0:
		animation.play("Down" + Player.get_skin())
	

# Function for handling damage taken by the character.
func take_damage(damage):
	if not Game.in_god_mode():
		Player.take_damage(damage)
	
	# Flash the sprite red when taking damage.
	$Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite.modulate = Color.WHITE	
	

# Function for handling the stun ability.
func stun_ability():
	cooldown_stun_attack = true 
	$StunTimer.start()
	

# Function for handling the base attack.
func base_attack():
	cooldown_base_attack = true
	$BasicAttackTimer.start()
	

# Callback for when an animation finishes playing.
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack" + Player.get_skin() or anim_name == "Stun" + Player.get_skin():
		attacking = false


# Callback for when the base attack cooldown timer times out.
func _on_timer_timeout():
	cooldown_base_attack = false;


# Callback for when the stun attack cooldown timer times out.
func _on_stun_timer_timeout():
	cooldown_stun_attack = false;
