extends Node

@export var tile: PackedScene
@export var water_tile: PackedScene
@export var tile_size_x: int = 64
@export var tile_size_y: int = 48

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if tile == null:
		print("Ошибка: tile не назначен в инспекторе!")
		return
	print("Тайл назначен")
		
	if Worldgen.world.size() > 0:
		for x in Worldgen.world.size():
			for y in Worldgen.world[x].size():
				var new_tile = tile.instantiate()
				add_child(new_tile)
				
				
				if Worldgen.world[x][y] < 0.5:
					new_tile.get_child(0).get_child(0).texture = load("res://assets/tiles/water_bottom.png")
					new_tile.global_position = Vector2(x*tile_size_x, y*tile_size_y+64)
					
					var new_tile_water = water_tile.instantiate()
					add_child(new_tile_water)
					new_tile_water.get_child(0).get_child(0).texture = load("res://assets/tiles/water.png")
					new_tile_water.global_position = Vector2(x*tile_size_x, y*tile_size_y+32)
				else:
					# пол
					new_tile.get_child(0).get_child(0).texture = load("res://assets/tiles/grass.png")
					# стена
					new_tile.get_child(0).get_child(1).texture = load("res://assets/tiles/water_bottom.png")
					new_tile.global_position = Vector2(x*tile_size_x, y*tile_size_y)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass # Replace with function body.
