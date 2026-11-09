extends NinePatchRect
class_name RuneBoard

var hovering_rune : Rune
var tile_bounds : Vector2i
var occupied_tiles : Array[bool] = [false]
var actor : Actor

func _ready():
	%BoardArea.shape.size = size + Vector2(-4, -4)
	%BoardArea.position = %BoardArea.shape.size * 0.5
	tile_bounds = Vector2i((size + Vector2(-5, -5)) * 0.125)
	occupied_tiles.resize(tile_bounds.x * tile_bounds.y)


func _on_area_2d_area_entered(area: Area2D) -> void:
	if hovering_rune:
		remove_hovering_rune()
	hovering_rune = area.get_parent()
	add_hovering_rune()


func _on_area_2d_area_exited(_area: Area2D) -> void:
	if hovering_rune:
		remove_hovering_rune()

func tile_availible(tile : Vector2i) -> bool:
	if tile.x >= 0 and tile.x < tile_bounds.x and tile.y >= 0 and tile.y < tile_bounds.y:
		var index : int = tile.x + tile.y * tile_bounds.x
		return not occupied_tiles[index]
	return false

func _on_rune_placed(rune : Rune):
	rune.reparent(self)
	rune.global_position = rune.snap_position
	for tile : Vector2i in rune.shape:
		var loc : Vector2i = tile + rune.snap_coord
		var index : int = loc.x + loc.y * tile_bounds.x
		occupied_tiles[index] = true
	rune.picked_up.connect(_on_rune_picked_up.bind(rune))
	remove_hovering_rune()
	if actor:
		rune.equip(actor)

func _on_rune_picked_up(rune : Rune):
	if hovering_rune:
		remove_hovering_rune()
	for tile : Vector2i in rune.shape:
		var loc : Vector2i = tile + rune.snap_coord
		var index : int = loc.x + loc.y * tile_bounds.x
		occupied_tiles[index] = false
	rune.picked_up.disconnect(_on_rune_picked_up.bind(rune))
	hovering_rune = rune
	add_hovering_rune()
	if actor:
		rune.unequip(actor)

func add_hovering_rune():
	hovering_rune.hovering_above = self
	hovering_rune.is_hovering_above = true
	hovering_rune.placed.connect(_on_rune_placed.bind(hovering_rune))
	

func remove_hovering_rune():
	hovering_rune.placed.disconnect(_on_rune_placed.bind(hovering_rune))
	hovering_rune.is_hovering_above = false
	hovering_rune.queue_redraw()
	hovering_rune = null
