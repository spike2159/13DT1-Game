extends Area2D

# Amount of HP healed by the heal_square.
@export var heal_amount : int = 1

# Heals the player when the hurtbox area collides.
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent()
		player.heal(heal_amount)
