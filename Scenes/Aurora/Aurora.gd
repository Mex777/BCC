extends CharacterBody2D 
class_name Aurora

@export var camera_left_limit: int
@export var camera_right_limit: int
@export var camera_top_limit: int
@export var camera_bottom_limit: int
@export var max_speed: float = 300.0

var speed = 0
const JUMP_VELOCITY: float = -400.0
var attacking: bool = false
var cooldown_stun_attack: bool = false
var cooldown_base_attack: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animation = get_node("AnimationPlayer")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()
@onready var camera = $Camera2D


func _ready() -> void:
	camera.limit_left = camera_left_limit
	camera.limit_right = camera_right_limit
	camera.limit_top = camera_top_limit
	camera.limit_bottom = camera_bottom_limit
	
	# Connect the signal_event signal from the Dialogic singleton to the dialogic_signal function.
	Dialogic.signal_event.connect(dialogic_signal)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Deletes the player when it dies.
	if Player.is_dead():
		queue_free()
	
	# Handle cutscenes.
	if Game.is_in_cutscene():
		velocity.x = speed
		update_animation()
		move_and_slide()
		return
	
	# Handle base attack.
	if Input.is_action_just_pressed("base_attack"):
		attack()
		
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle ability.
	if Input.is_action_just_pressed("stun"):
		stun()
	
	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction == -1: 
		get_node("Sprite").flip_h = true;
		if $Attack/BaseAttack.position.x > 0:
			$Attack/BaseAttack.position.x *= -1
	elif direction:
		get_node("Sprite").flip_h = false;
		if $Attack/BaseAttack.position.x < 0:
			$Attack/BaseAttack.position.x *= -1
	
	if direction:
		velocity.x = direction * max_speed
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	update_animation()
	move_and_slide()
	

func attack():
	# Can only attack when ability is not in cooldown
	if not cooldown_base_attack:
		cooldown_base_attack = true
		attacking = true
		animation.play("Attack" + Player.get_skin())
		base_attack()

	
func stun():
	# Can only stun when ability is not in cooldown
	if not cooldown_stun_attack:
		attacking = true
		animation.play("Stun" + Player.get_skin())
		stun_ability()
		$WinkSFX.play()


# Function for updating the animation based on the character's state.
func update_animation() -> void:
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
func take_damage(damage: int) -> void:
	if not Game.in_god_mode():
		Player.take_damage(damage)
	
	# Flash the sprite red when taking damage.
	$Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite.modulate = Color.WHITE	
	$GettingHitSFX.play()
	

# Function for handling the stun ability.
func stun_ability() -> void:
	# Enables collision for 0.1 secs to register if hit
	var collision = get_node("Stun/Stun")
	collision.disabled = false
	
	cooldown_stun_attack = true 
	$StunTimer.start()
	await get_tree().create_timer(0.1).timeout
	
	# Disables collision afterwards
	collision.disabled = true


# Function for handling the base attack.
func base_attack() -> void:
	# Enables collision for 0.1 secs to register if hit
	var collision = get_node("Attack/BaseAttack")
	collision.disabled = false
	
	# Sound for attack
	$SwingSFX.play()
	
	cooldown_base_attack = true
	$BasicAttackTimer.start()
	await get_tree().create_timer(0.1).timeout
	
	# Disables collision afterwards
	collision.disabled = true
	

# Callback for when an animation finishes playing.
func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "Attack" + Player.get_skin() or anim_name == "Stun" + Player.get_skin():
		attacking = false


# Callback for when the base attack cooldown timer times out.
func _on_timer_timeout() -> void:
	cooldown_base_attack = false;


# Callback for when the stun attack cooldown timer times out.
func _on_stun_timer_timeout() -> void:
	cooldown_stun_attack = false;

#
func dialogic_signal(signal_name: String) -> void:
	if signal_name.contains("run"):
		speed = 10
		await get_tree().create_timer(float(signal_name.split(".")[1])).timeout
		speed = 0
