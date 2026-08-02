# Скрипт на CanvasLayer
extends Label

@export var line2d: Line2D

var fps_counter: float = 0.0
var fps_history = [1, 2, 3]
var max_samples: int = 200
var graph_height: float = 70

var max_fps: float = 0
var min_fps: float = 0

func _ready():
	line2d.default_color = Color.GREEN
	line2d.width = 2.0
	# Позиционируем график
	#line2d.position = Vector2(100, 35)

func _process(delta: float) -> void:
	var fps = 1.0 / delta
		
	max_fps = fps_history.max()
	min_fps = fps_history.min()
	
	fps_counter = lerp(fps_counter, fps, 0.1)
	text = "fps: " + str(int(fps_counter)) + "\n" \
		+ "min: " + str(int(min_fps)) + "\n" \
		+ "max: " + str(int(max_fps))
	
	fps_history.append(fps)
	if fps_history.size() > max_samples:
		fps_history.pop_front()
	
	update_graph()

func update_graph():
	var points = []
	var graph_width = max_samples  # Фиксированная ширина графика
	var x_step = graph_width / (max_samples - 1)
	var fps_median = get_median(fps_history)
	
	for i in range(fps_history.size()):
		var x = i * x_step
		var y = graph_height - (clamp(fps_history[i], 0, fps_median) / fps_median * graph_height)
		points.append(Vector2(x, y))
	
	line2d.points = PackedVector2Array(points)



func get_median(numbers: Array) -> float:
	if numbers.is_empty():
		return 0.0  # или выбросить ошибку
	
	# 1. Создаем копию и сортируем (чтобы не изменять исходный массив)
	var sorted = numbers.duplicate()
	sorted.sort()
	
	var size = sorted.size()
	var mid = size / 2
	
	# 2. Проверяем четность
	if size % 2 == 1:
		# Нечетное количество - берем средний элемент
		return sorted[mid]
	else:
		# Четное количество - среднее арифметическое двух центральных
		return (sorted[mid - 1] + sorted[mid]) / 2.0
