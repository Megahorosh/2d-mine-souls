# StatePlayer.gd
class_name StatePlayer
extends State

var player: Player

func _ready() -> void:
	player = owner as Player
