extends RigidBody2D
class_name BALL

@onready var game = get_tree().root.get_node("Game")
@onready var VC_die = "res://voice/Goblin dying 1.wav"
@onready var VC_die2 = "res://voice/Goblin dying 2.wav"




var direction = Vector2(1,0)

var hp = 3
var elem = "fire"
var speed = 50.0

var isAimed = false
signal enemy_died(score,combo)



func _ready():
	$hurtBox.mouse_entered.connect(_on_hurt_box_mouse_entered)
	$hurtBox.mouse_exited.connect(_on_hurt_box_mouse_exited)
	
	direction = Vector2(0,1)
	
	linear_velocity = direction * speed


	
func _process(delta):
	if abs(global_position).x > 500 :
		queue_free()
	if abs(global_position).y > 400 :
		queue_free()
	
	if global_position.y > 400:
		boom()
		
	$sprite.rotation_degrees += 2

func _input(event):
	if Input.is_action_just_released("fire") and isAimed:
		if get_isOnTop():
			if hp < 1:
				var playerElem = game.elem[game.current_elem]
				match elem:
					"fire":
						if playerElem == "water":
							die()
					"water":
						if playerElem == "earth":
							die()
					"earth":
						if playerElem == "fire":
							die()
					"air":
						die()
			else:
				hp -= 1
				
				var vc = [VC_die,VC_die2]
				var i = randi_range(0,1)
				var sound = load(vc[i])
				AUDIO.play(sound, -10)


func die():
	game.set_boss_hp(game.boss_hp - 1)
	$hurtBox/collision.disabled = true
	linear_velocity = Vector2.ZERO
	get_node("anim").play("die")
	
	var vc = [VC_die,VC_die2]
	var i = randi_range(0,1)
	var sound = load(vc[i])
	AUDIO.play(sound, -10)
	
func boom():
	$hurtBox/collision.disabled = true
	linear_velocity = Vector2.ZERO
	get_node("anim").play("boom")
	game.level_gameover()

func get_isOnTop():
	if $hurtBox.get_overlapping_areas:
		
		var lapping = $hurtBox.get_overlapping_areas()
		for body in lapping:
			if body.get_parent().isAimed:
				if body.get_parent().get_index() < $hurtBox.get_parent().get_index():
					return false
		return true

func _on_hurt_box_mouse_entered():
	isAimed = true

func _on_hurt_box_mouse_exited():
	isAimed = false
