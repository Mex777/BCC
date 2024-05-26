extends AbstractEnemy
class_name AbstractEnemyMock

var animation_name: String


func _physics_process(delta: float) -> void:
	# Applies falling gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Sets the speed according to the facing direction
	if facing_right:
		velocity.x = abs(speed)
	else:
		velocity.x = abs(speed) * -1
	
	# When the enemy stays in place, it plays the idle animation	
	if stunned:
		velocity.x = 0
		animation_name = "Stunned"
	elif speed == 0:
		animation_name = "Idle"
	
	# Updates animations based on the state of the enemy.
	elif not cooldown_base_attack:
		animation_name = "Running"

		
	move_and_slide()
	
	
# Function for handling damage taken by the enemy.
func take_damage(damage: int) -> void:
	# Decrease the health by the damage taken, but not below 0.
	health = max(health - damage, 0)
	# When the enemy dies it gives gems to the player and deletes the enemy.
	if health == 0:
		Game.add_coins(coins)
	

# Function for stunning the enemy.
func stun(duration: float) -> void:
	stunned = true


# Sets cooldown for the attack
func attack() -> void:
	if not cooldown_base_attack:
		cooldown_base_attack = true
		animation_name = "Attacking"


# Flips the sprite
func flip() -> void:
	facing_right = !facing_right

