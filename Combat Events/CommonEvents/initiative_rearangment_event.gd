extends CombatEvent
class_name IntiativeRearangmentEvent

@export var intiative_portatraits : Array[SmallInitiativePortrait] = []
@export var path_follows : Array[PathFollow2D] = []

func _process(_delta: float) -> void:
	if not is_stopped():
		var prog : float = 1 - time_left / wait_time
		for i in range(path_follows.size()):
			path_follows[i].progress_ratio = prog



func _on_timeout() -> void:
	for i in range(path_follows.size()):
		path_follows[i].get_parent().queue_free()
