extends Node

var world = []
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	for i in range(100):
		world.append([])
		for j in range(100):
			world[i].append(randf())
	print("World generation has been finished!")
