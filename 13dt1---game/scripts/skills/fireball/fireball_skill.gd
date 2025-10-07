extends Skill

# Fireball projectile properties. 
@export var fireball_damage: int = 2
@export var fireball_speed: float = 300.0
@export var fireball_duration: float = 2.5

const DEFAULT_ENERGY_COST: int = 1
const DEFAULT_COOLDOWN: float = 3.0

# Sets the values for the skill class varibles.
func _init() -> void:
	energy_cost = DEFAULT_ENERGY_COST
	cooldown = DEFAULT_COOLDOWN

# Runs when the player uses the fireball skill.
func use_skill(caster: CharacterBody2D, mouse_position: Vector2) -> void:
	
	# Load the fireball scene, and create a fireball object for to the game.
	var fireball_projectile: PackedScene = preload(
		"res://scenes/skills/fireball/fireball_projectile.tscn"
		)
	var fireball: Area2D = fireball_projectile.instantiate()
	
	# Spawn the fireball at the player's position.
	fireball.position = caster.global_position
	
	# Normalised direction vector from player to mouse position for constant speed. 
	fireball.direction = (mouse_position - caster.global_position).normalized()
	
	# Assign fireball projectile properties. 
	fireball.damage = fireball_damage
	fireball.speed = fireball_speed
	fireball.duration = fireball_duration
	
	# Add the fireball projectile to the scene. 
	caster.get_parent().add_child(fireball)
