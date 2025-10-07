extends CharacterBody2D

# Signals for HUD updates. 
signal hp_changed(new_hp: int)
signal energy_changed(new_energy: int)

# Player properties.
@export var speed: float = 200.0
@export var animation: AnimationPlayer

# Default values for variables. 
var facing_direction: String = DIRECTION_DOWN
var axis: String = NO_AXIS
var max_hp: int = 12
var current_hp: int = max_hp
var is_alive: bool = true
var max_energy: int = 4
var current_energy: int = max_energy
var is_attacking: bool = false

const HORIZONTAL_AXIS: String = "horizontal"
const VERTICAL_AXIS: String = "vertical"
const NO_AXIS: String = "none"
const DIRECTION_RIGHT: String = "right"
const DIRECTION_LEFT: String = "left"
const DIRECTION_UP: String = "up"
const DIRECTION_DOWN: String = "down"

# Skill objects used by the player.
var fireball_skill: Skill = preload("res://scripts/skills/fireball/fireball_skill.gd").new()
var heal_skill: Skill = preload("res://scripts/skills/heal/heal_skill.gd").new()

# Sync HUD with current HP and energy when the scene starts. 
func _ready() -> void:
	emit_signal("hp_changed", current_hp)
	emit_signal("energy_changed", current_energy)

func _physics_process(_delta: float) -> void:
	# Reset movement vector. 
	var direction:= Vector2.ZERO
	
	# Update direction based on input.  
	if Input.is_action_pressed("move_right"):
		direction.x += 1
		if axis == HORIZONTAL_AXIS:
			facing_direction = DIRECTION_RIGHT
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
		if axis == HORIZONTAL_AXIS:
			facing_direction = DIRECTION_LEFT
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
		if axis == VERTICAL_AXIS:
			facing_direction = DIRECTION_UP
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		if axis == VERTICAL_AXIS:
			facing_direction = DIRECTION_DOWN
	
	# Determine primary axis for animations.
	if direction == Vector2.ZERO:
		axis = NO_AXIS
	elif abs(direction.x) > 0 and abs(direction.y) == 0:
		axis = HORIZONTAL_AXIS
	elif abs(direction.x) == 0 and abs(direction.y) > 0:
		axis = VERTICAL_AXIS
	
	# Normalise direction and set velocity if moving for consistent speed.
	if direction != Vector2.ZERO and is_alive and not is_attacking:
		direction = direction.normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO
	
	# Handle sword attack.
	if Input.is_action_just_pressed("sword_attack") and not is_attacking and is_alive:
		attack()
	
	# Handle fireball skill.
	if Input.is_action_just_pressed("cast_fireball") and not is_attacking and is_alive:
		if not fireball_skill.on_cooldown and use_energy(fireball_skill.energy_cost):
			var mouse_position: Vector2 = get_global_mouse_position()
			fireball_skill.use_skill(self, mouse_position)
			fireball_skill.start_cooldown(self)
	
	# Handle heal skill.
	if Input.is_action_just_pressed("cast_heal") and not is_attacking and is_alive:
		if not heal_skill.on_cooldown and use_energy(heal_skill.energy_cost):
			heal_skill.use_skill(self)
			heal_skill.start_cooldown(self)
	
	# Update animation. 
	update_animation()
	
	# Moves the player. 
	move_and_slide()

# Update animation based on player input and state.  
func update_animation() -> void:
	# Play animations only if player is alive.
	if is_alive:
		# Skip animation if attacking, otherwise update movement/idle.
		if is_attacking:
			return
		elif velocity == Vector2.ZERO:
			animation.play("idle_" + facing_direction)
		else:
			animation.play("move_" + facing_direction)
	else:
		animation.play("death")

# Take damage and update HUD.
func take_damage(amount: int) -> void:
	current_hp = max(current_hp - amount, 0)
	if current_hp <= 0:
		is_alive = false
		die()
	emit_signal("hp_changed", current_hp)

# Heal player and update HUD. 
func heal(amount: int) -> void:
	current_hp = min(current_hp + amount, max_hp)
	emit_signal("hp_changed", current_hp)

# Handle death animation and reload scene. 
func die() -> void:
	await animation.animation_finished
	get_tree().reload_current_scene()

# Use energy if enough is available. 
func use_energy(amount: int) -> bool:
	if current_energy >= amount:
		current_energy -= amount
		emit_signal("energy_changed", current_energy)
		return true
	return false

# Restore energy and update HUD.
func restore_energy(amount: int) -> void:
	current_energy = min(current_energy + amount, max_energy)
	emit_signal("energy_changed", current_energy)

# Sets is_attacking states, plays attack animations, and waits until it finishes. 
func attack() -> void:
	is_attacking = true
	animation.play("attack_" + facing_direction)
	await animation.animation_finished
	is_attacking = false
