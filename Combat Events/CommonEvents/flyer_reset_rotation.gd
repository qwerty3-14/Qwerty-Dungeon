extends CombatEvent
class_name FlyerResetRotation

func _init(move_me : CombatObject) -> void:
	wait_time = 0.25
	one_shot = true
	dependent_combat_objects.append(move_me)
	timeout.connect(_on_timeout)

func _process(_delta: float) -> void:
	if not is_stopped():
		dependent_combat_objects[0].rotation = rotate_toward(dependent_combat_objects[0].rotation, 0, PI * 0.3 * _delta)

func _on_timeout():
	dependent_combat_objects[0].rotation = 0
