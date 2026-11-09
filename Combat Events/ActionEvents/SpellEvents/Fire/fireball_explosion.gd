extends CombatEvent
class_name FireballExplosion

const PARTICLES := preload("uid://dqxdsxywdag37")

var tile_pos : Vector2i
var damage : Damage

var particles : GPUParticles2D

func _init(_tile_pos : Vector2i, _damage : Damage) -> void:
	wait_time = 1
	one_shot = true
	tile_pos = _tile_pos
	damage = _damage
	timeout.connect(_on_timeout)

func _started():
	particles = PARTICLES.instantiate()
	particles.emitting = true
	Globals.over_room_renders.combat_event_effects.add_child(particles)
	particles.position = Globals.tile_to_pix_pos(tile_pos)
	var tiles : Array[Vector2i] = Globals.tiles_in_range(tile_pos, 1.5, true)
	#Globals.over_room_renders.highlight_tiles(tiles, "Debug")
	for tile : Vector2i in tiles:
		if Globals.combat_main.tile_occupied(tile):
			#print(tile)
			var combat_object : CombatObject = Globals.combat_main.combat_object_at_tile(tile)
			combat_object.receive_damage(damage.clone())

func _on_timeout():
	particles.queue_free()
