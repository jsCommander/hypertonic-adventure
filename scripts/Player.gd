extends CharacterBody2D

@export var jump_velocity = 400.0
@export var pulse = 100
@export var pulse_death_threashhold = 200

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var slide_collision_shape = $SlideCollisionShape2D
@onready var run_collision_shape = $RunCollisionShape2D

enum PlayerState {IDLE, RUN, JUMP, SLIDE, DEAD}
var current_state = PlayerState.IDLE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

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
		
	
