extends CharacterBody2D

@export var game_state: GameState

@onready var animated_sprite:= $AnimatedSprite2D
@onready var slide_collision_shape := $Hitbox/SlideCollisionShape2D
@onready var run_collision_shape := $Hitbox/RunCollisionShape2D

enum PlayerState { IDLE, RUN, JUMP, SLIDE, DEAD }
var current_state = PlayerState.IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	_handle_state_change(PlayerState.IDLE, PlayerState.RUN)
	game_state.game_state_changed.connect(_handle_game_state_change)


func _input(event):
	var is_mouse_click = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT
	var is_touch = event is InputEventScreenTouch

	if is_mouse_click or is_touch:
		var action = "jump" if event.position.y < 128 else "slide"
		var action_event = InputEventAction.new()
		action_event.action = action
		action_event.pressed = event.is_pressed()
		Input.parse_input_event(action_event)

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

	if not is_on_floor():
		velocity.y += delta * gravity

	move_and_slide()

func _handle_state_change(prev_state: PlayerState, new_state: PlayerState):
	print(
		"Player: switch state from ",
		PlayerState.keys()[prev_state],
		" to ",
		PlayerState.keys()[new_state]
	)
	current_state = new_state

	if new_state == PlayerState.JUMP:
		animated_sprite.play("jump")
		velocity.y = -game_state.player_jump_velocity

	if new_state == PlayerState.RUN:
		run_collision_shape.set_deferred("disabled", false)
		slide_collision_shape.set_deferred("disabled", true)
		animated_sprite.play("run")

	if new_state == PlayerState.SLIDE:
		run_collision_shape.set_deferred("disabled", true)
		slide_collision_shape.set_deferred("disabled", false)
		animated_sprite.play("slide")

	if new_state == PlayerState.DEAD:
		animated_sprite.play("death")
		run_collision_shape.set_deferred("disabled", true)
		slide_collision_shape.set_deferred("disabled", true)


func _on_food_hit(body):
	game_state.increase_blood_pressure()

func _handle_game_state_change(state: GameState.STATE):
	match state:
		GameState.STATE.GAME_OVER:
			_handle_state_change(current_state, PlayerState.DEAD)
		GameState.STATE.NEW_GAME:
			_handle_state_change(current_state, PlayerState.RUN)





