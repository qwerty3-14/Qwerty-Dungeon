extends CombatEvent
class_name ShadowStrikeEvent

const SHADOWSTRIKE_TEXTURE := preload("uid://b2pcu54j7hak7")

@export var damage : Damage

var strike_sprite : Sprite2D

func _init(target : CombatObject, _damage : Damage) -> void:
	wait_time = 0.3
	one_shot = true
	dependent_combat_objects.append(target)
	damage = _damage
	timeout.connect(_on_timeout)

func _started():
	strike_sprite = Sprite2D.new()
	strike_sprite.texture = SHADOWSTRIKE_TEXTURE
	strike_sprite.centered = true
	strike_sprite.hframes = 5
	Globals.over_room_renders.combat_event_effects.add_child(strike_sprite)
	
func _process(_delta: float) -> void:
	if strike_sprite:
		strike_sprite.position = dependent_combat_objects[0].global_position
		strike_sprite.frame = min(4, (1 - (time_left / wait_time)) * 6)

func _on_timeout() -> void:
	dependent_combat_objects[0].receive_damage(damage)
	strike_sprite.queue_free()
