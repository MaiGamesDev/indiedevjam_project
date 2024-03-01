extends RigidBody2D
class_name ENEMY

@onready var game = get_tree().root.get_node("Game")
@onready var VC_die = "res://voice/Goblin dying 1.wav"
@onready var VC_die2 = "res://voice/Goblin dying 2.wav"

@export var speed = 100.0

@export_enum("fire","water","earth","air") var elem


var direction = Vector2(1,0)

var isAimed = false
signal enemy_died(score,combo)

var extra_hp = 0
var extra_combo = 0

var score = 100

func _ready():
	
	$anim.play()
	
	linear_velocity = direction * speed
	if game != null:
		enemy_died.connect(game._on_enemy_died)

	$anim.speed_scale = speed/100

	
func _process(delta):
	if abs(global_position).x > 500 :
		queue_free()
	if abs(global_position).y > 400 :
		queue_free()

func _input(event):
	if Input.is_action_just_released("fire") and isAimed:
		if get_isOnTop():
			if extra_hp >= 0:
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
				extra_hp -= 1


func die():
	$score.modulate = game.get_node("UI/topUI/combo").modulate
	$score.text = str(score * game.score_multiple)
	$score.show()
	
	$hurtBox/collision.disabled = true
	linear_velocity = Vector2.ZERO
	enemy_died.emit(score,1 + extra_combo)
	get_node("anim").play("die")
	
	var vc = [VC_die,VC_die2]
	var i = randi_range(0,1)
	var sound = load(vc[i])
	AUDIO.play(sound, -10)

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
