extends Node

var hp = 100;

func is_dead():
    return hp <= 0

func take_damage(damage):
    hp = max(hp - damage, 0)

func get_hp():
    return hp

func reset():
    hp = 100