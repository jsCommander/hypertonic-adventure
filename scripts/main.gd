extends Node2D

@export var enemy_scene: PackedScene
var last_spawn

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_enemy_spawn_timer_timeout():
	var enemy = enemy_scene.instantiate()
	var spawn = $GroundSpawnPoint if randf() > 0.5 else $FlySpawnPoint
	print(spawn.position)
	enemy.position = spawn.position
	enemy.direction = Vector2.LEFT
	add_child(enemy)
	print("spawn enemy")
