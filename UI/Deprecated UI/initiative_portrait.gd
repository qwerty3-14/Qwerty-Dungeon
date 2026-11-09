class_name InitiativePortrait
extends Control

func update_visuals(actor : Actor):
	$InitiativeLabel.text = str(actor.initiative)
	$Portrait.texture = actor.portrait

func remove():
	%FadeTimer.start()
	reparent(get_parent().get_parent())
	

func _process(_delta: float) -> void:
	if not %FadeTimer.is_stopped():
		modulate = Color(Color.WHITE, %FadeTimer.time_left / %FadeTimer.wait_time)
		position.x -= _delta * 60


func _on_fade_timer_timeout() -> void:
	queue_free()
