extends Node2D

@onready var game = get_tree().root.get_node("Game")
@onready var effect_trace = preload("res://scene/effect_trace.tscn")
@onready var traceWater = preload("res://art/laserWater.png")
@onready var traceFire = preload("res://art/laserFire.png")
@onready var traceEarth = preload("res://art/laserEarth.png")
@onready var traceAir = preload("res://art/laserAir.png")
@onready var boss = preload("res://boss/boss.tscn")

@onready var titleBgm = preload("res://music/TITTLE SCREEN done ( hovering ).ogg")
@onready var mainBgm = preload("res://music/main done1.ogg")
@onready var bossBgm = preload("res://music/Boss done1.ogg")

signal progress_pressed
signal score_reached
signal intro_finished
signal outro_finished
signal gameovered
signal boss_defeated

var current_level = 0

var max_score = 30000
var score = 0
var combo = 0
var max_combo = 0
var combo_time = 1.5
var score_multiple = 1.0
var hp = 3
var boss_hp = 6
var elem = ["fire","water","earth","air"]
var current_elem = 0
var isInGame = false
var isGameDone = false


# Called when the node enters the scene tree for the first time.
func _ready():
	progress()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _input(event):
	if Input.is_action_just_released("fire") and isInGame:
		fire()
		match elem[current_elem]:
			"fire":
				var snd = ["res://sound/fire shoot 1.ogg","res://sound/fire shoot 2.ogg","res://sound/fire shoot 3.ogg"]
				AUDIO.play(load(snd[randi_range(0,2)]))
			"water":
				var snd = ["res://sound/water shoot 1.ogg","res://sound/water shoot 2.ogg","res://sound/water shoot 3.ogg"]
				AUDIO.play(load(snd[randi_range(0,2)]))
			"earth":
				var snd = ["res://sound/earth shoot 1.ogg","res://sound/earth shoot 2.ogg","res://sound/earth shoot 3.ogg"]
				AUDIO.play(load(snd[randi_range(0,2)]))
				
	if Input.is_action_just_pressed("progress"):
		progress_pressed.emit()
		if isGameDone:
			get_tree().reload_current_scene()
	
func  _on_enemy_died(s,c):
	set_combo(combo + c)
	set_score(score + s * score_multiple)
	
func fire():
	var trace = effect_trace.instantiate()
	var laser = [traceFire,traceWater,traceEarth,traceAir]
	
	trace.global_position = $firePoint.global_position
	trace.texture = laser[current_elem]
	game.add_child(trace)
	
	$UI/bottomUI/anim.play("fire")

func hurt_player(value):
	hp -= value

func set_score(value):
	score = value
	$UI/topUI/score.text = str(score) + " / " + str(max_score)
	
	if score >= max_score:
		score_reached.emit()

	
func set_combo(value):
	combo = value
	$UI/topUI/combo.text = "x" + str(combo)
	$UI/topUI/anim.play("combo_increased")
	
	if combo > 0 :
		$UI/topUI/comboTimer.wait_time = combo_time
		$UI/topUI/comboTimer.start()
		
	if combo < 10:
		score_multiple = 1.0
		$UI/topUI/combo.modulate = Color.WHITE
	if combo == 10:
		AUDIO.play(load("res://voice/10GS.wav"))
	if combo >= 10:
		score_multiple = 1.5
		$UI/topUI/combo.modulate = Color.ORANGE
	if combo == 20:
		AUDIO.play(load("res://voice/20GS.wav"))
	if combo >= 20:
		score_multiple = 2.0
		$UI/topUI/combo.modulate = Color.ORANGE_RED	
		
	if combo > max_combo:
		max_combo = combo
		
func set_boss_hp(value):
	boss_hp = value
	if boss_hp < 1 :
		$UI/chatBox.show()
		$UI.talk_boss_func()
		$Boss/anim.stop()
		$Boss/anim.play("die")

func progress():
	level_reset()
	level_mainMenu()
	await progress_pressed
	level_tutorial()
	await progress_pressed
	level_intro()
	await intro_finished
	level_inGame()
	await score_reached
	level_ingame_outro()
	await outro_finished
	level_boss()
	await boss_defeated
	level_result()
	
		
func level_reset():
	$UI/bottomUI.hide()
	$UI/topUI.hide()
	$UI/tutorial.hide()
	$UI/gameover.hide()
	$UI/title.hide()
	$UI/result.hide()
	$UI/chatBox.hide()
	isInGame = false
	
func level_mainMenu():
	$Camera2D.zoom = Vector2(0.3,0.3)
	set_score(0)
	set_combo(0)
	$UI/title.show()
	
	
func level_tutorial():
	$UI/title.hide()
	$UI/tutorial.show()
	
func level_intro():
	$UI/tutorial.hide()
	$UI/bottomUI.show()
	$UI/topUI.show()
	$UI.talk_intro()
	
func level_inGame():
	$bgmTitle.stop()
	$bgmMain.play()
	
	$playTimer.start()
	$UI/bottomUI/cat/chatBox.hide()
	$animGlobal.play("zoom_in")
	$enemySpawner.repeat_spawn()
	$enemySpawner2.repeat_spawn()
	$enemySpawner3.repeat_spawn()
	$enemySpawner4.repeat_spawn()
	isInGame = true
	
func level_ingame_outro():
	$bgmMain.stop()
	
	$enemySpawner.queue_free()
	$enemySpawner2.queue_free()
	$enemySpawner3.queue_free()
	$enemySpawner4.queue_free()
	isInGame = false
	
	$UI/bottomUI/cat/chatBox.show()
	$UI.talk_outro()
	
func level_boss():
	
	$bgmBoss.play()
	$UI/bottomUI/cat.hide()
	var b = boss.instantiate()
	b.global_position = Vector2(135,150)
	
	add_child(b)
	
	isInGame = true
	
func level_result():
	level_reset()
	
	$UI/result/playtime/time.text = $UI/topUI/timer.text
	$playTimer.stop()
	$UI/result/maxCombo/combo.text = "x" + str(max_combo)
	$UI/result.show()
	
	isGameDone = true
	
func level_gameover():
	level_reset()
	$UI/gameover.show()
	
	isGameDone = true

		
func _on_combo_timer_timeout():
	set_combo(0)
	
func _on_gameover():
	level_gameover()
