# roll.gd
extends StatePlayer

var start_time: float = 0.0
var stamina_consumed: bool = false

func enter(_msg: Dictionary = {}) -> void:
	Player.isDodging = true
	start_time = Time.get_ticks_msec() / 1000.0
	stamina_consumed = false
	
	# Попытка потратить стамину
	var cost = Player.move_controller.dodge_stamina_cost
	if Player.player_stamina >= cost:
		Player.player_stamina -= cost
		stamina_consumed = true
	# если стамины не хватило, можно сразу выйти (флаг останется false)
	
	$"../../../Debug/VBoxContainer/state".text = name

func exit() -> void:
	Player.isDodging = false

func inner_physics_process(_delta: float) -> void:
	var elapsed = Time.get_ticks_msec() / 1000.0 - start_time
	var duration = Player.move_controller.dodge_duration
	
	if elapsed >= duration or not stamina_consumed:
		# Уворот завершён или не удался из-за нехватки стамины
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction != Vector2.ZERO:
			if Input.is_action_pressed("sprint"):
				stateMachine.changeTo("Sprint")
			else:
				stateMachine.changeTo("Walk")
		else:
			stateMachine.changeTo("Idle")

	player.animation.play("roll")
