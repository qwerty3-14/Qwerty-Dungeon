extends Sprite2D
class_name TileCursor

var tile_pos : Vector2i
var aoe : float = 0
var extra_tiles : Array[Vector2i] = []

func set_aoe(radius : float):
	aoe = radius
	queue_redraw()

func set_extra_tiles(_tiles : Array[Vector2i]):
	extra_tiles = _tiles
	queue_redraw()

func set_tile_pos(_tile_pos : Vector2i):
	tile_pos = _tile_pos
	position = Globals.tile_to_pix_pos(_tile_pos)
	queue_redraw()

func _draw() -> void:
	if aoe > 0:
		var tiles : Array[Vector2i] = Globals.tiles_in_range(tile_pos, aoe)
		#print(tiles)
		for tile : Vector2i in tiles:
			draw_texture(texture, (Globals.tile_to_pix_pos(tile) + Vector2(-8, -8)) - position, Color(1, 1, 1, 0.5))
	if extra_tiles.size() > 0:
		for tile : Vector2i in extra_tiles:
			draw_texture(texture, (Globals.tile_to_pix_pos(tile) + Vector2(-8, -8)) - position, Color(1, 1, 1, 0.5))
