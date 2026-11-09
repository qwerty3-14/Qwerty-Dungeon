extends CombatEvent

@export var attacker_y : Curve
@export var lerp_weight : Curve

var target : CombatObject
var attacker : CombatObject
var drop_location : Vector2i
var damage : Damage
var finished : bool = false

func _process(_delta: float) -> void:
	if not finished:
		var progress = 1.0 - (time_left / wait_time)
		attacker.position = Globals.tile_to_pix_pos(attacker.tile_position) + Vector2.UP * attacker_y.sample(progress) * 24
		var above_attacker = attacker.position + Vector2.UP * 12
		target.position = lerp(Globals.tile_to_pix_pos(target.tile_position), above_attacker, lerp_weight.sample(progress))


func _on_target_tile_transfer_threshold_reached() -> void:
	target.move_to(drop_location)


func _on_timeout() -> void:
	finished = true
	target.position_on_tile()
	attacker.position_on_tile()
	target.receive_damage(damage)
