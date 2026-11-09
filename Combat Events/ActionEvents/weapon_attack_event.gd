extends CombatEvent
class_name WeaponAttackEvent

signal about_to_hit_target(target : CombatObject)
signal target_been_hit(target : CombatObject)
signal target_been_missed(target : CombatObject)

@export var damage : Damage
@export var miss : bool = false
var finished : bool = false
var target_tile_pos : Vector2i

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage) -> void:
	wait_time = 0.5
	one_shot = true
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	target_tile_pos = target.tile_position
	damage = _damage
	if target.has_node("Actor"):
			miss = not attacker.get_node("Actor").try_to_hit(target.get_node("Actor"))
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.activation_threshold = 0.5
	watcher.threshold_reached.connect(_on_timer_watcher_threshold_reached)
	add_child(watcher)
	

func _ready() -> void:
	dependent_combat_objects[0].emit_queued_weapon_attack(self)

func _process(_delta: float) -> void:
	if not finished:
		_position_attacker()
		if miss and not dependent_combat_objects[1].is_queued_for_deletion():
			dependent_combat_objects[1].position = Globals.tile_to_pix_pos(dependent_combat_objects[1].tile_position) + lerp(Vector2.ZERO, Vector2.ZERO + Vector2.RIGHT * 8, sin(PI * time_left / wait_time))

func _position_attacker():
	dependent_combat_objects[0].position = Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position) + lerp(Vector2.ZERO,  (Globals.tile_to_pix_pos(target_tile_pos) - Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position)).normalized() * 16, sin(PI * time_left / wait_time))

func _on_timeout() -> void:
	dependent_combat_objects[0].position_on_tile()
	dependent_combat_objects[1].position_on_tile()
	finished = true


func _on_timer_watcher_threshold_reached() -> void:
	if miss:
		Globals.over_room_renders.miss_popup(dependent_combat_objects[1].tile_position)
		target_been_missed.emit(dependent_combat_objects[1])
	else:
		about_to_hit_target.emit(dependent_combat_objects[1])
		dependent_combat_objects[1].receive_damage(damage)
		target_been_hit.emit(dependent_combat_objects[1])
