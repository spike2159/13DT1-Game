extends TextureProgressBar

# Energy varibles for the player's current and maximum. 
@export var max_energy : int = 4
@export var current_energy : int = max_energy

# Initialise energy bar UI to match current energy on scene load. 
func _ready() -> void:
	max_value = max_energy
	value = current_energy

# When energy changes, clamp the new value to a valid range, then update progress bar amount.
func set_energy(energy_value: int) -> void:
	current_energy = clamp(energy_value, min_value, max_value)
	value = current_energy
