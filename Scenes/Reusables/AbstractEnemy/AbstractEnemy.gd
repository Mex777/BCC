extends CharacterBody2D

@export var health: float = 10
@export var max_speed: float = 40.0
@export var coins = 10
@export var damage: float = 5
@export var attack_cooldown: float = 1

var speed: float
var attacking: bool = false
var stunned: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var cooldown_base_attack: bool = false


func _ready():
	speed = max_speed


func _physics_process(delta):
	# Applies falling gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Sets the speed according to the facing direction
	if facing_right:
		velocity.x = abs(speed)
	else:
		velocity.x = abs(speed) * -1
	
	# When the enemy stays in place, it plays the idle animation	
	if speed == 0:
		$AnimatedSprite.play("Idle")
	
	# Updates animations based on the state of the enemy.
	if not stunned and not cooldown_base_attack:
		$AnimatedSprite.play("Running")
	elif not cooldown_base_attack:
		velocity.x = 0
		$AnimatedSprite.play("Idle")
		
	$BaseAttackTimer.wait_time = attack_cooldown
		
	move_and_slide()
	
	
# Function for handling damage taken by the enemy.
func take_damage(damage: int):
	# Decrease the health by the damage taken, but not below 0.
	health = max(health - damage, 0)
	# When the enemy dies it gives gems to the player and deletes the enemy.
	if health == 0:
		Game.add_coins(coins)
		queue_free()
		
	# Flash the sprite red when taking damage.	
	$AnimatedSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite.modulate = Color.WHITE
	

# Function for stunning the enemy.
func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false


# Sets cooldown for the attack
func attack():
	if not cooldown_base_attack:
		cooldown_base_attack = true
		$AnimatedSprite.play("Attacking")
		$BaseAttackTimer.start()


# Flips the sprite
func flip():
	facing_right = !facing_right
	$AnimatedSprite.scale.x *= -1;


func _on_base_attack_timer_timeout():
	cooldown_base_attack = false
