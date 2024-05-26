extends GutTest

var player


func before_each():
	player = AuroraMock.new()
	
	
func after_each():
	player.free()
	Player.reset()


func test_update_animation_run():
	# Set velocity.x to a non-zero value
	player.velocity.x = 10
	# Call update_animation
	player.update_animation()
	# Check if the animation is "Run"
	assert_eq(player.animation_name, "Run", "update_animation should play 'Run' animation when velocity.x is non-zero")


func test_update_animation_idle():
	# Set velocity.x to 0
	player.velocity.x = 0
	# Call update_animation
	player.update_animation()
	# Check if the animation is "Idle"
	assert_eq(player.animation_name, "Idle", "update_animation should play 'Idle' animation when velocity.x is zero")


func test_update_animation_up():
	player.velocity.y = -15
	player.update_animation()
	
	assert_eq(player.animation_name, "Up", "update_animation should play 'Up' animation when velocity.y is negative")


func test_update_animation_down():
	player.velocity.y = 15
	player.update_animation()
	
	assert_eq(player.animation_name, "Down", "update_animation should play 'Down' animation when velocity.y is positive")


func test_take_damage():
	# Call take_damage with damage = 10
	player.take_damage(10)
	# Check if the player's hp has decreased by 10
	assert_eq(Player.get_hp(), Player.get_max_hp() - 10, "take_damage should decrease the player's hp by the damage amount when not in god mode")
	

func test_take_damage_god_mode():
	# Set god_mode to true
	Game.set_god_mode(true)
	# Call take_damage with damage = 10
	player.take_damage(10)
	# Check if the player's hp has not changed
	assert_eq(Player.get_hp(), Player.get_max_hp(), "take_damage should not decrease the player's hp when in god mode")


func test_stun_ability_cooldown():
	# Call stun_ability
	player.stun_ability()
	# Check if the player is stunned
	assert_true(player.cooldown_stun_attack, "stun_ability should set cooldown to true")


func test_base_attack_cooldown():
	# Call attack_ability
	player.base_attack()
	# Check if the player is attacking
	assert_true(player.cooldown_base_attack, "attack_ability should set cooldown to true")


func test_stun_animation():
	player.stun()
	assert_eq(player.animation_name, "Stun", "stun_ability should play 'Stun' animation when stun is pressed")


func test_base_attack_animation():
	player.attack()
	assert_eq(player.animation_name, "Attacking", "attack_ability should play 'BaseAttack' animation when attack is pressed")


func test_base_attack_in_cooldown():
	player.animation_name = "Idle"
	player.cooldown_base_attack = true
	player.attack()
	assert_eq(player.animation_name, "Idle", "attack_ability should not play 'BaseAttack' animation when cooldown is true")


func test_stun_in_cooldown():
	player.animation_name = "Idle"
	player.cooldown_stun_attack = true
	player.stun()
	assert_eq(player.animation_name, "Idle", "stun_ability should not play 'Stun' animation when cooldown is true")
