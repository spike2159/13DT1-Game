extends CharacterBody2D

signal hp_changed(new_hp: int)

@export var speed : float = 200.0
@export var animation : AnimationPlayer

# Sets variables to default vaules before they are changed in the code. 
var last_direction : String = "down"
var axis : String = "none"
var max_hp : int = 12
var current_hp : int = max_hp

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
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	# If no direction is set, stop movement.
	else:
		velocity = Vector2.ZERO
	
	# Runs the update animation function. 
	update_animation()
	
	# Moves the character based on their velocity. 
	move_and_slide()

# Updates animations based on the last directional input from the player.  
func update_animation() -> void:
	if velocity == Vector2.ZERO:
		animation.play("idle_" + last_direction)
	else:
		animation.play("move_" + last_direction)

# Decreases HP by an amount, clamps it within a valid range, then emits hp_changed.
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	emit_signal("hp_changed", current_hp)

# Increases HP by an amount, clamps it within a valid range, then emits hp_changed.
func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	emit_signal("hp_changed", current_hp)
