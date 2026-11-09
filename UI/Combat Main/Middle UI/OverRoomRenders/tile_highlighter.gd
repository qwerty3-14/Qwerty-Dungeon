extends Node2D

var highlight_texture : Texture2D = preload("uid://drx65thlrtpxi")

@export var top_occupied : bool = false
@export var right_occupied : bool = false
@export var bottom_occupied : bool = false
@export var left_occupied : bool = false
@export var variant : OverRoomRenders.tile_higlihter_variant

func _ready() -> void:
	queue_redraw()

func _draw() -> void:
	var variant_y : int = variant * 16
	if not top_occupied:
		draw_texture_rect_region(highlight_texture, Rect2(Vector2(-8, -8), Vector2(16, 2)), Rect2(2, variant_y, 16, 2))
	if not right_occupied:
		draw_texture_rect_region(highlight_texture, Rect2(Vector2(6, -8), Vector2(2, 16)), Rect2(18, variant_y, 2, 16))
	if not bottom_occupied:
		draw_texture_rect_region(highlight_texture, Rect2(Vector2(-8, 6), Vector2(16, 2)), Rect2(2, variant_y + 14, 16, 2))
	if not left_occupied:
		draw_texture_rect_region(highlight_texture, Rect2(Vector2(-8, -8), Vector2(2, 16)), Rect2(0, variant_y, 2, 16))
