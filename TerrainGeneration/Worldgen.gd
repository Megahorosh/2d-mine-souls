extends Node

var world = []
var worldSizeX = 1000
var worldSizeY = 1000
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	for i in range(worldSizeX):
		world.append([])
		for j in range(worldSizeY):
			world[i].append(randf())
	print("World generation has been finished!")
