extends CharacterBody2D

@export var speed : float = 200.0

func _physics_process(delta: float) -> void:
	# Sets the movement direction to no movement. 
	var direction = Vector2.ZERO
	
	# Updates direction based on player inputs..  
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	# If direction is not zero, normalize it for consistent movement speed and set velocity.
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * speed
	# If no direction is set, stop movement.
	else:
		velocity = Vector2.ZERO
	
	# Moves the character based on their velocity. 
	move_and_slide()
