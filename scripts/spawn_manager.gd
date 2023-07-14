class_name Spawner

enum SPAWN { DOWN = 1, UP = 2, PAUSE = 0 }
const spawns = [
	[1, 0, 2, 2, 1, 1, 0, 1, 2, 0],
	[2, 1, 0, 1, 2, 0, 1, 1, 2, 2],
	[0, 1, 2, 0, 1, 2, 1, 0, 1, 2],
	[2, 0, 1, 1, 2, 2, 0, 2, 1, 1],
	[1, 1, 0, 2, 1, 0, 2, 2, 0, 1]
]
var spawn_sequence = _get_random_sequence(spawns)
var spawn_sequence_index: int = 0

enum FOOD { ICE_CREAM = 0, BURGER = 1, PIZZA = 2, FRYES = 3 }
const foods = [
	[0, 1, 0, 2, 3, 2, 1, 3, 0, 2],
	[2, 2, 1, 0, 3, 1, 2, 0, 0, 3],
	[3, 0, 1, 2, 3, 1, 0, 2, 2, 1],
	[1, 2, 0, 3, 2, 1, 0, 0, 2, 3],
	[2, 0, 3, 1, 3, 0, 2, 1, 3, 0],
	[3, 1, 0, 2, 1, 3, 2, 0, 1, 3],
	[0, 2, 1, 3, 0, 2, 3, 1, 0, 2],
	[1, 3, 2, 0, 3, 1, 2, 0, 3, 1],
]
var food_sequence = _get_random_sequence(foods)
var food_sequence_index: int = 0


func get_next_spawn_type() -> SPAWN:
	if spawn_sequence_index >= spawn_sequence.size():
		spawn_sequence = _get_random_sequence(spawns)
		spawn_sequence_index = 0

	var spawn = spawn_sequence[spawn_sequence_index]
	spawn_sequence_index += 1
	return spawn


func get_next_food_type() -> FOOD:
	if food_sequence_index >= food_sequence.size():
		food_sequence = _get_random_sequence(foods)
		food_sequence_index = 0

	var food = food_sequence[food_sequence_index]
	food_sequence_index += 1
	return food


func _get_random_sequence(array):
	return array[randi() % array.size()]
