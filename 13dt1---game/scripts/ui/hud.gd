extends CanvasLayer

# Variables for nodes are set in the inspector.
@export var player: CharacterBody2D
@export var heart_container: HBoxContainer
@export var energy_bar: TextureProgressBar
@export var quiz_menu: Control

# On load, connect the player signals to their respective functions.
func _ready() -> void:
	player.connect("hp_changed", self._on_hp_changed)
	player.connect("energy_changed", self._on_energy_changed)
	
	# Pass the player reference to the quiz menu if it has a set_player_reference() function.
	if quiz_menu.has_method("set_player_reference"):
		quiz_menu.set_player_reference(player)

# Called when hp_changed signal is emitted, then updates heart container HP sprites.
func _on_hp_changed(new_hp: int) -> void:
	heart_container.set_hp(new_hp)

# Called when energy_changed signal is emitted, then updates the energy bar. 
func _on_energy_changed(new_energy: int) -> void:
	energy_bar.set_energy(new_energy)

# Runs each frame, toggles the quiz menu if the key is pressed.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_quiz_menu"):
		quiz_menu.toggle_quiz_menu()
