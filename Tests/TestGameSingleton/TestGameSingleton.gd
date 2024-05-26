extends GutTest

var mock_game

func before_each():
	mock_game = MockGame.new()


func after_each():
	mock_game.reset()
	mock_game.free()
	

func test_in_god_mode():
	# Set god_mode to true
	mock_game.god_mode = true
	# Check if in_god_mode returns true
	assert_true(mock_game.in_god_mode(), "in_god_mode should return true when god_mode is true")


func test_get_god_mode():
	# Set god_mode to false
	mock_game.god_mode = false
	# Check if get_god_mode returns false
	assert_false(mock_game.get_god_mode(), "get_god_mode should return false when god_mode is false")


func test_is_in_cutscene():
	# Set in_cutscene to true
	mock_game.in_cutscene = true
	# Check if is_in_cutscene returns true
	assert_true(mock_game.is_in_cutscene(), "is_in_cutscene should return true when in_cutscene is true")


func test_get_level_name():
	# Set level_name to "Level1"
	mock_game.level_name = "Level1"
	# Check if get_level_name returns "Level1"
	assert_eq(mock_game.get_level_name(), "Level1", "get_level_name should return the correct level name")


func test_advance_to_level():
	mock_game.advance_to_level("Level2")
	assert_eq(mock_game.get_level_name(), "Level2", "advance_to_level should change the level name to the correct level name")


func test_in_combat():
	mock_game.enter_combat()
	assert_true(mock_game.in_combat(), "in_combat should return true when in combat")


func test_out_of_combat():
	mock_game.enter_combat()
	mock_game.exit_combat()
	assert_false(mock_game.in_combat(), "in_combat should return false when not in combat")
