extends Area2D

var speed = 150
@export var damage: float = 15
var right = true;
var lifetime = 5

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += transform.x * direction(right) * delta
	
func direction(right):
	if right:
		return speed
	return -speed

func _on_body_entered(body):
	if body.is_in_group("Enemies"):
		return
	if body.name == "Aurora":
		body.take_damage(damage)
		queue_free()
	else:
		queue_free()

