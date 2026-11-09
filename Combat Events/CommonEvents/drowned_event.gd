extends CombatEvent
class_name DrowmedEvemt

const SPLASH_TEXTURE := preload("uid://btd1g1yvkcuq7")
var splash : Sprite2D

func _init(victim : CombatObject) -> void:
	wait_time = 0.5
	one_shot = true
	dependent_combat_objects.append(victim)
	timeout.connect(_on_timeout)

func _started():
	dependent_combat_objects[0].visible = false
	splash = Sprite2D.new()
	splash.texture = SPLASH_TEXTURE
	splash.hframes = 5
	Globals.over_room_renders.combat_event_effects.add_child(splash)

func _process(_delta: float) -> void:
	if not dependent_combat_objects[0].is_queued_for_deletion() and splash:
		splash.position = Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position)
		var prog : float = 1 - (time_left / wait_time)
		splash.frame_coords.x = min(4, floori(5 * prog))


func _on_timeout() -> void:
	splash.queue_free()
	Globals.combat_main.remove_combat_object(dependent_combat_objects[0])
	Globals.a_star_manager.astar_update_tiles()
