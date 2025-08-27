class_name Skill
extends Node

# Default variables used in each skill.
var energy_cost: int
var cooldown: float
var on_cooldown: bool = false

# Sets the skill on cooldown for its duration, then resets it. 
func start_cooldown(node: Node) -> void:
	on_cooldown = true
	await node.get_tree().create_timer(cooldown).timeout
	on_cooldown = false
