extends GutTest
class_name TestEnemy

var abstract_enemy


func before_each():
	abstract_enemy = AbstractEnemyMock.new()


func after_each():
	abstract_enemy.free()
	Game.reset()
  

func test_take_damage():
	# Set health to 50
	abstract_enemy.health = 50
	# Call take_damage with damage = 10
	abstract_enemy.take_damage(10)
	# Check if the health has decreased by 10
	assert_eq(abstract_enemy.health, 40, "take_damage should decrease the health by the damage amount")


func test_take_damage_below_zero():
	# Call take_damage with damage = 70
	abstract_enemy.health = 50
	abstract_enemy.take_damage(70)
	# Check if the health is 0
	assert_eq(abstract_enemy.health, 0, "take_damage should not decrease the health below 0")


func test_take_damage_coins():
	abstract_enemy.health = 10
	abstract_enemy.take_damage(10)

	# Check if the player's coins have increased by 10
	assert_eq(Game.get_coins(), 10, "take_damage should give coins to the player when the enemy dies")


func test_run_animation():
	abstract_enemy.speed = 100
	abstract_enemy._physics_process(0.1)
	assert_eq(abstract_enemy.animation_name, "Running", "Running should be played when enemy moves")


func test_idle_animation():
	abstract_enemy.speed = 0
	abstract_enemy._physics_process(0.1)
	assert_eq(abstract_enemy.animation_name, "Idle", "Idle should be played when enemy doesn't move")


func test_stun():
	abstract_enemy.stun(1)
	assert_eq(abstract_enemy.stunned, true, "stun should set the enemy's stunned variable to true")


func test_stun_animation():
	abstract_enemy.stun(1)
	abstract_enemy._physics_process(0.1)
	assert_eq(abstract_enemy.animation_name, "Stunned", "Stunned should be played when enemy is stunned")


func test_flip():
	abstract_enemy.facing_right = true
	abstract_enemy.flip()
	assert_eq(abstract_enemy.facing_right, false, "flip should flip the enemy horizontally")


func test_attack():
	abstract_enemy.attack()
	assert_eq(abstract_enemy.animation_name, "Attacking", "Attacking should be played when enemy attacks")
	assert_true(abstract_enemy.cooldown_base_attack, "cooldown_base_attack should be true when enemy attacks")


func test_attack_cooldown():
	abstract_enemy.cooldown_base_attack = true
	abstract_enemy.speed = 0
	abstract_enemy.attack()
	abstract_enemy._physics_process(0.1)
	assert_eq(abstract_enemy.animation_name, "Idle", "Animation shouldn't change when enemy is on cooldown")
