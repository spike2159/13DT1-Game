extends CanvasLayer

# Variables for player and heart container nodes are set in the inspector.
@export var player : CharacterBody2D
@export var heart_container : HBoxContainer

# On load, connect the player's hp_changed signal to _on_hp_changed function.
func _ready() -> void:
	player.connect("hp_changed", self._on_hp_changed)

# Called when hp_changed signal is emitted, then updates heart container HP sprites.
func _on_hp_changed(new_hp: int) -> void:
	heart_container.set_hp(new_hp)
