extends Node

var bar_sprite
var background_sprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar_sprite = get_child(2)
	background_sprite = get_child(1)
	#background_sprite.global_position = bar_sprite.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	bar_sprite.scale.x = Player.player_stamina / 75
	background_sprite.scale.x = Player.player_max_stamina / 75
