@icon("uid://b164r1eomt6oi")
extends Node2D

var start_loc : Vector2i
var path : PackedVector2Array
var can_draw : bool = false
var mp : int = 0
var arrow_texture : Texture2D = preload("uid://ca3tck7qoquki")

func _draw() -> void:
	if can_draw:
		var prev_point = start_loc
		for i in range(0, path.size()):
			var frame_x : int = 0
			var frame_y : int = 1
			var cur_point = Vector2i(path[i])
			if i + 1 < path.size():
				var next_point : Vector2i = Vector2i(path[i + 1])
				frame_x = _middle_seg_frame_x(cur_point - prev_point, next_point - cur_point)
			else:
				match cur_point - prev_point:
					Vector2i(1, 0):
						frame_x = 6
					Vector2i(-1, 0):
						frame_x = 8
					Vector2i(0, 1):
						frame_x = 7
					Vector2i(0, -1):
						frame_x = 9
			if i < mp:
				frame_y = 0
				
			draw_texture_rect_region(arrow_texture, Rect2(Globals.tile_to_pix_pos(cur_point) - Vector2(8, 8), Vector2(16, 16)), Rect2(frame_x * 17, frame_y * 17, 16, 16))
			prev_point = cur_point

func _middle_seg_frame_x(to_cur_point : Vector2i, to_next_point : Vector2i) -> int:
	match to_cur_point:
		Vector2i(1, 0):
			match to_next_point:
				Vector2i(0, 1):
					return 2
				Vector2i(0, -1):
					return 3
				_:
					return 0
		Vector2i(-1, 0):
			match to_next_point:
				Vector2i(0, 1):
					return 5
				Vector2i(0, -1):
					return 4
				_:
					return 0
		Vector2i(0, 1):
			match to_next_point:
				Vector2i(1, 0):
					return 4
				Vector2i(-1, 0):
					return 3
				_:
					return 1
		Vector2i(0, -1):
			match to_next_point:
				Vector2i(1, 0):
					return 5
				Vector2i(-1, 0):
					return 2
				_:
					return 1
	return 0
