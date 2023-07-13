extends Area2D

@export var speed = 100.0

@onready var sprite = $Sprite2D

var direction = Vector2.LEFT
var sprite_frame: int

func init(position: Vector2, sprite_frame:int):
	self.position = position
	self.sprite_frame = sprite_frame

func despawn():
	queue_free()

func _ready():
	sprite.frame = sprite_frame

func _process(delta):
	position += speed * delta * direction

func _on_player_hit(body):
	despawn()

func _on_screen_leave():
	despawn()


