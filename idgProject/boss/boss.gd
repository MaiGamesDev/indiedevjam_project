extends Node2D
@onready var game = get_tree().root.get_node("Game")
@onready var Fire_ball = preload("res://boss/fire_ball.tscn")

var fireBallRate = 6.0

var hp = 6

func _ready():
	repeat_throw_ball()



func _process(delta):
	pass

func fire_ball():
	var ball = Fire_ball.instantiate()
	ball.global_position = $hand_left/ball.global_position
	
	game.add_child(ball)

func repeat_throw_ball():
	if game.boss_hp < 1:
		return
	$hand_left/anim.play("throw_ball")
	
	var snd = ["res://voice/Boss line 1.1.wav","res://voice/Boss line 2.1.wav","res://voice/Boss line 3.1.wav"]
	AUDIO.play(load(snd[randi_range(0,2)]))
	
	if game.boss_hp < 1:
		return
	await get_tree().create_timer(fireBallRate,true).timeout
	if game.boss_hp  < 1:
		return
	repeat_throw_ball()

func set_hp(value):
	hp = value
	if hp < 1 :
		$anim.play("die")
		
func boss_defeated():
	game.boss_defeated
	queue_free()
