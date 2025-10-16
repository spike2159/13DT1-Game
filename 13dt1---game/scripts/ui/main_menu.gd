extends Control

# Variables for nodes set in the inspector.
@export var game_scene: PackedScene
@export var play_button: Button
@export var information_button: Button
@export var exit_button: Button
@export var information_menu: Control
@export var exit_information_button: Button
@export var title: NinePatchRect
@export var menu_buttons: NinePatchRect
@export var quit_game_button: Button


# On load, connects the buttons being pressed to their functions.
func _ready() -> void:
	play_button.pressed.connect(_on_play_button_pressed)
	information_button.pressed.connect(_on_information_button_pressed)
	exit_information_button.pressed.connect(_on_exit_information_button_pressed)
	quit_game_button.pressed.connect(_on_quit_game_button_pressed)


# Switch to game scene when Play button is pressed
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)


# Show info menu and hide title and menu buttons when info button is pressed.
func _on_information_button_pressed() -> void:
	information_menu.show()
	title.hide()
	menu_buttons.hide()


# Hide info menu and show title and menu buttons when close info button is pressed.
func _on_exit_information_button_pressed() -> void:
	information_menu.hide()
	title.show()
	menu_buttons.show()


# Quits the application when the quit game button is pressed.
func _on_quit_game_button_pressed() -> void:
	get_tree().quit()
