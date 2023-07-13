extends CharacterBody2D

@export var jump_velocity = 400.0
@export var blood_pressure_death_threashhold = 220
@export var blood_pressure_increase = 5

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slide_collision_shape = $Hitbox/SlideCollisionShape2D
@onready var run_collision_shape = $Hitbox/RunCollisionShape2D

var blood_pressure = 100

enum PlayerState {IDLE, RUN, JUMP, SLIDE, DEAD}
var current_state = PlayerState.IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

signal blood_pressure_changed
signal died

func set_blood_pressure(value: int):
	blood_pressure = value
	blood_pressure_changed.emit(blood_pressure)

# Called when the node enters the scene tree for the first time.
func _ready():
	_handle_state_change(PlayerState.IDLE, PlayerState.RUN)

func _input(event):
	var is_mouse_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	var is_touch = event is InputEventScreenTouch

	if is_mouse_click or is_touch:
		var action = "jump" if event.position.y < 128 else "slide"
		var action_event = InputEventAction.new()
		action_event.action = action
		action_event.pressed = event.is_pressed()
		Input.parse_input_event(action_event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	if current_state == PlayerState.RUN:
		if Input.is_action_pressed("slide"):
			_handle_state_change(PlayerState.RUN, PlayerState.SLIDE)

		if Input.is_action_pressed("jump"):
			_handle_state_change(PlayerState.RUN, PlayerState.JUMP)

	if current_state == PlayerState.SLIDE and not Input.is_action_pressed("slide"):
		_handle_state_change(PlayerState.SLIDE, PlayerState.RUN)

	if current_state == PlayerState.JUMP:
		if is_on_floor():
			_handle_state_change(PlayerState.JUMP, PlayerState.RUN)
		else:
			velocity.y += delta * gravity

	move_and_slide();

func _handle_state_change(prev_state:PlayerState, new_state:PlayerState):
	print("switch player state from ", PlayerState.keys()[prev_state], " to ", PlayerState.keys()[new_state])
	current_state = new_state

	if new_state == PlayerState.JUMP:
		animated_sprite.play("jump")
		velocity.y = -jump_velocity

	if new_state == PlayerState.RUN:
		run_collision_shape.set_deferred("disabled", false)
		slide_collision_shape.set_deferred("disabled", true)
		animated_sprite.play("run")

	if new_state == PlayerState.SLIDE:
		run_collision_shape.set_deferred("disabled", true)
		slide_collision_shape.set_deferred("disabled", false)
		animated_sprite.play("slide")


func _on_food_hit(body):
	blood_pressure += blood_pressure_increase
	blood_pressure_changed.emit(blood_pressure)

	if blood_pressure > blood_pressure_death_threashhold:
		_game_over()

func _game_over():
	animated_sprite.play("death")
	died.emit()
	run_collision_shape.set_deferred("disabled", true)
	slide_collision_shape.set_deferred("disabled", true)
