extends AbstractEnemy
class_name Mob


# Mobs can't get stunned and they don't have hp 
func _ready():
	$TextureProgressBar.hide()
	$Label.hide()
	speed = 0


# Mobs don't take damage
func take_damage(damage: int) -> void:
	pass


## Mobs do not move by default on the X-axis
#func _physics_process(delta: float) -> void:
	#super(delta)

