extends CharacterBody2D 

@export var god_mode = false

const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
var attacking: bool = false
var cooldown_stun_attack: bool = false
var cooldown_base_attack: bool = false
var in_cutscene = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var animation = get_node("AnimationPlayer")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()

func _ready():
	Dialogic.signal_event.connect(dialogic_signal)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Deletes the player when it dies
	if Player.is_dead():
		queue_free()
	
	if in_cutscene:
		update_animation()
		move_and_slide()
		return
	
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
	if god_mode == false:
		Player.take_damage(damage)
	
	$Sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$Sprite.modulate = Color.WHITE
	
	
func stun_ability():
	cooldown_stun_attack = true 
	$StunTimer.start()
	
func base_attack():
	cooldown_base_attack = true
	$BasicAttackTimer.start()
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Attack" or anim_name == "Stun":
		attacking = false

func _on_timer_timeout():
	cooldown_base_attack = false;

func _on_stun_timer_timeout():
	cooldown_stun_attack = false;

func dialogic_signal(name):
	if name == "cutscene_ended":
		in_cutscene = false
		god_mode = false
