extends Node

var bar_sprite
var background_sprite
var progressBar: ProgressBar

var healthBG: StyleBoxFlat
var healthFill: StyleBoxFlat

var staminaBG: StyleBoxFlat
var staminaFill: StyleBoxFlat

var manaBG: StyleBoxFlat
var manaFill: StyleBoxFlat

@export var progressBarHeight: float = 12

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar = $ProgressBar
	progressBar.size.y = progressBarHeight
	print("name: ", name, "   parent name: ", get_parent().name)
	
	healthBG = load("res://UI/Themes/StatesBars/Health/HealthProgressBarBackground.tres")
	healthFill = load("res://UI/Themes/StatesBars/Health/HealthProgressBarFill.tres")
	
	staminaBG = load("res://UI/Themes/StatesBars/Stamina/StaminaProgressBarBackground.tres")
	staminaFill = load("res://UI/Themes/StatesBars/Stamina/StaminaProgressBarFill.tres")
	
	manaBG = load("res://UI/Themes/StatesBars/Mana/StaminaProgressBarBackground.tres")
	manaFill = load("res://UI/Themes/StatesBars/Mana/StaminaProgressBarFill.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (name.to_lower() == "health"):
		set_health()
	elif (name.to_lower() == "stamina"):
		set_stamina()
	elif (name.to_lower() == "mana"):
		set_mana()
	else:
		print("No such function for this parametr: ", name)
	
	

func set_health() -> void:
	progressBar.add_theme_stylebox_override("background", healthBG)
	progressBar.add_theme_stylebox_override("fill", healthFill)
	
	progressBar.size.x = Player.player_max_health
	progressBar.max_value = Player.player_max_health
	progressBar.value = Player.player_health

func set_stamina() -> void:
	progressBar.add_theme_stylebox_override("background", staminaBG)
	progressBar.add_theme_stylebox_override("fill", staminaFill)
	
	progressBar.size.x = Player.player_max_stamina
	progressBar.max_value = Player.player_max_stamina
	progressBar.value = Player.player_stamina
	
func set_mana() -> void:
	progressBar.add_theme_stylebox_override("background", manaBG)
	progressBar.add_theme_stylebox_override("fill", manaFill)
	
	progressBar.size.x = Player.player_max_mana
	progressBar.max_value = Player.player_max_mana
	progressBar.value = Player.player_mana
