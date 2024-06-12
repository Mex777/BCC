extends Aurora
class_name AuroraMock

var animation_name: String

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Handle cutscenes.
	if Game.is_in_cutscene():
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
	
	if direction:
		velocity.x = direction * max_speed
	else:
		velocity.x = move_toward(velocity.x, 0, max_speed)
	
	update_animation()
	move_and_slide()


func attack():
	if not cooldown_base_attack:
		cooldown_base_attack = true
		attacking = true
		animation_name = "Attacking"
		base_attack()

	
func stun():
	if not cooldown_stun_attack:
		attacking = true
		animation_name = "Stun"
		stun_ability()
	

func update_animation() -> void:
	if attacking:
		return
	if velocity.x != 0:
		animation_name = "Run"
	else:
		animation_name = "Idle"
		
	if velocity.y < 0:
		animation_name = "Up"
	if velocity.y > 0:
		animation_name = "Down"
		
		
# Function for handling damage taken by the character.
func take_damage(damage: int) -> void:
	if not Game.in_god_mode():
		Player.take_damage(damage)
		
		
# Function for handling the stun ability.
func stun_ability() -> void:
	cooldown_stun_attack = true 

	
# Function for handling the base attack.
func base_attack() -> void:
	cooldown_base_attack = true

