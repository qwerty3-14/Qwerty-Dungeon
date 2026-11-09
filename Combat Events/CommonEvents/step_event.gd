extends CombatEvent
class_name StepEvent

const HOP_CURVE := preload("uid://dt1lqprqd30ju")
#@export var move_me : CombatObject
@export var move_here : Vector2i
var actor : Actor

var _move_start : Vector2i
var _start_move : bool = false

func _init(move_me : CombatObject, _move_here : Vector2i) -> void:
	wait_time = 0.25
	one_shot = true
	if move_me.has_node("Actor"):
		actor = move_me.get_node("Actor")
	dependent_combat_objects.append(move_me)
	move_here = _move_here

func _started():
	_move_start = dependent_combat_objects[0].tile_position
	dependent_combat_objects[0].move_to(move_here)
	_start_move = true
	if actor:
		if actor.cur_mp > 0:
			actor.spend_mp(1)
		else:
			actor.spend_ap(1)
		if Globals.combat_main.current_actor == actor and actor.alignment == Globals.alignment.PLAYABLE:
			Globals.over_room_renders.highlight_movement_range(actor)
	

func _process(_delta: float) -> void:
	if _start_move:
		var progress : float = 1 - (time_left / wait_time)
		dependent_combat_objects[0].position = lerp(Vector2(_move_start), Vector2(move_here), progress) * 16 + Globals.TILE_SIZE * 0.5
		dependent_combat_objects[0].position.y -= HOP_CURVE.sample(progress) * Globals.TILE_SIDE * 0.3


func _on_timeout() -> void:
	dependent_combat_objects[0].position_on_tile()
