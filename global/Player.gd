# Player.gd
class_name Player
extends Node

static var player_max_health: float = 150
static var player_max_stamina: float = 70
static var player_max_mana: float = 50

static var player_health: float = player_max_health
static var player_stamina: float = player_max_stamina
static var player_mana: float = player_max_mana

static var playerVelocity: Vector2 = Vector2.ZERO
static var playerDirection: Vector2 = Vector2.ZERO
static var playerLastDirection: Vector2 = Vector2.RIGHT

static var isSprinting: bool = false
static var isDodging: bool = false
static var isWalking: bool = false
static var isLightAttacking: bool = false

static var move_controller: MoveController = null

@onready var animation = $AnimationPlayer
