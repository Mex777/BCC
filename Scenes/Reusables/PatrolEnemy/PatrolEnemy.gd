extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

func _physics_process(delta):
	if !$RayCast2D.is_colliding() && is_on_floor():
		flip();
		$RayCast2D.position.x *= -1
		$Area2D/CollisionShape2D.position.x *= -1
	
	
	super(delta)
	


