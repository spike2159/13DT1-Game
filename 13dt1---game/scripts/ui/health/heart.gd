extends TextureRect

# Sets the sprite sheet for hearts and frame size to 16x16 pixels.
@export var heart_sprites : Texture2D
@export var frame_size : Vector2i

# Creates a texture region to cut a frame from the sprite sheet. 
var atlas_texture := AtlasTexture.new()

func _ready() -> void:
	# Sets sprite sheet as the source, then asigns cropped texture to TextureRect.
	atlas_texture.atlas = heart_sprites
	texture = atlas_texture
	
	# Sets the heart sprite to the full frame using the set_heart_frame function. 
	set_heart_frame(4)

# Updates heart frame by cropping the spritesheet and updating the TextureRect texture.
func set_heart_frame(frame : int):
	atlas_texture.region = Rect2(frame * frame_size.x, 0, 
		frame_size.x, frame_size.y)
	texture = atlas_texture
