# Player.gd
class_name Player
extends Node

static var player_max_health: float = 100
static var player_max_stamina: float = 100

static var player_health: float = 100
static var player_stamina: float = 100

static var playerVelocity: Vector2 = Vector2.ZERO
static var playerDirection: Vector2 = Vector2.ZERO

static var isSprinting: bool = false
static var isDodging: bool = false
static var isWalking: bool = false
static var isLightAttacking: bool = false

static var move_controller: MoveController = null

@onready var animation = $AnimationPlayer
#@onready var weapon_animation = $AnimationPlayer
