# light_attack.gd
extends StatePlayer

var start_time: float = 0.0
var stamina_consumed: bool = false

var stamina_cost: float = 25
var attack_duration: float = 1.3

func enter(_msg: Dictionary = {}) -> void:
	Player.isLightAttacking = true
	start_time = Time.get_ticks_msec() / 1000.0
	stamina_consumed = false
	
	# Используем правильную переменную stamina_cost
	if Player.player_stamina >= stamina_cost:
		Player.player_stamina -= stamina_cost
		stamina_consumed = true
		# Запускаем анимацию только если хватило стамины
		#player.animation.play("light_attack_alebarda")
		player.animation.play("light_attack_alebarda")
		print("light_attack_alebarda")
	else:
		# Если стамины не хватило - сразу выходим
		stateMachine.changeTo("Idle")
		return
	
	$"../../../Debug/VBoxContainer/state".text = name

func exit() -> void:
	Player.isLightAttacking = false

func inner_physics_process(_delta: float) -> void:
	# Проверяем время атаки
	var elapsed = Time.get_ticks_msec() / 1000.0 - start_time
	
	if elapsed >= attack_duration or not stamina_consumed:
		# Атака завершена
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction != Vector2.ZERO:
			if Input.is_action_pressed("sprint"):
				stateMachine.changeTo("Sprint")
			else:
				stateMachine.changeTo("Walk")
		else:
			stateMachine.changeTo("Idle")
	
	# Можно добавить возможность прервать атаку (опционально)
	if Input.is_action_just_pressed("sprint"):
		stateMachine.changeTo("Roll")
