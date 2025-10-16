extends Control

const MAIN_MENU_SCENE_PATH: String = "res://scenes/ui/main_menu.tscn"
const GAME_SCENE_PATH: String = "res://scenes/world/world.tscn"

# Variables for nodes set in the inspector.
@export var retry_game_button: Button
@export var main_menu_button: Button


# On load, connects the buttons being pressed to their functions.
func _ready() -> void:
	retry_game_button.pressed.connect(_on_retry_game_button_pressed)
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)


# Reloads the game scene to restart the game when the retry button is pressed.
func _on_retry_game_button_pressed() -> void:
	get_tree().change_scene_to_file(GAME_SCENE_PATH)


# Switch to the main menu scene when the return to main menu button is pressed.
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE_PATH)
