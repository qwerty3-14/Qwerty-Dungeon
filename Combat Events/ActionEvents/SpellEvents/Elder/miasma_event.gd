extends CombatEvent
class_name MiasmaEvent

const MIASMA_STATUS := preload("uid://dseqotw2umqgi")
const MIASMA_EFFECT := preload("uid://84jqqvk8o76n")

var damage : Damage
var tile_pos : Vector2i
var radius : float
var tiles : Array[Vector2i]
var miasma_particles : Node2D

func _init(_tile_pos : Vector2i, _radius : float, _damage : Damage) -> void:
	wait_time = 2
	one_shot = true
	tile_pos = _tile_pos
	radius = _radius
	damage = _damage
	tiles = Globals.tiles_in_range(tile_pos, radius, false)
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.activation_threshold = 0.75
	watcher.threshold_reached.connect(_on_timer_watcher_threshold_reached)
	add_child(watcher)
	timeout.connect(_on_timeout)

func _started():
	miasma_particles = MIASMA_EFFECT.instantiate()
	miasma_particles.position = Globals.tile_to_pix_pos(tile_pos)
	miasma_particles.setup_tiles(tile_pos, tiles)
	Globals.over_room_renders.combat_event_effects.add_child(miasma_particles)

func _on_timer_watcher_threshold_reached() -> void:
	for tile in tiles:
		if Globals.combat_main.tile_occupied(tile):
			var co : CombatObject = Globals.combat_main.combat_object_at_tile(tile)
			var new_status = MIASMA_STATUS.instantiate()
			new_status.damage = damage.clone()
			co.apply_status_effect(new_status)

func _on_timeout():
	if miasma_particles:
		miasma_particles.queue_free()
