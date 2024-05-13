extends "res://Scenes/Reusables/AbstractEnemy/AbstractEnemy.gd"

func _physics_process(delta):
	super(delta)
	#if !$RayCast2D.is_colliding() && is_on_floor():
		#flip();
