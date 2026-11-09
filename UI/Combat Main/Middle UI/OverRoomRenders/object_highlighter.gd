extends Node2D

const MIN_DIST : int = 8 + 4
const MAX_DIST : int = 12 + 4

func _process(_delta: float) -> void:
	var trig_counter = max(sin(4 * PI * Globals.elapsed_time) * 0.55 + 0.45, 0)
	%TopArrow.position.y = lerp(-1 * MIN_DIST, -1 * MAX_DIST, trig_counter)
	%BottomArrow.position.y = lerp(MIN_DIST, MAX_DIST, trig_counter)
	%RightArrow.position.x = lerp(MIN_DIST, MAX_DIST, trig_counter)
	%LeftArrow.position.x = lerp(-1 * MIN_DIST, -1 * MAX_DIST, trig_counter)
	if trig_counter == 0:
		%TopArrow.frame_coords.y = 1
		%BottomArrow.frame_coords.y = 1
		%RightArrow.frame_coords.y = 1
		%LeftArrow.frame_coords.y = 1
	else:
		%TopArrow.frame_coords.y = 0
		%BottomArrow.frame_coords.y = 0
		%RightArrow.frame_coords.y = 0
		%LeftArrow.frame_coords.y = 0
		
