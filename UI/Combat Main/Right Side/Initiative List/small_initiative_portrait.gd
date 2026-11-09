extends Control
class_name SmallInitiativePortrait

var max_health : int = 30
var actor : Actor

func update_visuals(new_actor : Actor):
	actor = new_actor
	%InitiativeLabel.text = str(actor.initiative)
	%Icon.texture = actor.icon
	max_health = actor.health.maximum
	set_hp(actor.health.current)
	actor.health.health_changed.connect(set_hp)
	

func remove():
	_on_mouse_exited()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	%FadeTimer.start()
	reparent(get_parent().get_parent().get_parent())

func _process(_delta: float) -> void:
	if not %FadeTimer.is_stopped():
		modulate = Color(Color.WHITE, %FadeTimer.time_left / %FadeTimer.wait_time)
		position.x -= _delta * 60

func _on_fade_timer_timeout() -> void:
	queue_free()

func set_hp(value : int):
	var bar_fill = floori(37 * float(value) / max_health)
	%HealthBar.value = bar_fill


func _on_mouse_entered() -> void:
	Globals.cursor_manager.set_cursor_position(actor.co_parent.tile_position)
	%WoodBorder.position.x = -2

func _on_mouse_exited() -> void:
	%WoodBorder.position.x = 0
