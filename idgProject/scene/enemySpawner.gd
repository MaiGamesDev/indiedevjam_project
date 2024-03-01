extends Node2D


@onready var game = get_tree().root.get_node("Game")

var fireGoblin = preload("res://goblins/fire_goblin.tscn")
var waterGoblin = preload("res://goblins/water_goblin.tscn")
var earthGoblin = preload("res://goblins/earth_goblin.tscn")
var airGoblin = preload("res://goblins/air_goblin.tscn")


@export var spawn_vector_min = Vector2.ZERO
@export var spawn_vector_max = Vector2.ZERO


var firePer = 55
var waterPer = 25
var earthPer = 10
var airPer = 10


func _process(delta):
	pass

func repeat_spawn():
	var ran = randf_range(1,1.5)
	await get_tree().create_timer(ran,true).timeout
	spawn()
	repeat_spawn()
	
func spawn():
	var goblin = [fireGoblin,waterGoblin,earthGoblin,airGoblin]
	var enemy = goblin[roll_enemy()].instantiate()
	var dirx = randf_range(spawn_vector_min.x,spawn_vector_max.x)
	var diry = randf_range(spawn_vector_min.y,spawn_vector_max.y)
	
	enemy.global_position = global_position
	enemy.direction = Vector2(dirx,diry).normalized()
	game.add_child(enemy)

func roll_enemy():
	var i = randi_range(0,100)
	if i < firePer :
		return 0
	elif i < (firePer + waterPer):
		return 1
	elif i < (firePer + waterPer + earthPer):
		return 2
	else:
		return 3
