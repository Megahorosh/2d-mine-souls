# State.gd
class_name State
extends Node

var stateMachine = null
var move_controller: MoveController = null 

# inner - ничего не значит, прото это название, можно любое другое
func inner_unhandled_input(_event: InputEvent) -> void:
	pass
	
func inner_physics_process(_delta: float) -> void:
	pass
	
func inner_process(_delta: float) -> void:
	pass

func enter(_msg: Dictionary={}):
	pass
	
func exit():
	pass
	
