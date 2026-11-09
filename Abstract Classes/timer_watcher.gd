class_name TimerWatcher
extends Node
##must have a Timer Parent, emits a signal once its timer parent reached a certain point in its duration

signal threshold_reached()

@export_range(0, 1, 0.01, "or_less", "or_greater") var activation_threshold : float 

var parent : Timer
var has_activated : bool = false

func _ready() -> void:
	if get_parent() is Timer:
		parent = get_parent()
		parent.timeout.connect(_parent_finished)
	else:
		printerr("Timer Watcher must have Timer parent")

func _process(_delta: float) -> void:
	if (not has_activated) and not parent.is_stopped() and (1 - (parent.time_left / parent.wait_time)) > activation_threshold:
		threshold_reached.emit()
		has_activated = true

func _parent_finished():
	#make sure we get an activation, just in case
	if not has_activated:
		threshold_reached.emit()
		has_activated = true
