extends ColorRect

func _process(_delta: float) -> void:
	if not is_queued_for_deletion():
		custom_minimum_size.y = 27 * (%ShrinkTimer.time_left / %ShrinkTimer.wait_time)
		size.y = 27 * (%ShrinkTimer.time_left / %ShrinkTimer.wait_time)

func _on_shrink_timer_timeout() -> void:
	queue_free()
