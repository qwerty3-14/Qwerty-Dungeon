extends ColorRect

@export_multiline() var story : Array[String]

var char_p_s : float = 30
var total_chars : float = 0

func _ready() -> void:
	load_next_text()

func _process(_delta: float) -> void:
	total_chars += _delta * char_p_s
	%Dialog.visible_characters = total_chars
	if %AutoTimer.is_stopped() and %Dialog.visible_ratio >= 1:
		%AutoTimer.start()
	#var prog = 1 - (%TextTimer.time_left / %TextTimer.wait_time)
	#%Dialog.visible_ratio = prog

func _input(event: InputEvent) -> void:
	if (event is InputEventKey or event is InputEventMouseButton) and event.is_released():
		load_next_text()

func load_next_text():
	if story.size() > 0:
		%Dialog.text = story.pop_front()
		total_chars = 0
		%Dialog.visible_characters = 0
	else:
		MetaCombat.load_first_stage()
		queue_free()

func _on_auto_timer_timeout() -> void:
	load_next_text()
