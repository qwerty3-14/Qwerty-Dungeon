@icon("uid://chnxnhonan12n")
extends NinePatchRect

@export var notch : Texture2D

@export var max_value : int
@export var value : int
@export var use_preview : int


func _ready() -> void:
	notch.changed.connect(set_child_values)
	set_child_values()
	
	%OpaqueNotches.patch_margin_bottom = patch_margin_bottom
	%OpaqueNotches.patch_margin_left = patch_margin_left
	%OpaqueNotches.patch_margin_right = patch_margin_right
	%OpaqueNotches.patch_margin_top = patch_margin_top
	%PulsingNotches.patch_margin_bottom = patch_margin_bottom
	%PulsingNotches.patch_margin_left = patch_margin_left
	%PulsingNotches.patch_margin_right = patch_margin_right
	%PulsingNotches.patch_margin_top = patch_margin_top
	%OpaqueNotches.texture = notch
	%PulsingNotches.texture = notch
	
func set_child_values():
	var margins = (patch_margin_left + patch_margin_right)
	var seg_width = texture.get_width() - margins
	custom_minimum_size = Vector2((max_value * seg_width) + margins, texture.get_height())
	size = custom_minimum_size
	%OpaqueNotches.visible = value > 0 and value > use_preview
	%OpaqueNotches.size = Vector2(((value - use_preview) * seg_width) + margins, texture.get_height())
	%PulsingNotches.visible = use_preview > 0
	%PulsingNotches.size = Vector2((use_preview * seg_width) + margins, texture.get_height())
	%PulsingNotches.position.x = ((value - use_preview) * seg_width)

func _process(_delta: float) -> void:
	%PulsingNotches.modulate = Color(Color.WHITE, sin(4 * PI * Globals.elapsed_time) * 0.4 + 0.4) 

func set_max_value(v : int):
	max_value = v
	set_child_values()
	
func set_value(v : int):
	value = v
	set_child_values()
	
func set_preview(v : int):
	if v > value:
		pass
	else:
		use_preview = v
	set_child_values()
