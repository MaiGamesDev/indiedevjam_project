extends Line2D

func _ready():
	points[1] = get_local_mouse_position()
	await get_tree().create_timer(0.5,true).timeout
	queue_free()
