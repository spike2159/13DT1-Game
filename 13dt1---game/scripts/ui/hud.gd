extends CanvasLayer

# Variables for nodes are set in the inspector.
@export var player : CharacterBody2D
@export var heart_container : HBoxContainer
@export var energy_bar : TextureProgressBar

# On load, connect the player signals to their respective functions.
func _ready() -> void:
	player.connect("hp_changed", self._on_hp_changed)
	player.connect("energy_changed", self._on_energy_changed)

# Called when hp_changed signal is emitted, then updates heart container HP sprites.
func _on_hp_changed(new_hp: int) -> void:
	heart_container.set_hp(new_hp)

# Called when energy_changed signal is emitted, then updates the energy bar. 
func _on_energy_changed(new_energy: int) -> void:
	energy_bar.set_energy(new_energy)
