extends CharacterBody2D

@export var speed : float = 200.0
@export var animation : AnimationPlayer

# Sets varibles to default vaules before they are changed in the code. 
var last_direction : String = "down"
var axis : String = "none"

func _physics_process(delta: float) -> void:
	# Sets the movement direction to no movement. 
	var direction = Vector2.ZERO
	
	# Updates direction based on player inputs..  
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
	
	# If direction is not zero, normalize it for consistent movement speed and set velocity.
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
