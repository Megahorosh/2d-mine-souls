extends Control

var dirLable: Label
var velLable: Label
var stateLable: Label
	
func _ready() -> void:
	dirLable = $VBoxContainer/direction
	velLable = $VBoxContainer/velocity
	stateLable = $VBoxContainer/state

func _process(delta: float) -> void:
	dirLable.text = "dir: " + str(Player.playerDirection)
	velLable.text = "vel: " + str(Player.playerVelocity)
