extends Node

@export var Player: Node2D
@export var tile: PackedScene
@export var water_tile: PackedScene
@export var tile_size_x: int = 64
@export var tile_size_y: int = 48

var renderGrid = []
var renderGridSizeX: float = 32
var renderGridSizeY: float = 32

var playerPosRoundedX: float = 0
var playerPosRoundedY: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var playerPosRoundedX = round(Player.global_position.x/tile_size_x)*tile_size_x
	var playerPosRoundedY = round(Player.global_position.y/tile_size_y)*tile_size_y
	
	
	for x in range(renderGridSizeX):
		renderGrid.append([])
		for y in range(renderGridSizeY):
			renderGrid[x].append([(x/2-x)*tile_size_x,(y/2-y)*tile_size_y])

	
	
	if tile == null:
		print("Ошибка: tile не назначен в инспекторе!")
		return
	print("Тайл назначен")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Вычисляем текущую позицию игрока в тайлах
	var currentTileX = Player.global_position.x / tile_size_x
	var currentTileY = Player.global_position.y / tile_size_y
	
	# Проверяем, изменилась ли позиция игрока в тайлах
	var newRoundedX = round(currentTileX) * tile_size_x
	var newRoundedY = round(currentTileY) * tile_size_y
	
	# Если изменилась позиция по X или Y, обновляем сетку
	if newRoundedX != playerPosRoundedX or newRoundedY != playerPosRoundedY:
		playerPosRoundedX = newRoundedX
		playerPosRoundedY = newRoundedY
		gridRefresh()
	#print("playerPosRoundedX: ", playerPosRoundedX, "(playerPosRoundedX-renderGridSizeX/2): ",(playerPosRoundedX-renderGridSizeX/2), "Player.global_position.x: ", Player.global_position.x, " playerPosRoundedX+renderGridSizeX/2: ", playerPosRoundedX+renderGridSizeX/2)
func gridRefresh() -> void:
	print("вызвана функция gridRefresh")
	
		# Удаляем все существующие тайлы
	for child in get_children():
		child.queue_free()
		# Ждем один кадр, чтобы объекты успели удалиться
	#await get_tree().process_frame
	
	if Worldgen.world.size() > 0:
		for x in range(renderGridSizeX):
			for y in range(renderGridSizeY):
				var new_tile = tile.instantiate()
				add_child(new_tile)
				if Worldgen.world[(renderGrid[x][y][0]+playerPosRoundedX)/tile_size_x][(renderGrid[x][y][1]+playerPosRoundedY)/tile_size_y]  < 0.5:
					new_tile.get_child(0).get_child(0).texture = load("res://assets/tiles/water_bottom.png")
					new_tile.global_position = Vector2(renderGrid[x][y][0]+playerPosRoundedX, renderGrid[x][y][1]+playerPosRoundedY)
					
					var new_tile_water = water_tile.instantiate()
					add_child(new_tile_water)
					new_tile_water.get_child(0).get_child(0).texture = load("res://assets/tiles/water.png")
					new_tile_water.global_position = Vector2(renderGrid[x][y][0]+playerPosRoundedX, renderGrid[x][y][1]+playerPosRoundedY+32)
				else:
					# пол
					new_tile.get_child(0).get_child(0).texture = load("res://assets/tiles/grass.png")
					# стена
					new_tile.get_child(0).get_child(1).texture = load("res://assets/tiles/grass_wall.png")
					new_tile.global_position = Vector2(renderGrid[x][y][0]+playerPosRoundedX, renderGrid[x][y][1]+playerPosRoundedY)
		
		
		
