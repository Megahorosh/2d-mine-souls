extends Node

var world = []
var worldSizeX = 100
var worldSizeY = 100
# Called when the node enters the scene tree for the first time.
func _init() -> void:
	for i in range(worldSizeX):
		world.append([])
		for j in range(worldSizeY):
			world[i].append(randf())
	print("World generation has been finished!")
