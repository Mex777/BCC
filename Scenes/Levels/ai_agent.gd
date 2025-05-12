extends AIController2D

# Stores the action sampled for the agent's policy, running in python
var move_action : float = 0.0
var jump_action: float = 0.0 
var basic_attack: float = 0.0
var stun_attack: float = 0.0

func _physics_process(delta):
	n_steps += 1
		
func get_obs() -> Dictionary:
	var grid_pos = Vector2(
		int(_player.global_position.x / 16),
		int(_player.global_position.y / 16)
	)
	#var mat = _player.get_local_matrix(grid_pos, 2)
	var dist_normalized = 1 - _player.global_position.distance_to(_player.finish) / Vector2(0, 0).distance_to(Vector2(70 * 16, 30 * 16))
	var raycast_observation = _player.raycast.get_observation()
	#print(grid_pos)
	#for line in mat:
		#print(line)
	#print()
	
	var obs = [
		dist_normalized,
		Player.get_hp() / Player.get_max_hp()
	]
	obs.append_array(raycast_observation)
			
	return {
		"obs": obs,
	}

func get_reward() -> float:
	#print(reward + _player.get_reward())
	return reward + _player.get_reward()

func get_action_space() -> Dictionary:
	return {
		"move_action" : {
			"size": 1,
			"action_type": "continuous"
		},
		"jump_action": {
			"size": 1,
			"action_type": "discrete"
		},
		"basic_attack_action": {
			"size": 1,
			"action_type": "discrete"
		},
		"stun_action": {
			"size": 1,
			"action_type": "discrete"
		}
	}

func set_action(action) -> void:
	move_action = action["move_action"][0]
	jump_action = action["jump_action"]
	basic_attack = action["basic_attack_action"]
	stun_attack = action["stun_action"]
