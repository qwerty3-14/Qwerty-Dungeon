extends CombatEvent
class_name WeaponAttackEvent

signal about_to_hit_target(target : CombatObject)
signal target_been_first_hit(target : CombatObject)
signal target_been_hit(target : CombatObject)
signal target_been_missed(target : CombatObject)

@export var damage : Damage
@export var miss : bool = false
var finished : bool = false
var target_tile_pos : Vector2i
var repeats : int = 0

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage, _repeats : int = 0) -> void:
	wait_time = 0.5 + _repeats * 0.25
	one_shot = true
	repeats = _repeats
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	target_tile_pos = target.tile_position
	damage = _damage
	if target.has_node("Actor"):
			miss = not attacker.get_node("Actor").try_to_hit(target.get_node("Actor"))
	for i : int in range(1 + repeats):
		var watcher : TimerWatcher = TimerWatcher.new()
		watcher.activation_threshold = (i+1) * (1 / float(2 + repeats))
		watcher.threshold_reached.connect(_on_timer_watcher_threshold_reached)
		if i == 0:
			watcher.threshold_reached.connect(_on_first_hit)
		add_child(watcher)
	

func _ready() -> void:
	dependent_combat_objects[0].emit_queued_weapon_attack(self)

func _process(_delta: float) -> void:
	if not finished:
		_position_attacker()
		if miss and not dependent_combat_objects[1].is_queued_for_deletion():
			dependent_combat_objects[1].position = Globals.tile_to_pix_pos(dependent_combat_objects[1].tile_position) + lerp(Vector2.ZERO, Vector2.ZERO + Vector2.RIGHT * 8, sin(PI * time_left / wait_time))

func _position_attacker():
	var first_hit_time : float = 0.25
	var retreat_time : float = 0.25
	var extra_hit_time : float = 0.25
	var prog : float = 0
	var elapsed : float = (wait_time - time_left)
	if elapsed < first_hit_time:
		prog = 0.5 * (elapsed / first_hit_time)
	elif elapsed >= wait_time - retreat_time:
		prog = 0.5 + 0.5 * ((elapsed - (wait_time - retreat_time)) / retreat_time)
	else:
		prog = 0.5 + -0.3 * abs(sin(PI * ((elapsed - first_hit_time) / extra_hit_time)))
	dependent_combat_objects[0].position = Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position) + lerp(Vector2.ZERO,  (Globals.tile_to_pix_pos(target_tile_pos) - Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position)).normalized() * 16, sin(PI * prog))

func _on_timeout() -> void:
	dependent_combat_objects[0].position_on_tile()
	dependent_combat_objects[1].position_on_tile()
	finished = true

func _on_first_hit():
	if not miss:
		target_been_first_hit.emit(dependent_combat_objects[1])

func _on_timer_watcher_threshold_reached() -> void:
	if miss:
		Globals.over_room_renders.miss_popup(dependent_combat_objects[1].tile_position)
		target_been_missed.emit(dependent_combat_objects[1])
	else:
		about_to_hit_target.emit(dependent_combat_objects[1])
		dependent_combat_objects[1].receive_damage(damage)
		target_been_hit.emit(dependent_combat_objects[1])
