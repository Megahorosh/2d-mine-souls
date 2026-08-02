extends Label

var fps_counter = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fps_counter = lerp(fps_counter, 1.0 / delta, 0.2)  # Сглаживание
	text = str(round(fps_counter)) + " FPS"
