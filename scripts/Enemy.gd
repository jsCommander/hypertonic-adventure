extends Area2D

@export var speed = 100.0

var direction = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("run")

func _process(delta):
	position += speed * delta * direction

func _on_visible_on_screen_notifier_2d_screen_exited():
	despawn()

func _on_body_entered(body):
	despawn()

func despawn():
	queue_free()
	print("Enemy despawn")
