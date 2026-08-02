extends Node

@export var Player: Node2D
@export var tile: PackedScene
@export var water_tile: PackedScene
@export var tile_size_x: int = 64
@export var tile_size_y: int = 48

var renderGrid = []
var renderGridSizeX: float = 32
var renderGridSizeY: float = 27

var playerPosRoundedX: float = 0
var playerPosRoundedY: float = 0

# Кеш созданных тайлов: ключ Vector2i(tile_x, tile_y) -> { "ground": узел, "water": узел или null }
var existing_tiles := {}

# Текстуры (preload для быстродействия)
var tex_water_bottom = preload("res://assets/tiles/water_bottom.png")
var tex_water = preload("res://assets/tiles/water.png")
var tex_grass = preload("res://assets/tiles/grass.png")
var tex_grass_wall = preload("res://assets/tiles/grass_wall.png")

func _ready() -> void:
	playerPosRoundedX = round(Player.global_position.x / tile_size_x) * tile_size_x
	playerPosRoundedY = round(Player.global_position.y / tile_size_y) * tile_size_y

	for x in range(renderGridSizeX):
		renderGrid.append([])
		for y in range(renderGridSizeY):
			renderGrid[x].append([x * tile_size_x, y * tile_size_y])

	if tile == null:
		print("Ошибка: tile не назначен в инспекторе!")
		return
	print("Тайл назначен")

	# Первичная отрисовка
	gridRefresh()

func _process(delta: float) -> void:
	var currentTileX = Player.global_position.x / tile_size_x - renderGridSizeX / 2
	var currentTileY = Player.global_position.y / tile_size_y - renderGridSizeY / 2

	var newRoundedX = round(currentTileX) * tile_size_x
	var newRoundedY = round(currentTileY) * tile_size_y

	if newRoundedX != playerPosRoundedX or newRoundedY != playerPosRoundedY:
		playerPosRoundedX = newRoundedX
		playerPosRoundedY = newRoundedY
		gridRefresh()

func gridRefresh() -> void:
	# Собираем множество ключей, которые должны быть видны
	var needed_keys := {}
	var base_tile_x = int(playerPosRoundedX / tile_size_x)
	var base_tile_y = int(playerPosRoundedY / tile_size_y)

	for x in range(renderGridSizeX):
		for y in range(renderGridSizeY):
			var tile_coord = Vector2i(base_tile_x + x, base_tile_y + y)
			needed_keys[tile_coord] = true

			if not existing_tiles.has(tile_coord):
				# --- Создаём новый тайл ---
				# Мировые координаты для позиционирования
				var world_x = playerPosRoundedX + x * tile_size_x
				var world_y = playerPosRoundedY + y * tile_size_y

				var ground_node = tile.instantiate()
				add_child(ground_node)

				var water_node = null
				var depth_value = Worldgen.world[tile_coord.x][tile_coord.y]

				if depth_value < 0.5:
					# Вода: дно + водная поверхность
					ground_node.get_child(0).get_child(0).texture = tex_water_bottom
					ground_node.global_position = Vector2(world_x, world_y + 64)
					ground_node.z_index = -2

					water_node = water_tile.instantiate()
					add_child(water_node)
					water_node.get_child(0).get_child(0).texture = tex_water
					water_node.global_position = Vector2(world_x, world_y + 24)
				else:
					# Суша: трава + стена
					ground_node.get_child(0).get_child(0).texture = tex_grass
					ground_node.get_child(0).get_child(1).texture = tex_grass_wall
					ground_node.global_position = Vector2(world_x, world_y)

				existing_tiles[tile_coord] = {
					"ground": ground_node,
					"water": water_node
				}
	var sorted_children = []
	for child in get_children():
		sorted_children.append(child)
	# Сортируем: сначала по Y, потом по X
	sorted_children.sort_custom(func(a, b): 
		if a.global_position.y != b.global_position.y:
			return a.global_position.y < b.global_position.y
		return a.global_position.x < b.global_position.x
	)

	for i in range(sorted_children.size()):
		move_child(sorted_children[i], i)

	# Удаляем тайлы, которые больше не нужны
	var to_remove := []
	for key in existing_tiles.keys():
		if not needed_keys.has(key):
			to_remove.append(key)

	for key in to_remove:
		var tile_data = existing_tiles[key]
		if tile_data.water:
			tile_data.water.queue_free()
		if tile_data.ground:
			tile_data.ground.queue_free()
		existing_tiles.erase(key)
