extends HBoxContainer

# Player health variables for 3 hearts each worth 4 HP. 
@export var max_hp: int = 12
@export var current_hp: int = max_hp
@export var hp_per_heart: int = 4


# Initialise heart UI to match current HP on scene load. 
func _ready() -> void:
	update_hearts()


# Update heart sprites based on current HP and HP per heart. 
func update_hearts() -> void:
	# Loop through each heart and set frame according to player HP. 
	for i in range(get_child_count()):
		var heart: TextureRect = get_child(i)
		var heart_hp: int = clamp(current_hp - (i * hp_per_heart), 0, hp_per_heart)
		heart.set_heart_frame(heart_hp)


# When HP changes, clamp the new value to a valid range, then update hearts.
func set_hp(value: int) -> void:
	current_hp = clamp(value, 0, max_hp)
	update_hearts()
