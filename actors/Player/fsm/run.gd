# run.gd
extends StatePlayer

var start_time: float = 0.0

func enter(_msg: Dictionary = {}) -> void:
	Player.isSprinting = true
	start_time = Time.get_ticks_msec() / 1000.0   # время в секундах
	$"../../../Debug/VBoxContainer/state".text = name

func exit() -> void:
	Player.isSprinting = false

func inner_physics_process(_delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	player.animation.play("sprint")
	
	if Input.is_action_just_pressed("light_attack"):
		stateMachine.changeTo("LightAttack")
		return
	# Если перестали двигаться – сразу в Idle
	if direction == Vector2.ZERO:
		stateMachine.changeTo("Idle")
		return
		
	if Player.player_stamina <= 0:
		stateMachine.changeTo("Walk")
		return
	
	# Кнопка спринта всё ещё зажата – остаёмся в Sprint
	if Input.is_action_pressed("sprint"):
		return
	
	# Кнопку спринта отпустили – проверяем, как долго она была зажата
	var held_duration = Time.get_ticks_msec() / 1000.0 - start_time
	var sprint_delay = Player.move_controller.sprint_delay   # получаем из MoveController
	
	if held_duration < sprint_delay:
		# Короткое нажатие → уворот (dodge)
		stateMachine.changeTo("Roll")
	else:
		# Долгое нажатие → обычная ходьба (направление уже != 0)
		stateMachine.changeTo("Walk")
