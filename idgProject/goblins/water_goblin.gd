extends ENEMY


func _enter_tree():
	elem = "water"
	speed = 50.0
	score = 50
	
	
	

func explode():
	game.hurt_player(1)
	queue_free()

