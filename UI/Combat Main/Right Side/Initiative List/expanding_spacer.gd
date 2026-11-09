extends ColorRect

func _process(_delta: float) -> void:
	if not is_queued_for_deletion():
		custom_minimum_size.y = 27 * (1 - (%ExpandTimer.time_left / %ExpandTimer.wait_time))
		size.y = 27 * (1 - (%ExpandTimer.time_left / %ExpandTimer.wait_time))


func _on_expand_timer_timeout() -> void:
	custom_minimum_size.y = 27
	size.y = 27
