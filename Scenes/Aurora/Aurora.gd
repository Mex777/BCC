extends CharacterBody2D 
class_name Aurora

@export var camera_left_limit: int
@export var camera_right_limit: int
@export var camera_top_limit: int
@export var camera_bottom_limit: int
@export var max_speed: float = 300.0
@export var ai_enabled: bool = false

var speed = 0
const JUMP_VELOCITY: float = -400.0
var attacking: bool = false
var cooldown_stun_attack: bool = false
var cooldown_base_attack: bool = false
var stunned: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animation = get_node("AnimationPlayer")
@onready var game_over = preload("res://Scenes/GameOver/GameOver.tscn").instantiate()
@onready var camera = $Camera2D

######################################### RL stuff #################################################
var ai_controller = null
var raycast = null
var finish = null
var previous_distance = 0
var best_distance = INF
var current_game = 0
var best_time = INF
var total_time: float = 0.0
var done_cnt = 0
var dead_cnt = 0
var out_of_time = 0
@export var start_x: int = 0
@export var start_y: int = 0
####################################################################################################

func _ready() -> void:
	camera.limit_left = camera_left_limit
	camera.limit_right = camera_right_limit
	camera.limit_top = camera_top_limit
	camera.limit_bottom = camera_bottom_limit
	#remove_child($Camera2D)
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	if name == str(multiplayer.get_unique_id()):
		camera.enabled = true
		Player.set_skin(MultiplayerManager.Players[multiplayer.get_unique_id()].skin)
		camera.make_current()
	# Connect the signal_event signal from the Dialogic singleton to the dialogic_signal function.
	Dialogic.signal_event.connect(dialogic_signal)
	
	if ai_enabled:
		ai_controller = $"../AIController2D"
		ai_controller.init(self)
		Player.max_hp = 100
		Player.reset()
		finish = $"../NextLevelPortal/CollisionShape2D".global_position
		raycast = $RaycastSensor2D
	MusicPlayer.stop_music()  # Oprește muzica când începe jocul


func _physics_process(delta: float) -> void:
	if len(MultiplayerManager.Players) == 0 or (len(MultiplayerManager.Players) > 0 and $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id()):
		if MultiplayerManager.freeze:
			return
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
		
		# Deletes the player when it dies.
		if Player.is_dead():
			if len(MultiplayerManager.Players) > 0:
				queue_free_rpc.rpc(name)
			elif ai_enabled:
				dead_cnt += 1
				print("DEAD")
				reset()
			else:
				queue_free()
		
		if name == str(multiplayer.get_unique_id()):
			$Info.text = MultiplayerManager.Players[name.to_int()].name + ": " + str(Player.get_hp())
			camera.enabled = true
			camera.make_current()
		
		# Handle cutscenes.
		if Game.is_in_cutscene():
			velocity.x = speed
			update_animation()
			move_and_slide()
			return
		
		if stunned:
			velocity.x = 0
			animation.play("Idle" + Player.get_skin())
			move_and_slide()
			return
		
		# Handle base attack.
		if Input.is_action_just_pressed("base_attack"):
			attack()
		
		# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor() and not stunned:
			velocity.y = JUMP_VELOCITY
			
		# Handle ability.
		if Input.is_action_just_pressed("stun"):
			stun()
		
		# Get the input direction and handle the movement/deceleration.
		var direction = Input.get_axis("move_left", "move_right")
		if ai_enabled:
			direction = round(ai_controller.move_action)
			
			if ai_controller.jump_action and is_on_floor():
				velocity.y = JUMP_VELOCITY
			if ai_controller.stun_attack:
				stun()
			if ai_controller.basic_attack:
				attack()
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


@rpc("any_peer", "call_local")
func get_stunned(duration: float) -> void:
	stunned = true
	$StunInfo.text = "STUNNED"
	await get_tree().create_timer(duration).timeout
	$StunInfo.text = ""
	stunned = false


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
@rpc("any_peer", "call_local")
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


@rpc("any_peer", "call_local")
func queue_free_rpc(id):
	var players = get_tree().get_nodes_in_group("Player")
	for i in players:
		if i.name == str(id):
			i.queue_free()
	
	if multiplayer.is_server():
		MultiplayerManager.losers.append(id)

########################################## AI FUNCTIONS ############################################

func reset():
	$"..".reset()
	Player.reset()
	Game.reset()
	global_position = Vector2(start_x, start_y)
	current_game += 1
	print("Done rate: " + str(done_cnt / float(current_game) * 100))
	print("Dead rate: " + str(dead_cnt / float(current_game) * 100))
	print("Out of time rate: " + str(out_of_time / float(current_game) * 100))
	print("Average completion time: " + str(total_time / float(done_cnt)))
	print("Current time: " + str(600 - $"../Timer".get_time_left()))
	print("Best time: " + str(best_time))
	print()
	print("Iteration: " + str(current_game))
	$"../Timer".start()
	ai_controller.reset()
	best_distance = INF
		

func get_reward() -> float:
	var current_distance = finish.distance_to(global_position)
	#current_distance = abs(finish.x - global_position.x)
	#var max_distance = 70 * 16 + 30 * 16
	#return -(1 - current_distance / max_distance)
	#
	if current_distance < best_distance:
		best_distance = current_distance
		#print("best")
		previous_distance = current_distance
		return 0.3

	if current_distance < previous_distance:
		#print("closer")
		previous_distance = current_distance
		
		return 0.1
	
	#print("further")
	previous_distance = current_distance
	return 0
	
	var rew = (previous_distance - current_distance) / 100
	previous_distance = current_distance
	return rew

func _on_timer_timeout2():
	ai_controller.reward -= 1.0
	out_of_time += 1
	print("run out of time")
	reset()
	
