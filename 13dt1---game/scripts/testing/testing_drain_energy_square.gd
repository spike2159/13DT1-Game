extends Area2D

# Amount of energy drained by the square.
@export var energy_drained_amount : int = 1

# Drains energy to the player when the hurtbox area collides. 
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent()
		player.use_energy(energy_drained_amount)
