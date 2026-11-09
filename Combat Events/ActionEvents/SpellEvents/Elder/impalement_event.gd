extends CombatEvent
class_name ImpalementEvent

const BLADES := preload("uid://30xrl2ahstcx")
const SALVO_SPACING : float = 0.5

var damage : Damage
var blade_count : int = 5

func _init(attacker : CombatObject, target : CombatObject, _damage : Damage, _blade_count : int) -> void:
	wait_time = 2
	one_shot = true
	dependent_combat_objects.append(attacker)
	dependent_combat_objects.append(target)
	damage = _damage
	blade_count = _blade_count

func _started():
	@warning_ignore("integer_division")
	var full_salvos : int = blade_count / 5
	for i : int in range(full_salvos):
		if i == 0:
			make_blades(5)
		else:
			var new_timer : Timer = Timer.new()
			new_timer.one_shot = true
			new_timer.autostart = true
			new_timer.wait_time = SALVO_SPACING * i
			new_timer.timeout.connect(make_blades.bind(5))
			add_child(new_timer)
			wait_time += SALVO_SPACING
	if blade_count % 5 > 0:
		var new_timer : Timer = Timer.new()
		new_timer.one_shot = true
		new_timer.autostart = true
		new_timer.wait_time = SALVO_SPACING * full_salvos
		new_timer.timeout.connect(make_blades.bind(blade_count % 5))
		add_child(new_timer)
		wait_time += SALVO_SPACING
	start()

func make_blades(_blade_count : int):
	var blades : ImpalementBlades = BLADES.instantiate()
	blades.damage = damage
	blades.target = dependent_combat_objects[1]
	blades.blade_count = _blade_count
	Globals.over_room_renders.combat_event_effects.add_child(blades)
	blades.position = Globals.tile_to_pix_pos(dependent_combat_objects[0].tile_position)
	
