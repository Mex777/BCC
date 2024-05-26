extends GutTest


func after_each():
	Player.reset()


func test_set_get_hp():
	# Set hp to 50
	Player.set_hp(50)
	# Check if get_hp returns 50
	assert_eq(Player.get_hp(), 50, "get_hp should return the correct hp")


func test_reset():
	# Set hp to 50
	Player.set_hp(50)
	# Reset the player
	Player.reset()
	# Check if hp is reset to max_hp
	assert_eq(Player.get_hp(), Player.get_max_hp(), "reset should set hp to max_hp")


func test_get_max_hp():
	# Assume max_hp is 100
	assert_eq(Player.get_max_hp(), 100, "get_max_hp should return the correct max_hp")


func test_set_get_skin():
	# Set skin to "skin1"
	Player.set_skin("skin1")
	# Check if get_skin returns " (skin1)"
	assert_eq(Player.get_skin(), " (skin1)", "get_skin should return the correct skin with format")


func test_get_skin_no_format():
	Player.set_skin("skin1")
	# Check if get_skin_no_format returns "skin1"
	assert_eq(Player.get_skin_no_format(), "skin1", "get_skin_no_format should return the correct skin without format")


func test_take_damage():
	# Set hp to 50
	Player.set_hp(50)
	# Take 10 damage
	Player.take_damage(10)
	# Check if hp is 40
	assert_eq(Player.get_hp(), 40, "take_damage should reduce hp by the correct amount")


func test_take_damage_below_0():
	Player.set_hp(50)
	Player.take_damage(100)
	assert_eq(Player.get_hp(), 0, "take_damage should not reduce hp below 0")


func test_is_dead():
	Player.set_hp(50)
	assert_eq(Player.is_dead(), false, "is_dead should return false if hp is above 0")


func test_is_dead_0():
	Player.set_hp(50)
	Player.take_damage(50)
	assert_eq(Player.is_dead(), true, "is_dead should return true if hp is 0")
