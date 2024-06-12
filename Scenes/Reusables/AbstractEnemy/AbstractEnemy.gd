extends CharacterBody2D
class_name AbstractEnemy

@export var max_health: int = 10
@export var max_speed: float = 40.0
@export var coins: int = 10
@export var damage: float = 5
@export var attack_cooldown: float = 1

var speed: float
var attacking: bool = false
var stunned: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right: bool = true
var cooldown_base_attack: bool = false
var health: int


func _ready() -> void:
	speed = max_speed
	health = max_health


func _process(_delta: float) -> void:
	# Updates HP bar every frame
	$TextureProgressBar.value = float(health) / max_health;


func _physics_process(delta: float) -> void:
	# Applies falling gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Sets the speed according to the facing direction
	if facing_right:
		velocity.x = abs(speed)
	else:
		velocity.x = abs(speed) * -1
	
	if stunned:
		velocity.x = 0
		$AnimatedSprite.play("Idle")
	# Checks if not in the attack animation
	elif not cooldown_base_attack and speed == 0:
		$AnimatedSprite.play("Idle")
	elif not cooldown_base_attack:
		$AnimatedSprite.play("Running")

	$BaseAttackTimer.wait_time = attack_cooldown
		
	move_and_slide()
	
	
# Function for handling damage taken by the enemy.
func take_damage(damage: int) -> void:
	# Decrease the health by the damage taken, but not below 0.
	health = max(health - damage, 0)
	# When the enemy dies it gives gems to the player and deletes the enemy.
	if health == 0:
		Game.enemy_dying_sound()
		Game.add_coins(coins)
		queue_free()
		
	# Sound for getting hit
	$GettingHitSFX.play()
		
	# Flash the sprite red when taking damage.	
	$AnimatedSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite.modulate = Color.WHITE
	

# Function for stunning the enemy.
func stun(duration: float) -> void:
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false


# Sets cooldown for the attack
func attack() -> void:
	if not cooldown_base_attack:
		cooldown_base_attack = true
		$AttackSFX.play()
		$AnimatedSprite.play("Attacking")
		$BaseAttackTimer.start()


# Flips the sprite
func flip() -> void:
	facing_right = !facing_right
	$AnimatedSprite.scale.x *= -1;


func _on_base_attack_timer_timeout() -> void:
	cooldown_base_attack = false
