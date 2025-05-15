extends Node2D

var devil = preload("res://Scenes/Enemies/Devil/Devil.tscn")
var skeleton = preload("res://Scenes/Enemies/Skeleton/Skeleton.tscn")
var guardian = preload("res://Scenes/Enemies/Guardian/Guardian.tscn")

var devil_positions = [
	Vector2i(385, 161),
	Vector2i(635, 622),
	Vector2i(1205, 767),
	Vector2i(2006, 641),
	Vector2i(2952, 599),
	Vector2i(706, 359)
]

var guardian_positions = [
	Vector2i(1147, 773),
	Vector2i(1535, 767),
	Vector2i(447, 785),
	Vector2i(508, 779),
	Vector2i(1909, 782),
	Vector2i(2114, 779),
	#Vector2i(2918, 761),
	Vector2i(2522, 577),
	Vector2i(3169, 576)
]

var skeleton_positions = [
	Vector2i(712, 525),
	Vector2i(2237, 659),
	Vector2i(2952, 674)
]


func _ready():
	reset()


func reset():
	# Remove existing enemies
	for enemy in get_tree().get_nodes_in_group("Enemies"):
		enemy.queue_free()
	
	# Respawn new enemies
	for pos in devil_positions:
		var new_enemy = devil.instantiate()
		new_enemy.global_position = pos
		new_enemy.damage = 5
		add_child(new_enemy)
		new_enemy.add_to_group("Enemies")
		
	# Respawn new enemies
	for pos in skeleton_positions:
		var new_enemy = skeleton.instantiate()
		new_enemy.global_position = pos
		new_enemy.damage = 4
		add_child(new_enemy)
		new_enemy.add_to_group("Enemies")
		
	# Respawn new enemies
	for pos in guardian_positions:
		var new_enemy = guardian.instantiate()
		new_enemy.global_position = pos
		new_enemy.damage = 3
		add_child(new_enemy)
		new_enemy.add_to_group("Enemies")
