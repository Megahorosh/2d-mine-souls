# idle.gd
extends StatePlayer

func enter(_msg: Dictionary = {}) -> void:
	$"../../../Debug/VBoxContainer/state".text = name

func inner_physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if Input.is_action_just_pressed("light_attack"):
		stateMachine.changeTo("LightAttack")
		return
		
	if direction != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			stateMachine.changeTo("Sprint")
		else:
			stateMachine.changeTo("Walk")
	
	player.animation.play("idle")
