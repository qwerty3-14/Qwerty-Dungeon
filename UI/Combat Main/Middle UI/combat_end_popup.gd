extends Path2D

signal on_continue()

func _process(_delta: float) -> void:
	if not %MoveTimer.is_stopped():
		%PathFollow2D.progress_ratio = 1 - (%MoveTimer.time_left / %MoveTimer.wait_time)
		%PathFollow2D.modulate = Color(1, 1, 1, %PathFollow2D.progress_ratio)

func start_popup():
	%MoveTimer.start()

func game_over_popup():
	%"GAME OVER".visible = true
	%"VICTORY".visible = false
	%ContinueButton.visible = false
	%PathFollow2D.visible = true
	%MoveTimer.start()

func victory_popup():
	%"GAME OVER".visible = false
	%"VICTORY".visible = true
	%ContinueButton.visible = true
	%PathFollow2D.visible = true
	%MoveTimer.start()

func reset():
	%"GAME OVER".visible = false
	%"VICTORY".visible = false
	%ContinueButton.visible = false
	%PathFollow2D.progress_ratio = 0
	%PathFollow2D.visible = false
	%PathFollow2D.modulate = Color(1, 1, 1, 0)


func _on_continue_button_pressed() -> void:
	on_continue.emit()
