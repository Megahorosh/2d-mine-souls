# MoveController.gd
class_name MoveController
extends CharacterBody2D

@export var speed: float = 200.0
@export var acceleration: float = 30.0
@export var friction: float = 40.0

@export var sprint_coeff: float = 2.0
@export var sprint_delay: float = 0.2

@export var dodge_coeff: float = 4.0
@export var dodge_duration: float = 0.2
@export var dodge_stamina_cost: float = 20

@export var stamina_substract_coeff: float = 20
@export var stamina_recovery_coeff: float = 20
@export var stamina_recovery_delay: float = 1

var stamina_recovery_timer: float = 0

func _ready() -> void:
	Player.move_controller = self

func _physics_process(delta: float) -> void:	
	Player.playerVelocity = velocity
	
	# Получаем направление от -1 до 1
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	Player.playerDirection = direction
	
	var target_speed := speed
	var current_acceleration := acceleration
	var current_friction := friction

	# Логика спринта
	if Player.isSprinting and Player.player_stamina > 0:
		stamina_recovery_timer = 0
		target_speed = speed * sprint_coeff
		current_acceleration = acceleration * sprint_coeff
		current_friction = friction * sprint_coeff
		Player.player_stamina = max(0, Player.player_stamina - stamina_substract_coeff * delta)
	else:
		# Восстановление стамины
		if not Player.isDodging:  # не восстанавливаем во время уворота
			stamina_recovery_timer += delta
			if Player.player_stamina < Player.player_max_stamina:
				if stamina_recovery_timer > stamina_recovery_delay:
					Player.player_stamina = min(Player.player_max_stamina, Player.player_stamina + stamina_recovery_coeff * delta)
		
	# Логика уворота
	if Player.isDodging:
		stamina_recovery_timer = 0
		target_speed = speed * dodge_coeff
		current_acceleration = acceleration * dodge_coeff
		current_friction = friction * dodge_coeff
	
	# Применяем движение
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * target_speed, current_acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, current_friction)
	
	move_and_slide()
