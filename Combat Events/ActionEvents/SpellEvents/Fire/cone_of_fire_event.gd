extends CombatEvent
class_name ConeOfFireEvent

var PARTICLES := preload("uid://deyyx2vf8yrbc")

var damage : Damage
var center : Vector2i
var tiles : Array[Vector2i]

var particles : GPUParticles2D
var dir : float

func _init(_damage : Damage, _direction : float, _center : Vector2i, _tiles : Array[Vector2i]) -> void:
	wait_time = 1.5
	one_shot = true
	damage = _damage
	dir = _direction
	center = _center
	tiles = _tiles
	var watcher : TimerWatcher = TimerWatcher.new()
	watcher.activation_threshold = 0.5
	watcher.threshold_reached.connect(_on_mid_watcher_threshold_reached)
	add_child(watcher)
	timeout.connect(_on_timeout)

func _started():
	particles = PARTICLES.instantiate()
	Globals.over_room_renders.add_child(particles)
	particles.position = Globals.tile_to_pix_pos(center)
	particles.rotation = dir
	particles.emitting = true

func _on_mid_watcher_threshold_reached() -> void:
	particles.emitting = false
	for tile : Vector2i in tiles:
		if Globals.combat_main.tile_occupied(tile):
			var co : CombatObject = Globals.combat_main.combat_object_at_tile(tile)
			co.receive_damage(damage.clone())

func _on_timeout():
	particles.queue_free()
