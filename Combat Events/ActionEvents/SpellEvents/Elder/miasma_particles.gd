extends Node2D


func setup_tiles(tile_pos : Vector2i, tiles : Array[Vector2i]):
	for tile in tiles:
		var new_particles : GPUParticles2D = %CloudParticles.duplicate()
		add_child(new_particles)
		new_particles.position = (tile - tile_pos) * 16
	tiles.append(tile_pos)

func stop_emitting():
	
	for particles : GPUParticles2D in get_children():
		particles.emitting = false
	
