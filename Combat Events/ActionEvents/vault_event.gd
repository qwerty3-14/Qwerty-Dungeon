extends CombatEvent

@export var jump_curve : Curve
@export var jumper : CombatObject
@export var landing_loc : Vector2i
var start_loc : Vector2i
var clockwise_spin : bool = false


func _on_start_watcher_threshold_reached() -> void:
	start_loc = jumper.tile_position
	if landing_loc.x >= start_loc.x:
		clockwise_spin = true

func _process(_delta: float) -> void:
	if (not is_stopped()) and start_loc:
		var prog : float = 1 - (time_left / wait_time)
		jumper.position = lerp(Globals.tile_to_pix_pos(start_loc), Globals.tile_to_pix_pos(landing_loc), prog)
		jumper.position.y += -1 * jump_curve.sample(prog) * 24 * wait_time
		if jump_curve.sample(prog) > 0:
			if clockwise_spin:
				jumper.rotation += _delta * (PI * 2 / (wait_time * 0.8))
			else:
				jumper.rotation += -1 * _delta * (PI * 2 / (wait_time * 0.8))
		


func _on_timeout() -> void:
	jumper.rotation = 0
	jumper.move_to(landing_loc)
	jumper.position_on_tile()
