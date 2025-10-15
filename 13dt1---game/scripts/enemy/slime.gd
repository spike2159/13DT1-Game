extends CharacterBody2D

# Direction constants for animations.
const DIRECTION_RIGHT: String = "right"
const DIRECTION_LEFT: String = "left"
const DIRECTION_UP: String = "up"
const DIRECTION_DOWN: String = "down"

# Export variables set in the inspector.
@export var speed: float = 60.0
@export var animation: AnimationPlayer
@export var player_detection_area: Area2D
@export var max_hp: int = 1
@export var attack_damage: int = 1
@export var attack_interval: float = 0.5

# Variables set within functions.
var player: CharacterBody2D
var chasing: bool
var facing_direction: String
var current_hp: int
var target_player: CharacterBody2D
var attacking: bool

# Sets current_hp to max_hp when the scene starts.
func _ready() -> void:
	current_hp = max_hp


func _physics_process(_delta: float) -> void:
	# Moves towards the player if chasing, otherwise stop.
	if chasing and player:
		# Calculate normalised direction toward the player, then set the slime velocity.
		var direction := Vector2(player.global_position - global_position).normalized()
		velocity = direction * speed
		
		# Determine facing direction for movement animations, then play them.
		facing_direction = _get_facing_direction(direction)
		animation.play("move_" + facing_direction)
		
	else:
		# Stop movement when not chasing and play idle animation.
		velocity = Vector2.ZERO
		animation.play("idle")
	
	# Moves the slime and handles collisions. 
	move_and_slide()


# Returns primary facing direction based on a movement vector.
func _get_facing_direction(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			return DIRECTION_RIGHT
		else:
			return DIRECTION_LEFT
	else:
		if direction.y > 0:
			return DIRECTION_DOWN
		else:
			return DIRECTION_UP


# Begin chasing the player when they enter the detection area.
func _on_player_detection_area_body_entered(body: Node2D) -> void:
	# If the body is the player, store the refrence and set chasing to true.
	if body.is_in_group("player"):
		player = body
		chasing = true


# Stop chasing the player when they exit the detection area.
func _on_player_detection_area_body_exited(body: Node2D) -> void:
	# If the body is the player, clear the refrence and set chasing to false.
	if body.is_in_group("player"):
		player = null
		chasing = false


# Function to apply damage to the slime.
func take_damage(damage: int) -> void:
	# Subtracts damage from current_hp and clamp the result to prevent negative hp.
	current_hp = clamp(current_hp - damage, 0, max_hp)
	
	# If current_hp reaches 0 runs the die() function.
	if current_hp <= 0:
		die()


# Handles slime death.
func die() -> void:
	# Removes the slime from the scene.
	queue_free()


# Handles the slime attacking the player when they enter its attack range.
func _on_slime_attack_range_area_entered(area: Area2D) -> void:
	# If the collided area is the player's hurtbox start attacking.
	if area.is_in_group("player_hurtbox"):
		target_player = area.get_parent()
		if not attacking:
			attacking = true
			attack()


# Handles stopping the slime's attack when the player leaves its attack range.
func _on_slime_attack_range_area_exited(area: Area2D) -> void:
	# If the area exited is the player's hurtbox, stop attacking and clear reference.
	if area.is_in_group("player_hurtbox") and area.get_parent() == target_player:
		attacking = false
		target_player = null


# Deals damage to the player and repeats after a set interval while in range.
func attack() -> void:
	# If not attacking or the player is null stop the attack.
	if not attacking or target_player == null:
		return
	
	# Damages the player, waits for the attack interval, then run the attack() function again.
	target_player.take_damage(attack_damage)
	await get_tree().create_timer(attack_interval).timeout
	attack()
