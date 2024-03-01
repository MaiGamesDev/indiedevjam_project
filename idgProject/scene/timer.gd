extends Label

@onready var timer = get_tree().root.get_node("Game/playTimer")
func _process(delta):
	var current_time = timer.wait_time - timer.time_left
	text = str(int(current_time)/60) + ":" + str(int(current_time)%60)


