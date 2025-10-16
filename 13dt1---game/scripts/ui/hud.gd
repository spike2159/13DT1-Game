extends CanvasLayer

# Variables for nodes are set in the inspector.
@export var player: CharacterBody2D
@export var heart_container: HBoxContainer
@export var energy_bar: TextureProgressBar
@export var quiz_menu: Control
@export var pause_menu: Control
@export var resume_button: Button
@export var information_button: Button
@export var exit_game_button: Button
@export var information_menu: Control
@export var exit_information_button: Button
@export var main_menu_scene_path: String = "res://scenes/ui/main_menu.tscn"

# Variable for tracking UI states.
var is_paused: bool = false

# On load, connect the player signals to their respective functions.
func _ready() -> void:
	player.connect("hp_changed", self._on_hp_changed)
	player.connect("energy_changed", self._on_energy_changed)
	
	# Pass the player reference to the quiz menu if it has a set_player_reference() function.
	if quiz_menu.has_method("set_player_reference"):
		quiz_menu.set_player_reference(player)
	
	# Connect the buttons being pressed to their functions. 
	resume_button.pressed.connect(_on_resume_button_pressed)
	information_button.pressed.connect(_on_information_button_pressed)
	exit_information_button.pressed.connect(_on_exit_information_button_pressed)
	exit_game_button.pressed.connect(_on_quit_game_button_pressed)

# Called when hp_changed signal is emitted, then updates heart container HP sprites.
func _on_hp_changed(new_hp: int) -> void:
	heart_container.set_hp(new_hp)

# Called when energy_changed signal is emitted, then updates the energy bar. 
func _on_energy_changed(new_energy: int) -> void:
	energy_bar.set_energy(new_energy)

# Runs each frame, toggles the quiz menu and pause menu if the key is pressed.
func _process(_delta: float) -> void:
	# Runs the toggle quiz menu function in the quiz menu script if the key is pressed.
	if Input.is_action_just_pressed("toggle_quiz_menu"):
		quiz_menu.toggle_quiz_menu()
	
	# Runs the toggle pause menu function if the key is pressed.
	if Input.is_action_just_pressed("toggle_pause_menu"):
		toggle_pause_menu()


# Toggles the game's pause state and updates menu visibility.  
func toggle_pause_menu() -> void:
	# If paused, hide gameplay menus and resume the game.
	if is_paused:
		pause_menu.hide()
		information_menu.hide()
		get_tree().paused = false
		is_paused = false
	# Show gameplay menus and pause the game.
	else:
		pause_menu.show()
		information_menu.hide()
		get_tree().paused = true
		is_paused = true


# Toggles the pause menu when the resume button within the 
func _on_resume_button_pressed() -> void:
	toggle_pause_menu()


# Show information menu and hide pause menu when information button is pressed.
func _on_information_button_pressed() -> void:
	information_menu.show()
	pause_menu.hide()


# Hide information menu and show pause menu when exit information button is pressed.
func _on_exit_information_button_pressed() -> void:
		information_menu.hide()
		pause_menu.show()


# Unpause the game, then change the scene to the main menu.
func _on_quit_game_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(main_menu_scene_path)
