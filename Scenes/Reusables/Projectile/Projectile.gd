extends Area2D
class_name Projectile

@export var speed: float = 150
@export var damage: int = 15
@export var offset_x: int = 10

# Direcion of the bullet
var right: bool = true;
# Seconds until it despawns
var lifetime: float = 5


func _ready() -> void:
	# Offsets the projectile to the left or to the right depeding on player's position
	# We do this so that the projectile doesn't spawn inside the enemy
	if right:
		self.position.x += offset_x
		$AnimatedSprite2D.scale *= 1
	else:
		self.position.x += -offset_x
		$AnimatedSprite2D.scale *= -1
		
	$AnimatedSprite2D.play("default")
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



