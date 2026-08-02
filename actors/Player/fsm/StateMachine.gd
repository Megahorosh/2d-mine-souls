# StateMachine.gd
class_name StateMachine
extends Node

@export var startState: NodePath

@onready var state: State = get_node(startState)
var move_controller: MoveController

func _ready() -> void:
	for child in get_children():
		child.stateMachine = self
	state.enter()

func _unhandled_input(event: InputEvent) -> void:
	state.inner_unhandled_input(event)

func _process(delta: float) -> void:
	state.inner_process(delta)
	
func _physics_process(delta: float) -> void:
	state.inner_physics_process(delta)


func changeTo(targetState: String, msg: Dictionary={}):
	if not has_node(targetState):
		print("Target state not found: ", targetState)
		return
	state.exit()
	state = get_node(targetState)
	state.enter(msg)
	print("Current state: ", state.name)
