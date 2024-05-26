extends GutTest
class_name TestChaseEnemy

var chase_enemy_mock
var player


func before_each():
	# Load the chase_enemy_mock script
	chase_enemy_mock = ChaseEnemyMock.new()

	# Mock the player character
	player = AuroraMock.new()
	player.name = "Aurora"
	
	
func after_each():
	chase_enemy_mock.free()
	player.free()
	Game.reset() 


func test_jump():
	# Call jump
	chase_enemy_mock.jump()
	# Check if velocity.y is JUMP_VELOCITY
	assert_eq(chase_enemy_mock.velocity.y, chase_enemy_mock.JUMP_VELOCITY, "jump should set velocity.y to JUMP_VELOCITY")
	# Check if jump_cooldown is true
	assert_true(chase_enemy_mock.jump_cooldown, "jump should set jump_cooldown to true")


func test_on_chase_range_body_entered():
	# Call _on_chase_range_body_entered with player
	chase_enemy_mock._on_chase_range_body_entered(player)
	# Check if chasing is true
	assert_true(chase_enemy_mock.chasing, "_on_chase_range_body_entered should set chasing to true when player enters chase range")


func test_on_chase_range_body_exited():
	# Call _on_chase_range_body_exited with player
	chase_enemy_mock._on_chase_range_body_exited(player)
	# Check if chasing is false
	assert_false(chase_enemy_mock.chasing, "_on_chase_range_body_exited should set chasing to false when player exits chase range")
