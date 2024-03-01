extends ENEMY


func _enter_tree():
	elem = "fire"
	speed = 100.0
	
	score = 100

func explode():
	game.hurt_player(1)
	queue_free()

