extends CanvasLayer

@onready var heart_sprite: Sprite2D = $HeartSprite
@onready var blood_pressure_label: Label = $BloodPressure
@onready var restart_button: Button = $Button

signal restart

enum STAGES { HAPPY, TIRED, SCARY, DEAD }

func update_blood_pressure(value: int):
	blood_pressure_label.text = str(value)
	heart_sprite.frame = _get_heart_frame(value)

func set_game_over():
	heart_sprite.frame = 3
	restart_button.set_visible(true)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _get_heart_frame(blood_pressure: int)->int:
	if blood_pressure < 140:
		return 0
	if blood_pressure < 180:
		return 1
	if blood_pressure <= 220:
		return 2

	return 3

func _restart():
	restart.emit()
	restart_button.set_visible(false)
