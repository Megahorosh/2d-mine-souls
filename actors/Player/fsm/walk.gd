# walk.gd
extends StatePlayer

func enter(_msg: Dictionary = {}) -> void:
	Player.isWalking = true
	$"../../Debug/VBoxContainer/state".text = name

func exit() -> void:
	Player.isWalking = false

func inner_physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction == Vector2.ZERO:
		stateMachine.changeTo("Idle")
	elif Input.is_action_pressed("sprint") and Player.player_stamina > 0:
		stateMachine.changeTo("Sprint")
	
	player.animation.play("walk")
