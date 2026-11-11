extends Node2D

const TILE_WARN_TEXTURE := preload("uid://72k3333rqgf2")
const CYCLE_TIME : int = 450

var frame : int = 0

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	if Time.get_ticks_msec() % CYCLE_TIME < (CYCLE_TIME / 3):
		if frame != 0:
			queue_redraw()
		frame = 0
		@warning_ignore("integer_division")
	elif Time.get_ticks_msec() % CYCLE_TIME < 2 * (CYCLE_TIME / 3):
		if frame != 1:
			queue_redraw()
		frame = 1
	else:
		if frame != 2:
			queue_redraw()
		frame = 2

func _draw() -> void:
	draw_texture_rect_region(TILE_WARN_TEXTURE, Rect2(-8, -8, 16, 16), Rect2(0, 0, 16, 16), Color.WHITE)
	draw_texture_rect_region(TILE_WARN_TEXTURE, Rect2(-8, -8, 16, 16), Rect2(0, frame * 16, 16, 16), Color(Color.WHITE, 1 - frame * 0.18))
	draw_texture_rect_region(TILE_WARN_TEXTURE, Rect2(-8, -8, 16, 16), Rect2(0, (frame + 3) * 16, 16, 16), Color(Color.WHITE, 1 - (frame + 3) * 0.18))
