extends Camera2D

@export var Player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if !Player:
		print("Player not found")
	#if global_position.distance_to(Player.global_position) > 100:
	global_position = lerp(global_position, Player.global_position + direction * 200, 0.03)
		#global_position = Player.global_position
