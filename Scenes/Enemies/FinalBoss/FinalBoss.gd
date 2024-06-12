extends AbstractEnemy
class_name FinalBoss

@onready var projectile = load("res://Scenes/Reusables/Projectile/SmartProjectile.tscn")
@export var JUMP_VELOCITY: float = -200

var jump_cooldown: bool = false
var flip_cooldown: bool = false
var player: Aurora
var chasing: bool = false
var range_attacking: bool = false
var range_cooldown: bool = false


func _ready() -> void:
	super()
	# Connect the signal_event signal from the Dialogic singleton to the dialogic_signal function.
	Dialogic.signal_event.connect(dialogic_signal)
	
	

func _physics_process(delta: float) -> void:
	if health == 0:
		return
		
	if chasing:
		# Start chasing the player on the X-axis
		speed = max_speed
		var player_in_right: bool = player.position.x > position.x
		var player_above: bool = player.position.y + 30 < position.y
		if player_in_right != facing_right and not flip_cooldown and not stunned:
			flip()

		# Jump after the player
		if player_above and is_on_floor() and not jump_cooldown and not stunned:
			jump()
	elif range_attacking:
		speed = 0
		range_attack()
	else:
		# Enter idle mode if not chasing
		speed = 0
	
	# Add physics
	super(delta)
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()
	

func range_attack() -> void:
	if range_cooldown:
		return
	if stunned:
		return
	# Uses cooldown logic from parent
	#super()
	range_cooldown = true
	# Checks direction of the player to know in which direction to shoot
	var player_in_right: bool = player.position.x > position.x
	
	# Flips enemy based on player position
	if player_in_right != facing_right:
		flip()
	
	# Shoots a projectile towards the player
	var instance: SmartProjectile = projectile.instantiate()
	instance.right = player_in_right
	instance.set_direction(player.global_position - global_position)
	
	$RangeAttackSFX.play()
	
	add_child(instance)
	await get_tree().create_timer(0.9).timeout
	range_cooldown = false


# Adding flip cooldown so that enemy doesn't change directions constantly
func flip() -> void:
	flip_cooldown = true
	super()
	$AttackRange.scale *= -1
	await get_tree().create_timer(0.5).timeout
	flip_cooldown = false
	
	
func jump() -> void:
	jump_cooldown = true
	velocity.y = JUMP_VELOCITY
	await get_tree().create_timer(2).timeout
	jump_cooldown = false


func attack() -> void:
	super()
	player.take_damage(damage)


# Function for handling damage taken by the enemy.
func take_damage(damage: int) -> void:
	# Decrease the health by the damage taken, but not below 0.
	health = max(health - damage, 0)

	if health == 0:
		Dialogic.start("4")		
	
		
	# Sound for getting hit
	$GettingHitSFX.play()
		
	# Flash the sprite red when taking damage.	
	$AnimatedSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite.modulate = Color.WHITE
	
	

# Start chasing the player when it enters chaser's range
func _on_chase_range_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		chasing = true


# Stop chasing the player when it leaves chaser's range
func _on_chase_range_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		chasing = false


# Start attacking the player when it enters attack range
func _on_attack_range_body_entered(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = true


# Stop attacking the player when it leaves attack range
func _on_attack_range_body_exited(body: CharacterBody2D) -> void:
	if body.name == "Aurora":
		attacking = false


func _on_ranged_attack_range_body_entered(body):
	if body.name == "Aurora":
		range_attacking = true
		Game.enter_combat()
		player = body
		

func _on_ranged_attack_range_body_exited(body):
	if body.name == "Aurora":
		range_attacking = false
		Game.exit_combat()
		player = null


func dialogic_signal(name):
	if name == "die":
		queue_free()
