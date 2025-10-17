extends Area2D

# Fireball projectile AnimatedSprite2D, set in inspector. 
@export var animation: AnimatedSprite2D

# Variables set dynamically by the fireball_skill script.
var speed: float
var damage: int
var duration: float
var direction := Vector2.ZERO


# Plays animation and destroys fireball after a duration.
func _ready() -> void:
	animation.play("fireball_spin")
	
	await get_tree().create_timer(duration).timeout
	queue_free()


# Moves in set direction at the specified speed every frame.
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


# Damages enemy on collision, then destroys self.
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		var enemy: Node2D = area.get_parent()
		enemy.take_damage(damage)
		queue_free()


# Destroys self on hitting walls.
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("world"):
		queue_free()
