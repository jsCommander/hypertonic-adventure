extends Node2D

@export var food_scene: PackedScene
@export var game_state: GameState

@onready var up_spawn := $UpSpawn
@onready var down_spawn := $DownSpawn
@onready var spawn_timer := $FoodSpawnTimer
@onready var hud := $HUD
@onready var player := $Player
@onready var background := $Background

var spawner_script := preload("res://scripts/spawn_manager.gd")
const SPAWN := spawner_script.SPAWN
var spawner := spawner_script.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.spawn_timeout_changed.connect(_set_timeout)
	game_state.game_state_changed.connect(_handle_game_state_change)

	game_state.set_game_state(GameState.STATE.NEW_GAME)

func _on_food_spawn_timeout():
	var food := food_scene.instantiate()

	var spawn_type := spawner.get_next_spawn_type()
	if spawn_type == SPAWN.PAUSE:
		return

	var food_type := spawner.get_next_food_type()

	var position = down_spawn.position if spawn_type == SPAWN.DOWN else up_spawn.position
	food.init(position, food_type)
	add_child(food)

func _handle_game_state_change(state: GameState.STATE):
	match state:
		GameState.STATE.GAME_OVER:
			spawn_timer.stop()
			background.camera_speed = 0
			for node in get_children():
				if node.has_method("despawn"):
					node.despawn()
		GameState.STATE.NEW_GAME:
			spawn_timer.start()
			background.camera_speed = game_state.camera_speed

func _set_timeout(timeout:float):
	spawn_timer.wait_time = timeout
