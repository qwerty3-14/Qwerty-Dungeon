extends Node2D

const ARROW_H : int = 10
const ARROW_W : int = 8

@export var start : Vector2i
@export var end : Vector2i

var texture : Texture2D = preload("uid://bcfvjkwyqcwtp")
var end_pix : Vector2
func _ready() -> void:
	update_draw()

func update_draw():
	position = Globals.tile_to_pix_pos(start)
	end_pix = Globals.tile_to_pix_pos(end)
	rotation = (end_pix - position).angle()
	queue_redraw()

func _draw() -> void:
	#draw_texture(texture, (Globals.tile_to_pix_pos(start) + Vector2(-8, -8)) - position)
	var dist : float = (end_pix - position).length()
	draw_texture_rect_region(texture, Rect2(Vector2(-1, ARROW_H * -0.5), Vector2(2, ARROW_H)), Rect2(Vector2.ZERO, Vector2(2, ARROW_H)))
	for i : int in range(1, dist - 1):
		draw_texture_rect_region(texture, Rect2(Vector2(i, ARROW_H * -0.5), Vector2(1, ARROW_H)), Rect2(Vector2(2, 0), Vector2(1, ARROW_H)))
	draw_texture_rect_region(texture, Rect2(Vector2(dist - 2, ARROW_H * -0.5), Vector2(ARROW_W - 3, ARROW_H)), Rect2(Vector2(3, 0), Vector2(ARROW_W - 3, ARROW_H)))
	
