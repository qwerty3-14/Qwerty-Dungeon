extends CombatEvent
class_name LightningEvent

const LIGHTING_EFFECT := preload("uid://csrl6q4rkjtmn")

var damage : Damage
var lightning_effect : Node2D

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage ) -> void:
	wait_time = (target.tile_position - attacker.tile_position).length() * 0.125
	one_shot = true
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	damage = _damage
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.activation_threshold = 0.25
	watcher.threshold_reached.connect(_on_timer_watcher_threshold_reached)
	add_child(watcher)

func _started():
	lightning_effect = LIGHTING_EFFECT.instantiate()
	Globals.over_room_renders.combat_event_effects.add_child(lightning_effect)
	lightning_effect.position = dependent_combat_objects[0].global_position
	lightning_effect.end_pos = dependent_combat_objects[1].global_position - dependent_combat_objects[0].global_position
	lightning_effect.activate()

func _on_timer_watcher_threshold_reached() -> void:
	dependent_combat_objects[1].receive_damage(damage)
