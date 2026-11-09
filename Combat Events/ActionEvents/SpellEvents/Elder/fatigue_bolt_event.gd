extends CombatEvent
class_name FatigueBoltEvent

const FATIGUE_BOLT_TEXTURE := preload("uid://5wxtfaobv76l")

@export var damage : Damage

var bolt_sprite : Sprite2D

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage) -> void:
	wait_time = (target.tile_position - attacker.tile_position).length() * 0.125
	one_shot = true
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	damage = _damage
	timeout.connect(_on_timeout)

func _started():
	bolt_sprite = Sprite2D.new()
	bolt_sprite.texture = FATIGUE_BOLT_TEXTURE
	bolt_sprite.centered = true
	bolt_sprite.hframes = 3
	Globals.over_room_renders.combat_event_effects.add_child(bolt_sprite)

func _process(_delta: float) -> void:
	if bolt_sprite:
		bolt_sprite.position = lerp(dependent_combat_objects[1].global_position, dependent_combat_objects[0].global_position, time_left / wait_time)
		bolt_sprite.rotation = (dependent_combat_objects[1].global_position - dependent_combat_objects[0].global_position).angle()
		bolt_sprite.frame = int(Globals.elapsed_time * 128) % 3


func _on_timeout() -> void:
	dependent_combat_objects[1].receive_damage(damage)
	if dependent_combat_objects[1].has_node("Actor"):
		dependent_combat_objects[1].get_node("Actor").spend_ap(1)
	bolt_sprite.queue_free()
