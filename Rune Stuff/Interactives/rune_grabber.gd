@icon("uid://bgng336aud4vw")
extends Control
class_name RuneGrabber

@export var rune : Rune

func _ready() -> void:
	if not rune:
		var runes : Array[Node] = get_children().filter(func(node : Node) : return node is Rune)
		if runes.size() > 0:
			rune = runes[0]
	if rune:
		rune.position = %GrabPath.position
		attach_rune(rune)

func _process(_delta: float) -> void:
	if not %PullTimer.is_stopped():
		%GrabPathFollow.progress_ratio = 1 - (%PullTimer.time_left / %PullTimer.wait_time)

func attach_rune(_rune : Rune):
	rune = _rune
	rune.dropped.connect(_on_rune_dropped)
	rune.placed.connect(_on_rune_placed)
	rune.has_grabber = true
	pull_in_rune.call_deferred()

func pull_in_rune():
	%GrabPath.global_position = global_position + size * 0.5
	var new_curve : Curve2D = Curve2D.new()
	new_curve.add_point(rune.global_position - %GrabPath.global_position)
	new_curve.add_point(Vector2.ZERO)
	if new_curve.get_baked_length() > 0:
		%GrabPath.curve = new_curve
		%GrabPathFollow.progress_ratio = 0
		rune.reparent(%GrabPathFollow)
		%PullTimer.start()

func _on_rune_dropped():
	pull_in_rune()

func _on_rune_placed():
	rune.has_grabber = false
	rune.dropped.disconnect(_on_rune_dropped)
	rune.placed.disconnect(_on_rune_placed)
	queue_free()

func _on_pull_timer_timeout() -> void:
	rune.reparent(self)
