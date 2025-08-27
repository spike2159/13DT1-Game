extends Node2D

# AnimatedSprite2D for heal particles, set in the inspector.
@export var animation: AnimatedSprite2D


func _ready() -> void:
	# Play the heal animation once.
	animation.play("heal_effect")
	
	# Wait for the animation to finish, then remove the node.
	await animation.animation_finished
	queue_free()
