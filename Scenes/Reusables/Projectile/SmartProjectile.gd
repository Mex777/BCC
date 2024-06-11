extends Projectile
class_name SmartProjectile

var initial_direction: Vector2 = Vector2(0, 0)


# It goes at a constant speed in the right direction
func _physics_process(delta) -> void:
	position += initial_direction * speed * delta


func set_direction(dir):
	initial_direction = dir.normalized()
