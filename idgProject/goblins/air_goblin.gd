extends ENEMY


func _enter_tree():
	elem = "air"
	speed = 200.0
	
	score = 500
	

func explode():
	game.hurt_player(1)
	queue_free()

