extends CanvasLayer

func _process(_delta):
	$TimeLeft.text = str(int($"../StartTimer".time_left) + 1)
