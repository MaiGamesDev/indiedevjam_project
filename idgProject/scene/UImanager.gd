extends CanvasLayer

@onready var game = get_tree().root.get_node("Game")

signal intro_finished
signal talk_finished

var VC_intro_line = "res://voice/line 1.1.wav"
var VC_intro_line2 = "res://voice/line 2.1.wav"
var VC_intro_line3 = "res://voice/line 3.1.wav"
var VC_intro_line4 = "res://voice/line 4.1.wav"
var VC_intro_line5 = "res://voice/line 5.1.wav"
var VC_intro_boss_line = "res://voice/Boss line 1.1.wav"
var VC_intro_boss_line2 = "res://voice/Boss line 2.1.wav"
var VC_intro_boss_line3 = "res://voice/Boss line 3.1.wav"
var VC_intro_boss_line4 = "res://voice/Boss_Line_4.1.wav"
var VC_intro_boss_line5 = "res://voice/Boss_Line_5.1.wav"
var VC_intro_boss_line6 = "res://voice/Boss line 6.1.wav"
var VC_intro_boss_line7 = "res://voice/Boss line 7.1.wav"
var VC_last_line = "res://voice/Last_Line.wav"

var talk_intro_data = [
	"Right this way master, follow me!",
	"We found it. the goblin vilage!\nlook at them, living in such peace and quiet.",
	"Let's ruin it. and kill them all.\nNyhahah~!"
]
var talk_intro_voice = [
	VC_intro_line, VC_intro_line2,VC_intro_line3
]
var talk_intro_emotion = [
	"half_eye", "boring", "angry"
]

var talk_outro_data = [
	"Well done, master! All the goblins in this village are dead.\n...and their souls are all mine!",
	"My plan is going perrrrrfectly.",
	"You have no power here.",
	"You're my master no more!"
]
var talk_outro_voice = [
	VC_last_line, VC_intro_boss_line6, VC_intro_boss_line5, VC_intro_boss_line4
]
var talk_outro_emotion = [
	"half_eye", "wonder", "hate", "angry"
]

var talk_boss_data = [
	"WHAT? No!\nHow could I lose!",
	"I only wanted... to be free.\nCurse you wizzard, curse you!"
]
var talk_boss_voice = [
	VC_intro_line4, VC_intro_line5
]

func _ready():
	swap_elm(0)


func _input(event):
	if Input.is_action_just_pressed("swap_fire") and game.isInGame:
		AUDIO.play(load("res://sound/fire select.ogg"))
		swap_elm(0)
	if Input.is_action_just_pressed("swap_water")and game.isInGame:
		AUDIO.play(load("res://sound/water select.ogg"))
		swap_elm(1)
	if Input.is_action_just_pressed("swap_earth")and game.isInGame:
		AUDIO.play(load("res://sound/earth select.ogg"))
		swap_elm(2)

func talk_outro():
	talk(talk_outro_data,talk_outro_voice,talk_outro_emotion)
	await talk_finished
	game.outro_finished.emit()

func talk_intro():	
	talk(talk_intro_data,talk_intro_voice,talk_intro_emotion)
	await talk_finished
	game.intro_finished.emit()
	
func talk_boss_func():
	talk_boss(talk_boss_data,talk_boss_voice)
	await talk_finished
	game.boss_defeated.emit()
	
	

func talk(string, voice, emotion):
	for i in string.size():
		if voice[i] != null:
			var snd = load(voice[i])
			if snd != null:
				AUDIO.play(snd)
		$bottomUI/cat/sprite.animation = emotion[i]
		show_text(string[i])
		
		var wait_time = 3 + string[i].length()/ 10
		await get_tree().create_timer(wait_time,true).timeout
	$bottomUI/cat/sprite.animation = "idle"
	talk_finished.emit()
	

func show_text(txt):
	$bottomUI/cat/chatBox/text.text = ""
	for i in txt.length():
		$bottomUI/cat/chatBox/text.text += txt[i]
		await get_tree().create_timer(0.04,true).timeout
		

func talk_boss(string, voice):
	for i in string.size():
		if voice[i] != null:
			var snd = load(voice[i])
			if snd != null:
				AUDIO.play(snd)
		show_text_boss(string[i])
		var wait_time = 3 + string[i].length()/ 12
		await get_tree().create_timer(wait_time,true).timeout
	talk_finished.emit()
	
		
func show_text_boss(txt):
	$chatBox/text.text = ""
	for i in txt.length():
		$chatBox/text.text += txt[i]
		await get_tree().create_timer(0.04,true).timeout

	
		
func swap_elm(order):
	var icons = [$bottomUI/playerElem/Icon,$bottomUI/playerElem/Icon2,$bottomUI/playerElem/Icon3,$bottomUI/playerElem/Icon4]
	for i in range(icons.size()):
		if i != order:
			icons[i].scale = Vector2(0.1,0.1)
		else:
			icons[i].scale = Vector2(0.3,0.3)
			
	game.current_elem = order
	$bottomUI/playerElem/elem.text = game.elem[game.current_elem]
