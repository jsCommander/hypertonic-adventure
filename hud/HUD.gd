extends CanvasLayer

@export var game_state: GameState

@onready var heart_sprite:= $HeartSprite
@onready var blood_pressure_label:= $BloodPressure
@onready var restart_button:= $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	game_state.blood_pressure_changed.connect(_update_blood_pressure)
	game_state.game_state_changed.connect(_handle_game_state_change)

func _get_heart_frame(blood_pressure: int) -> int:
	if blood_pressure < 140:
		return 0
	if blood_pressure < 180:
		return 1

	return 2

func _restart():
	game_state.set_game_state(GameState.STATE.NEW_GAME)

func _update_blood_pressure(value: int):
	blood_pressure_label.text = str(value)
	heart_sprite.frame = _get_heart_frame(value)

func _handle_game_state_change(state: GameState.STATE):
	match state:
		GameState.STATE.GAME_OVER:
			heart_sprite.frame = 3
			restart_button.set_visible(true)
		GameState.STATE.NEW_GAME:
			restart_button.set_visible(false)
