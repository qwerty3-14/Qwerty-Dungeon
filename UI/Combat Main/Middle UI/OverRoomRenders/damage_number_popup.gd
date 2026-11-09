extends Node2D

@export var damage : Damage
@export var alpha_curve : Curve
var velocity : Vector2

func _ready() -> void:
	if damage.amount == 0:
		%Label.text = "No Damage!"
	else:
		%Label.text = str(damage.amount)
	var color : Color = damage.damage_type_color()
	%Label.add_theme_color_override("font_color", color)
	velocity.y = Globals.effect_rng.randf_range(-96, -48)
	velocity.x = Globals.effect_rng.randf_range(-24, 24)

func _process(delta: float) -> void:
	position += velocity * delta
	velocity.y += 128 * delta
	modulate = Color(Color.WHITE, alpha_curve.sample(1 - (%Duration.time_left / %Duration.wait_time)))

func _on_duration_timeout() -> void:
	queue_free()
