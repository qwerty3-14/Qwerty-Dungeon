extends CombatEvent
class_name KillingFlowEvent

const PARTICLES := preload("uid://dpniy631rtfs4")

@export var action : Action

var particles : GPUParticles2D

func _init(_action : Action) -> void:
	wait_time = 0.3
	one_shot = true
	action = _action
	timeout.connect(_on_timeout)

func _started():
	particles = PARTICLES.instantiate()
	Globals.over_room_renders.combat_event_effects.add_child(particles)
	particles.restart()
	particles.position = Globals.tile_to_pix_pos(action.skill.combat_object_grandparent.tile_position)

func _on_timeout() -> void:
	action.reset_cooldown()
	particles.queue_free()
