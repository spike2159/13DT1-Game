extends Control

# Variables for nodes set in the inspector.
@export var question_label: Label
@export var answer_container: HBoxContainer
@export var answer_buttons: Array[Button]
@export var feedback_container: HBoxContainer
@export var next_question_button: Button
@export var close_quiz_button: Button
@export var select_quiz_menu: Control

# Quiz data and gameplay variables.
var quiz_data: Array
var current_question: Dictionary
var player: CharacterBody2D
var energy_restored: int = 1

# Feedback answers for correct and incorrect answers.
var feedback_text: Dictionary[String, String] = {
	"correct": "Correct Answer!",
	"incorrect": "Incorrect Answer!\nCorrect Answer: %s",
}

# On load, connects the buttons being pressed to their functions.
func _ready() -> void:
	next_question_button.pressed.connect(show_next_question)
	close_quiz_button.pressed.connect(_on_exit_quiz)
	
	# Randomises question order.
	randomize()

# Loads a quiz from a JSON file, stores the player reference, and shows the first question.
func load_quiz(quiz_path: String, player_reference: CharacterBody2D) -> void:
	# Store the player reference for use in the quiz.
	player = player_reference
	
	# Open the quiz JSON file and report an error if it can't be read.
	var quiz_file := FileAccess.open(quiz_path, FileAccess.ModeFlags.READ)
	if not quiz_file:
		push_error("Failed to open quiz JSON")
		return
	
	# Read the entire JSON content as a string and close the file.
	var json_text: String = quiz_file.get_as_text()
	quiz_file.close()
	
	# Parse the JSON string into quiz data and report if empty.
	quiz_data = JSON.parse_string(json_text)
	if quiz_data.is_empty():
		push_error("Quiz file is empty")
		return
	
	# SHow the first random question from the loaded quiz.
	show_next_question()

func show_next_question() -> void:
	# Select a random question from the loaded quiz data.
	current_question = quiz_data[randi() % quiz_data.size()]
	
	# Display the question text in the question label.
	question_label.text = current_question["question"]
	
	# Duplicate and shuffle the answer options for randomness.
	var answers: Array = current_question["answers"].duplicate()
	answers.shuffle()
	
	# Update each answer button with text and connect its pressed signal.
	for i in range(answer_buttons.size()):
		# Set the button to a varible and update the text to the corresponding answer. 
		var button: Button = answer_buttons[i]
		button.text = answers[i]
		
		# Prepare the answer press handler and remove any existing connection. 
		var answer_pressed_function := Callable(self, "_on_answer_pressed")
		if button.pressed.is_connected(answer_pressed_function):
			button.pressed.disconnect(answer_pressed_function)
		
		# Connect the button pressed signal, binding it to the specific answer text.
		button.pressed.connect(answer_pressed_function.bind(answers[i]))
	
	# Show the answer buttons and hide the feedback buttons until an answer is selected.
	answer_container.show()
	feedback_container.hide()

func _on_answer_pressed(selected_answer: String) -> void:
	# Hide the answer buttons and show the feedback buttons.
	answer_container.hide()
	feedback_container.show()
	
	# Get the correct asnwer for the current question.
	var correct_answer: String = current_question["answers"][current_question["correct_answer"]]
	
	# Check if the selected answer is correct.
	var is_correct: bool = selected_answer == correct_answer
	
	# Display feedback based on wheter the answer was correct.
	show_feedback(is_correct, correct_answer)
	
	# Restore energy to the player if the answer was correct.
	if is_correct and player:
		player.restore_energy(energy_restored)


func show_feedback(is_correct: bool, correct_answer: String) -> void:
	# Update the question label with feedback based on if the answer was correct. 
	if is_correct:
		question_label.text = feedback_text["correct"]
	else:
		# Show the correct asnwer if the selected asnwer was wrong.
		question_label.text = feedback_text["incorrect"] % correct_answer

func _on_exit_quiz() -> void:
	# Hide the quiz panel and return to the select quiz menu if available.
	visible = false
	if select_quiz_menu:
		select_quiz_menu.show()
