extends Control

# Constant varibles for quiz .json file paths.
const COMPLEX_QUIZ_PATH: String = "res://resoruces/quizzes/complex_numbers_quiz.json"
const DIFFERENTIATION_QUIZ_PATH: String = "res://resoruces/quizzes/differentiation_quiz.json"
const INTEGRATION_QUIZ_PATH: String = "res://resoruces/quizzes/integration_quiz.json"

# Variables for nodes set in the inspector.
@export var close_quiz_menu_button: Button
@export var select_quiz_menu: Control
@export var quiz_panel: Control
@export var complex_quiz_button: Button
@export var differentiation_quiz_button: Button
@export var integration_quiz_button: Button
@export var player: CharacterBody2D


# On load, connects the buttons being pressed to their functions.
func _ready() -> void:
	close_quiz_menu_button.pressed.connect(_on_close_quiz_menu_button_pressed)
	complex_quiz_button.pressed.connect(_on_complex_quiz_button_pressed)
	differentiation_quiz_button.pressed.connect(_on_differentiation_quiz_button_pressed)
	integration_quiz_button.pressed.connect(_on_integration_quiz_button_pressed)


# Show the quiz menu and pauses the game.
func open_quiz_menu() -> void:
	visible = true
	get_tree().paused = true


# Hide the quiz menu and unpauses the game.
func _on_close_quiz_menu_button_pressed() -> void:
	visible = false
	get_tree().paused = false


# Toggles the quiz menu, called from the HUD script.
func toggle_quiz_menu() -> void:
	if visible:
		_on_close_quiz_menu_button_pressed()
	else:
		open_quiz_menu()


# Opens the quiz panel for the complex numbers quiz.
func _on_complex_quiz_button_pressed() -> void:
	_show_quiz_panel(COMPLEX_QUIZ_PATH)


# Opens the quiz panel for the differentiation quiz.
func _on_differentiation_quiz_button_pressed() -> void:
	_show_quiz_panel(DIFFERENTIATION_QUIZ_PATH)


# Opens the quiz panel for the integration quiz.
func _on_integration_quiz_button_pressed() -> void:
	_show_quiz_panel(INTEGRATION_QUIZ_PATH)


# Stores the player refrence for use in the quiz system
func set_player_reference(player_reference: CharacterBody2D) -> void:
	player = player_reference


# Hides the select quiz menu, show quiz panel, and loads the selected quiz.
func _show_quiz_panel(quiz_path: String) -> void:
	# Hide the select quiz menu if it exists.
	if select_quiz_menu:
		select_quiz_menu.hide()
	
	# Show the quiz panel if it exists. 
	if quiz_panel:
		quiz_panel.show()
		# Load the quiz with the given quiz path and player reference if availble.
		if quiz_panel.has_method("load_quiz"):
			quiz_panel.load_quiz(quiz_path, player)
