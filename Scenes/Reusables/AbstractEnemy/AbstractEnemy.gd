extends CharacterBody2D

@export var health: float = 10
@export var max_speed: float = 40.0
var speed
@export var damage: float = 5
@export var attack_cooldown: float = 1
var attacking: bool = false
var stunned: bool = false
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true
var cooldown_base_attack: bool = false

func _ready():
	speed = max_speed

func take_damage(damage: int):
	health = max(health - damage, 0)
	if health == 0:
		queue_free()
		
	$AnimatedSprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	$AnimatedSprite.modulate = Color.WHITE
	
func stun(duration: float):
	stunned = true
	await get_tree().create_timer(duration).timeout
	stunned = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if facing_right:
		velocity.x = abs(speed)
	else:
		velocity.x = abs(speed) * -1
		
	if not stunned and not cooldown_base_attack:
		$AnimatedSprite.play("Running")
	elif not cooldown_base_attack:
		velocity.x = 0
		$AnimatedSprite.play("Idle")
		
	$BaseAttackTimer.wait_time = attack_cooldown
		
	move_and_slide()
	
func attack():
	if not cooldown_base_attack:
		cooldown_base_attack = true
		$AnimatedSprite.play("Attacking")
		$BaseAttackTimer.start()

func flip():
	facing_right = !facing_right
	$AnimatedSprite.scale.x *= -1;

func _on_base_attack_timer_timeout():
	cooldown_base_attack = false
