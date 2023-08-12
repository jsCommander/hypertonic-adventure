extends Resource

class_name GameState

enum STATE {IDLE, NEW_GAME, RUNNING, GAME_OVER}

@export var camera_speed := 100.0

@export var default_spawn_timeout := 1.0
@export var min_spawn_timeout := 0.6
@export var spawn_timeout_step := 0.05

@export var default_blood_pressure := 90
@export var blood_pressure_death := 220
@export var blood_pressure_step := 5

@export var score := 0
@export var score_step := 10

@export var player_jump_velocity := 400.0
@export var player_slide_delay_timeout := 1.0
@export var player_slide_active_timeout := 1.0

var state: STATE = STATE.IDLE
var blood_pressure: int
var spawn_timeout: float

signal blood_pressure_changed
signal game_state_changed
signal spawn_timeout_changed
signal score_changed

func set_game_state(state: STATE)-> void:
	self.state = state
	print("GameState: switch to state ", STATE.keys()[state])

	if state == STATE.NEW_GAME:
		_set_spawn_timeout(default_spawn_timeout)
		_set_blood_pressure(default_blood_pressure)
		_set_score(0)

	game_state_changed.emit(state)

func increase_blood_pressure()->void:
	_set_blood_pressure(blood_pressure + blood_pressure_step)

func increase_difficulty()->void:
	_set_spawn_timeout(spawn_timeout - spawn_timeout_step)

func increase_score()->void:
	_set_score(score + score_step)

func _set_blood_pressure(value: int)->void:
	blood_pressure = value
	blood_pressure_changed.emit(blood_pressure)

	if blood_pressure >= blood_pressure_death:
		set_game_state(STATE.GAME_OVER)

func _set_spawn_timeout(value: float)->void:
	spawn_timeout = max(min_spawn_timeout, value)
	spawn_timeout_changed.emit(spawn_timeout)

func _set_score(value: int)->void:
	score = value
	score_changed.emit(score)


