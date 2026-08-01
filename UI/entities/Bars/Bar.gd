extends Node

var bar_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar_sprite = get_child(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar_sprite.scale.x = PlayerCharacteristics.player_stamina / 100
