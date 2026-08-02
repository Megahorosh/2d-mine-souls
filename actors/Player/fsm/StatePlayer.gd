# StatePlayer.gd
class_name StatePlayer
extends State

var player: Player

func _ready() -> void:
	# Вместо owner используем get_parent().get_parent()
	player = get_parent().get_parent() as Player
