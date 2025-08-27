extends Area2D

# Amount of energy restored by the square.
@export var energy_restorted_amount: int = 1

# Restores energy to the player when the hurtbox area collides. 
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent()
		player.restore_energy(energy_restorted_amount)
