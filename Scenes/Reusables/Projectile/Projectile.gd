extends Area2D

@export var speed = 150
@export var damage: float = 15

# Direcion of the bullet
var right = true;
# Seconds until it despawns
var lifetime = 5


func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# It goes at a constant speed in the right direction
func _physics_process(delta):
	position += transform.x * direction(right) * delta
	

func direction(right):
	if right:
		return speed
	return -speed


func _on_body_entered(body):
	# Doesn't hit other enemies
	if body.is_in_group("Enemies"):
		return
	
	if body.name == "Aurora":
		body.take_damage(damage)
	
	# Despawns after collision
	queue_free()

