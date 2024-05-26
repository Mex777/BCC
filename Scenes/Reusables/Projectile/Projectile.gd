extends Area2D
class_name Projectile

@export var speed: float = 150
@export var damage: int = 15

# Direcion of the bullet
var right: bool = true;
# Seconds until it despawns
var lifetime: float = 5


func _ready() -> void:
	await get_tree().create_timer(lifetime).timeout
	queue_free()


# It goes at a constant speed in the right direction
func _physics_process(delta) -> void:
	position += transform.x * direction(right) * delta
	

func direction(right) -> int:
	if right:
		return speed
	return -speed


func _on_body_entered(body: Node) -> void:
	# Doesn't hit other enemies
	if body.is_in_group("Enemies"):
		return
	
	if body.name == "Aurora":
		body.take_damage(damage)
	
	# Despawns after collision
	queue_free()

