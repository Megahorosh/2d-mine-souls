extends StatePlayer

# ===== НАСТРОЙКИ ШАГА =====
const STEP_SPEED: float = 500.0        # Скорость шага вперёд
const STEP_START: float = 0.4          # Когда начинается шаг (0.0 - 1.0) - 50% атаки
const STEP_END: float = 0.6            # Когда заканчивается шаг (0.0 - 1.0) - 90% атаки
const STEP_FADE: bool = true           # Плавное замедление в конце
const STEP_FADE_STRENGTH: float = 0.7  # Сила замедления (0.0 - 1.0)
# ===========================

# Переменные состояния
var start_time: float = 0.0
var stamina_consumed: bool = false
var attack_direction: Vector2 = Vector2.ZERO

# Параметры атаки
var stamina_cost: float = 25
var attack_duration: float = 1.3

func enter(_msg: Dictionary = {}) -> void:
	Player.isLightAttacking = true
	start_time = Time.get_ticks_msec() / 1000.0
	stamina_consumed = false
	
	# Запоминаем направление атаки (взгляд игрока)
	attack_direction = Player.playerLastDirection
	
	# Проверяем стамину
	if Player.player_stamina >= stamina_cost:
		Player.player_stamina -= stamina_cost
		stamina_consumed = true
		# Запускаем анимацию
		player.animation.play("light_attack_alebarda")
		print("light_attack_alebarda")
	else:
		# Если стамины не хватило - сразу выходим
		stateMachine.changeTo("Idle")
		return
	
	$"../../../Debug/VBoxContainer/state".text = name

func exit() -> void:
	Player.isLightAttacking = false
	# Сбрасываем скорость при выходе из состояния
	player.move_controller.velocity = Vector2.ZERO

func inner_physics_process(_delta: float) -> void:
	# Проверяем время атаки
	var elapsed = Time.get_ticks_msec() / 1000.0 - start_time
	
	# Если атака активна и стамина потрачена - двигаемся вперёд
	if elapsed < attack_duration and stamina_consumed:
		# Вычисляем прогресс атаки (0.0 - 1.0)
		var attack_progress = elapsed / attack_duration
		
		# Проверяем, находимся ли в диапазоне шага
		if attack_progress >= STEP_START and attack_progress <= STEP_END:
			# Вычисляем прогресс внутри шага (0.0 - 1.0)
			var step_progress = (attack_progress - STEP_START) / (STEP_END - STEP_START)
			
			# Вычисляем множитель скорости
			var speed_multiplier: float = 1.0
			
			if STEP_FADE:
				# Плавное замедление в конце
				speed_multiplier = 1.0 - step_progress * STEP_FADE_STRENGTH
				# Дополнительно: плавное ускорение в начале (опционально)
				# speed_multiplier *= step_progress * 2.0  # раскомментировать для ускорения в начале
			else:
				# Постоянная скорость на всём протяжении шага
				speed_multiplier = 1.0
			
			# Применяем скорость
			player.move_controller.velocity = attack_direction * STEP_SPEED * speed_multiplier
			player.move_controller.move_and_slide()
		else:
			# Вне диапазона шага - стоим на месте
			player.move_controller.velocity = Vector2.ZERO
	
	# Проверяем завершение атаки
	if elapsed >= attack_duration or not stamina_consumed:
		# Сбрасываем скорость перед сменой состояния
		player.move_controller.velocity = Vector2.ZERO
		
		# Определяем следующее состояние
		var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if direction != Vector2.ZERO:
			if Input.is_action_pressed("sprint"):
				stateMachine.changeTo("Sprint")
			else:
				stateMachine.changeTo("Walk")
		else:
			stateMachine.changeTo("Idle")
		return  # Важно: выходим после смены состояния
	
	# Возможность прервать атаку роллом
	if Input.is_action_just_pressed("sprint"):
		player.move_controller.velocity = Vector2.ZERO
		stateMachine.changeTo("Roll")
