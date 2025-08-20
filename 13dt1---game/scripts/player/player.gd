extends CharacterBody2D

signal hp_changed(new_hp: int)
signal energy_changed(new_energy: int)

@export var speed : float = 200.0
@export var animation : AnimationPlayer

# Sets variables to default vaules before they are changed in the code. 
var last_direction : String = "down"
var axis : String = "none"
var max_hp : int = 12
var current_hp : int = max_hp
var is_alive : bool = true
var max_energy : int = 4
var current_energy : int = max_energy

# Emits signals for inital HP and energy to synchronise the HUD on scene start. 
func _ready() -> void:
	emit_signal("hp_changed", current_hp)
	emit_signal("energy_changed", current_energy)

func _physics_process(delta: float) -> void:
	# Sets the movement direction to no movement. 
	var direction := Vector2.ZERO
	
	# Updates direction and animation direction based on player inputs.  
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		if axis == "horizontal":
			last_direction = "right"
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		if axis == "horizontal":
			last_direction = "left"
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		if axis == "vertical":
			last_direction = "up"
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		if axis == "vertical":
			last_direction = "down"
	
	# Prioitises an axis animation depending on the direction last traveled.
	if direction == Vector2.ZERO:
		axis = "none"
	elif abs(direction.x) > 0 and abs(direction.y) == 0:
		axis = "horizontal"
	elif abs(direction.x) == 0 and abs(direction.y) > 0:
		axis = "vertical"
	
	# Normalise non-zero direction for consistent speed and set velocity.
	if direction != Vector2.ZERO and is_alive:
		direction = direction.normalized()
		velocity = direction * speed
	# If no direction is set, stop movement.
	else:
		velocity = Vector2.ZERO
	
	# Runs the update animation function. 
	update_animation()
	
	# Moves the character based on their velocity. 
	move_and_slide()

# Updates animations based on player inputs and if they are alive.  
func update_animation() -> void:
	# Checks if the player has more than 0 remaining health to run the correcrt animations.
	if is_alive:
		if velocity == Vector2.ZERO:
			animation.play("idle_" + last_direction)
		else:
			animation.play("move_" + last_direction)
	else:
		animation.play("death")

# Decreases HP by an amount, clamps it within a valid range, then emits hp_changed.
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	if current_hp == 0:
		is_alive = false
		die()
	emit_signal("hp_changed", current_hp)

# Increases HP by an amount, clamps it within a valid range, then emits hp_changed.
func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	emit_signal("hp_changed", current_hp)

# Waits for the death animation to finish, then reloads the current scene. 
func die() -> void:
	await animation.animation_finished
	get_tree().reload_current_scene()

# Comsumes energy if enough is available, emits energy_changed, and returns if it suceeded. 
func use_energy(amount: int) -> bool:
	if current_energy >= amount:
		current_energy -= amount
		emit_signal("energy_changed", current_energy)
		return true
	return false

# Restores a specific amount of energy, clamps it within a valid range, then emits energy_changed.
func restore_energy(amount: int) -> void:
	current_energy = min(current_energy + amount, max_energy)
	emit_signal("energy_changed", current_energy)
