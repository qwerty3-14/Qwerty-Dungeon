extends Node2D

var text : String
var texture : Texture2D

func _ready() -> void:
	%Label.text = text

func _process(delta: float) -> void:
	position.y -= delta * 32
	modulate = Color(Color.WHITE, %Duration.time_left / %Duration.wait_time)
	if texture:
		%Texture.texture = texture
		%Texture.visible = true


func _on_duration_timeout() -> void:
	queue_free()
