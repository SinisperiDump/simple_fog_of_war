extends Node2D

@onready var fog_sprite: Sprite2D = %FogSprite
@onready var ground_tiles: TileMapLayer = %GroundTiles
@onready var player: CharacterBody2D = %Player

var fog_image: Image
var vision_image: Image

@export var fog_pixelation: int = 16
var world_position: Vector2
func _ready() -> void:
	generate_fog()
	update_fog()

func _process(delta: float) -> void:
	if player.velocity.length():
		update_fog()
		
func generate_fog() -> void:
	var world_dimentions = ground_tiles.get_used_rect().size * ground_tiles.tile_set.tile_size
	world_position = ground_tiles.get_used_rect().position * ground_tiles.tile_set.tile_size
	var scaled_dimentions = world_dimentions / fog_pixelation
	fog_image = Image.create(scaled_dimentions.x, scaled_dimentions.y, false, Image.Format.FORMAT_RGBAH)
	
	fog_image.fill(Color.BLACK)
	var fog_texture = ImageTexture.create_from_image(fog_image)
	fog_sprite.texture = fog_texture
	fog_sprite.scale *= fog_pixelation
	
	vision_image = player.vision_sprite.texture.get_image()
	vision_image.convert(Image.Format.FORMAT_RGBAH)
	
	var vision_scale = Vector2(vision_image.get_size()) / fog_pixelation
	vision_image.resize(vision_scale.x, vision_scale.y)

func update_fog() -> void:
	var vision_rect = Rect2(Vector2.ZERO, vision_image.get_size())
	fog_image.blend_rect(
		vision_image, 
		vision_rect, 
		(player.global_position / fog_pixelation) - (world_position / fog_pixelation) - Vector2(vision_image.get_size() / 2))
	var fog_texture = ImageTexture.create_from_image(fog_image)
	fog_sprite.texture = fog_texture
