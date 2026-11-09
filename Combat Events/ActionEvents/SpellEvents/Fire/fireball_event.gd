extends CombatEvent
class_name FireballEvent

const FIRE_EFFECT := preload("uid://dy41kvgbto3ve")

var landing_position : Vector2i
var damage : Damage
var fire_core : Sprite2D

func _init(attacker : CombatObject, _landing_position : Vector2i, _damage : Damage) -> void:
	wait_time = 0.1 + (_landing_position - attacker.tile_position).length() * 0.125
	one_shot = true
	dependent_combat_objects.append(attacker)
	landing_position = _landing_position
	damage = _damage
	timeout.connect(_on_timeout)

func _started():
	fire_core = FIRE_EFFECT.instantiate()
	Globals.over_room_renders.combat_event_effects.add_child(fire_core)

func _process(_delta: float) -> void:
	if fire_core:
		fire_core.position = lerp(Globals.tile_to_pix_pos(landing_position), dependent_combat_objects[0].global_position, time_left / wait_time)


func _on_timeout() -> void:
	fire_core.queue_free()
	var explosion := FireballExplosion.new(landing_position, damage)
	CombatEventManager.add_and_start_combat_event(explosion)
	
