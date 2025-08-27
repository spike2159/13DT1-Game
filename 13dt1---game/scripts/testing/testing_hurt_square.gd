extends Area2D

# Amount of damage dealt by the hurt_square.
@export var damage_amount: int = 1

# Deals damage to the player when the hurtbox area collides. 
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hurtbox"):
		var player = area.get_parent()
		player.take_damage(damage_amount)
