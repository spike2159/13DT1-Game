extends Camera2D

# Variables for the camera area and the player node.
@export var area_size: Vector2
@export var player: CharacterBody2D

func _ready() -> void:
	# Positions camera then awaits a frame to prevent smoothing the starting position.
	update_screen_position()
	await get_tree().process_frame
	
	# Enables smoothing for camera movement.
	position_smoothing_enabled = true
	position_smoothing_speed = 5.0
	
	# Zoom camera to fit exactly one area in the viewport.
	var viewport_size = get_viewport_rect().size
	zoom = Vector2(viewport_size.x / area_size.x, viewport_size.y / area_size.y)

# Updates camera position each physics frame. 
func _physics_process(_delta: float) -> void:
	update_screen_position()

# Centres camera on the room the player is currently in.
func update_screen_position() -> void:
	var player_position = player.global_position
	global_position = floor(player_position / area_size) * area_size + area_size / 2
