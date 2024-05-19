extends Node

var curr_coins = 0

func add_coins(coins):
	curr_coins += coins
	
func get_coins():
	return curr_coins
	
func reset():
	curr_coins = 0
