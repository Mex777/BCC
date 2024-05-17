extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

@onready var projectile = load("res://Scenes/Reusables/Projectile/Projectile.tscn")

var player

func _ready():
	speed = 0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if not cooldown_base_attack and attacking and not stunned:
		attack()
		
	move_and_slide()

func _on_area_2d_body_exited(body):
	if body.name == "Aurora":
		attacking = false
		player = null

func _on_area_2d_body_entered(body):
	if body.name == "Aurora":
		attacking = true
		player = body
		if not cooldown_base_attack and not stunned:
			attack()

func attack():
	super()
	var instance = projectile.instantiate()
	
	var player_in_right: bool = player.position.x > position.x
	instance.right = player_in_right
	if player_in_right != facing_right:
		flip()
		
	add_child(instance)
	
