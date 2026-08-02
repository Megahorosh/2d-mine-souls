extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 30.0   # Скорость разгона (чем больше, тем быстрее разгон)
@export var friction: float = 40.0       # Скорость торможения (чем больше, тем быстрее остановка)

@export var sprint_coeff: float = 2.0
@export var sprint_delay: float = 0.2

@export var dodge_coeff: float = 4.0
@export var dodge_duration: float = 0.2
@export var dodge_stamina_cost: float = 20

@export var stamina_substract_coeff: float = 20
@export var stamina_recovery_coeff: float = 20
@export var stamina_recovery_delay: float = 1

var sprint_timer: float = 0.0
var dodge_timer: float = 0.0
var stamina_recovery_timer: float = 0

var is_sprinting: bool = false
var is_dodging: bool = false
var dodge_stamina_consumed: bool = false

func _physics_process(delta: float) -> void:	
	# Получаем направление от -1 до 1
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Обновляем таймер удержания
	if Input.is_action_pressed("sprint") and direction != Vector2.ZERO:
		sprint_timer += delta
		if sprint_timer >= sprint_delay:
			is_sprinting = true
	else:
		if (sprint_timer > 0 and sprint_timer < sprint_delay):
			is_dodging = true
		sprint_timer = 0.0
		is_sprinting = false


	var target_speed := speed
	var current_acceleration := acceleration
	var current_friction := friction

	if (is_sprinting and PlayerCharacteristics.player_stamina > 0):
		stamina_recovery_timer = 0
		target_speed = speed * sprint_coeff
		current_acceleration = acceleration * sprint_coeff
		current_friction = friction * sprint_coeff
		if (PlayerCharacteristics.player_stamina > 0):
			PlayerCharacteristics.player_stamina -= stamina_substract_coeff * delta
		else:
			PlayerCharacteristics.player_stamina = 0
	else:
		stamina_recovery_timer += delta
		
		if (PlayerCharacteristics.player_stamina < PlayerCharacteristics.player_max_stamina):
			if (stamina_recovery_timer > stamina_recovery_delay):
				PlayerCharacteristics.player_stamina += stamina_recovery_coeff * delta
		else:
			PlayerCharacteristics.player_stamina = PlayerCharacteristics.player_max_stamina
		
		
	if (is_dodging and dodge_timer <= dodge_duration):
		stamina_recovery_timer = 0
		dodge_timer += delta
		target_speed = speed * dodge_coeff
		current_acceleration = acceleration * dodge_coeff
		current_friction = friction * dodge_coeff
		
		if !dodge_stamina_consumed and PlayerCharacteristics.player_stamina >= dodge_stamina_cost:
			PlayerCharacteristics.player_stamina -= dodge_stamina_cost
			dodge_stamina_consumed = true
		elif !dodge_stamina_consumed and PlayerCharacteristics.player_stamina < dodge_stamina_cost:
			# Если стамины не хватает - отменяем уворот
			is_dodging = false
			dodge_timer = 0
			dodge_stamina_consumed = false

	else:
		is_dodging = false
		dodge_timer = 0
		dodge_stamina_consumed = false
	
	# Если есть ввод - разгоняемся
	if direction != Vector2.ZERO:
		# Плавно увеличиваем скорость до максимума
		velocity = velocity.move_toward(direction * target_speed, current_acceleration)
	else:
		# Если ввода нет - плавно тормозим
		velocity = velocity.move_toward(Vector2.ZERO, current_friction)
	
	move_and_slide()
	
	
	
	
	
	
