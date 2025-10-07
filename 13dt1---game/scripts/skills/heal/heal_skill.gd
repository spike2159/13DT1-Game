extends Skill

# Amount of HP the heal skill restores.
@export var heal_amount: int = 4

const DEFAULT_ENERGY_COST: int = 2
const DEFAULT_COOLDOWN: float = 5.0

# Preloaded heal effect scene for spwaning particles. 
@export var heal_effect_scene: PackedScene = preload("res://scenes/skills/heal/heal_effect.tscn")

# Set the values for the skill class varibles.
func _init() -> void:
	energy_cost = DEFAULT_ENERGY_COST
	cooldown = DEFAULT_COOLDOWN

# Runs when the player uses the heal skill.
func use_skill(caster: CharacterBody2D) -> void:
	# Heals the caster.
	caster.heal(heal_amount)
	
	# Spwan heal particle effect as a child of the player, so it follows them.
	var effect: Node2D = heal_effect_scene.instantiate()
	effect.position = Vector2.ZERO
	caster.add_child(effect)
