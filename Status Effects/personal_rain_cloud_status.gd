@icon("uid://cg4b2gfuv607i")
extends StatusEffect

var bonus : AttrBonus = AttrBonus.new(-6, "Personal Rain Cloud")
@onready var cloud_particles : GPUParticles2D = $CloudParticles

func _on_ready() -> void:
	if actor:
		actor.luck.add_bonus(bonus)
	description = "It's raining on you specifically.\n-6 Lck\nRecieve 4 extra lighting damage"
	cloud_particles.emitting = true
	cloud_particles.reparent(parent)
	cloud_particles.position = Vector2.UP * 8
	Globals.cursor_manager.cursor_tile_position_changed.connect(_on_cursor_tile_position_changed)
	parent.modifying_damage_recieved.connect(_on_parent_modifying_damage_recieved)

func _on_cursor_tile_position_changed(_position : Vector2i, _in_bounds : bool):
	cloud_particles.visible = not (_in_bounds and (abs(_position.x - parent.tile_position.x)  <= 1 and abs(_position.y - parent.tile_position.y) <= 1))

func _on_parent_modifying_damage_recieved(damage : Damage):
	if damage.type == Damage.Type.ELECTRIC:
		parent.modifying_damage_receieved_flat_SR += 4

func _on_tree_exiting() -> void:
	cloud_particles.queue_free()
