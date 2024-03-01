extends ENEMY


func _enter_tree():
	elem = "earth"
	speed = 80.0
	score = 200	
	

func explode():
	game.hurt_player(1)
	queue_free()

