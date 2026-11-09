extends ColorRect

const OFF_PIN_X : float = -26.5
const ON_PIN_X : float = 16.5
const OFF_PIN_HEIGHT : float = 0
const ON_PIN_HEIGHT : float = 5

var activated : bool = false

func _ready() -> void:
	visible = false
	%PinSprite.modulate = Color(Color.WHITE, 0)
	custom_minimum_size.y = OFF_PIN_HEIGHT
	size.y = OFF_PIN_HEIGHT

func _process(_delta: float) -> void:
	if not %FadeTimer.is_stopped():
		var time_prog : float = 1 - (%FadeTimer.time_left / %FadeTimer.wait_time)
		if activated:
			%PinSprite.position.x = lerp(OFF_PIN_X, ON_PIN_X, time_prog)
			custom_minimum_size.y = lerp(OFF_PIN_HEIGHT, ON_PIN_HEIGHT, time_prog)
			size.y = lerp(OFF_PIN_HEIGHT, ON_PIN_HEIGHT, time_prog)
			%PinSprite.modulate = Color(Color.WHITE, time_prog)
		else:
			%PinSprite.position.x = lerp(ON_PIN_X, OFF_PIN_X, time_prog)
			custom_minimum_size.y = lerp(ON_PIN_HEIGHT, OFF_PIN_HEIGHT, time_prog)
			size.y = lerp(ON_PIN_HEIGHT, OFF_PIN_HEIGHT, time_prog)
			%PinSprite.modulate = Color(Color.WHITE, 1 - time_prog)

func _on_fade_timer_timeout() -> void:
	if activated:
		%PinSprite.position.x = ON_PIN_X
		custom_minimum_size.y = ON_PIN_HEIGHT
		size.y = ON_PIN_HEIGHT
		%PinSprite.modulate = Color(Color.WHITE, 1)
	else:
		visible = false
		%PinSprite.position.x = OFF_PIN_X
		custom_minimum_size.y = OFF_PIN_HEIGHT
		size.y = OFF_PIN_HEIGHT
		%PinSprite.modulate = Color(Color.WHITE, 0)

func activate():
	visible = true
	activated = true
	%FadeTimer.start()

func deactivate():
	activated = false
	%FadeTimer.start()
	
