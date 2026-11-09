extends Node2D
class_name MiniRuneDrawer

const MINI_RUNE_TEXTURE := preload("uid://beeyqwpgsrbe5")



func _draw() -> void:
	if get_parent().shape and get_parent().frame:
		for tile in get_parent().shape:
			draw_texture_rect_region(MINI_RUNE_TEXTURE, Rect2(-1 + tile.x * 2, -1 + tile.y * 2, 2, 2), Rect2(0, get_parent().frame * 2, 2, 2))
