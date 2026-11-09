extends CombatEvent

const TIME_TO_LIFT : float = 0.5
const TPS : float = 6


@export var target : CombatObject
@export var grabber : CombatObject
@export var drop_location : Vector2i
@export var low_throw_curve : Curve
@export var high_throw_curve : Curve


func _process(_delta: float) -> void:
	var above_grabber = grabber.position + Vector2.UP * 12
	if wait_time - time_left > TIME_TO_LIFT:
		var progress : float = 1 - ((time_left) / (wait_time - TIME_TO_LIFT))
		target.position = lerp(Globals.tile_to_pix_pos(grabber.tile_position), Globals.tile_to_pix_pos(drop_location), progress)
		if wait_time > 0.8:
			target.position.y += -1 * high_throw_curve.sample(progress)
			target.rotation = PI * 2 * progress
		else:
			target.position.y += -1 * low_throw_curve.sample(progress)
	else:
		var progress : float = (wait_time - time_left) / TIME_TO_LIFT
		target.position = lerp(Globals.tile_to_pix_pos(target.tile_position), above_grabber, progress)

func setup(_target : CombatObject, _grabber : CombatObject, _drop : Vector2i):
	target = _target
	grabber = _grabber
	drop_location = _drop
	wait_time = TIME_TO_LIFT + (drop_location - grabber.tile_position).length() / TPS


func _on_timeout() -> void:
	target.move_to(drop_location)
	target.position_on_tile()
	target.rotation = 0
