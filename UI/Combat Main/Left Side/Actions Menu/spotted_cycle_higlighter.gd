@icon("uid://dfoy0i417omp7")
extends NinePatchRect


func _process(_delta: float) -> void:
	if visible:
		region_rect.position.y = 6 * (floori(8 * Globals.elapsed_time) % 4)
