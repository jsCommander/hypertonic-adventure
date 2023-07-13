extends Node2D

@export var food_scene: PackedScene
@export var spawn_timeout: float = 1
@export var min_spawn_timeout: float = 0.5
@export var spawn_timeout_step: float = 0.1
@export var start_blood_pressure: int = 90

@onready var up_spawn = $UpSpawn
@onready var down_spawn = $DownSpawn
@onready var spawn_timer = $FoodSpawnTimer
@onready var hud = $HUD
@onready var player = $Player
@onready var background = $background

enum SPAWN {DOWN = 1, UP = 2, PAUSE = 0}
const spawns = [
	[1, 0, 2, 2, 1, 1, 0, 1, 2, 0],
	[2, 1, 0, 1, 2, 0, 1, 1, 2, 2],
	[0, 1, 2, 0, 1, 2, 1, 0, 1, 2],
	[2, 0, 1, 1, 2, 2, 0, 2, 1, 1],
	[1, 1, 0, 2, 1, 0, 2, 2, 0, 1]
]
var spawn_sequence = _get_random_sequence(spawns)
var spawn_sequence_index: int = 0

const foods = [
	[0, 1, 0, 2, 3, 2, 1, 3, 0, 2],
	[2, 2, 1, 0, 3, 1, 2, 0, 0, 3],
	[3, 0, 1, 2, 3, 1, 0, 2, 2, 1],
	[1, 2, 0, 3, 2, 1, 0, 0, 2, 3],
	[2, 0, 3, 1, 3, 0, 2, 1, 3, 0],
	[3, 1, 0, 2, 1, 3, 2, 0, 1, 3],
	[0, 2, 1, 3, 0, 2, 3, 1, 0, 2],
	[1, 3, 2, 0, 3, 1, 2, 0, 3, 1],
]
var food_sequence = _get_random_sequence(foods)
var food_sequence_index: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_spawn_timeout(spawn_timeout)
	player.set_blood_pressure(start_blood_pressure)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_food_spawn_timeout():
	var food = food_scene.instantiate()

	spawn_sequence_index+=1
	if spawn_sequence_index >= spawn_sequence.size():
		spawn_sequence = _get_random_sequence(spawns)
		spawn_sequence_index = 0

	var spawn = spawn_sequence[spawn_sequence_index]
	if spawn == SPAWN.PAUSE:
		return

	food_sequence_index+=1
	if food_sequence_index >= food_sequence.size():
		food_sequence = _get_random_sequence(foods)
		food_sequence_index = 0

	var position = down_spawn.position if spawn == SPAWN.DOWN else up_spawn.position
	food.init(position, food_sequence[food_sequence_index])
	add_child(food)

func _set_spawn_timeout(timeout: float):
	spawn_timer.wait_time = max(min_spawn_timeout, timeout)
	print("spawn timeout: ", spawn_timer.wait_time)

func _get_random_sequence(array):
	return array[randi() % array.size()]

func _game_over():
	spawn_timer.stop()
	background.camera_speed = 0
	hud.set_game_over()
	for node in get_children():
		if node.has_method("despawn"):
			node.despawn()

func _game_start():
	spawn_timer.start()
	background.camera_speed = 200
	player.set_blood_pressure(start_blood_pressure)

