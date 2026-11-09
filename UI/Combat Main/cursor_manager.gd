extends Node
class_name CursorManager

signal cursor_tile_position_changed(_position : Vector2i, _in_bounds : bool)
signal tile_position_clicked(tile_position : Vector2i)

@export var cursor_sprite : TileCursor

var cursor_tile_pos : Vector2i
var old_mouse_tile_pos : Vector2i
var old_in_bounds_status : bool = false
var freeze_cursor : bool = false


func _process(_delta: float) -> void:
	if Input.is_action_just_released("HoldCursor"):
		freeze_cursor = false
	elif Input.is_action_just_pressed("HoldCursor"):
		freeze_cursor = true
	if cursor_sprite and not freeze_cursor:
		var mouse_pos : Vector2 = get_viewport().get_mouse_position() - cursor_sprite.get_parent().global_position
		var mouse_tile_pos : Vector2i = Globals.pix_to_tile_pos(mouse_pos)
		if(Globals.tile_pos_in_bounds(mouse_tile_pos)):
			if mouse_tile_pos != old_mouse_tile_pos:
				cursor_tile_pos = mouse_tile_pos
				cursor_tile_position_changed.emit(cursor_tile_pos, Globals.tile_pos_in_bounds(cursor_tile_pos))
		old_mouse_tile_pos = mouse_tile_pos


func _input(event: InputEvent) -> void:
	if Globals.combat_main.visible and event is InputEventMouseButton and event.button_index == 1:
		if event.is_released() and cursor_sprite.visible:
			tile_position_clicked.emit(cursor_tile_pos)
			if not Globals.combat_main.action_is_active:
				CombatEventManager.cancel_step_queue()
				if Globals.a_star_manager.saved_path.size() > 0:
					Globals.a_star_manager.travel_path(Globals.combat_main.current_actor_combat_object)

func set_cursor_aoe(radius : float):
	cursor_sprite.set_aoe(radius)

func set_cursor_extra_tiles(tiles : Array[Vector2i]):
	cursor_sprite.set_extra_tiles(tiles)

func _on_cursor_tile_position_changed(_position: Vector2i, _in_bounds: bool) -> void:
	#print(_position)
	cursor_sprite.visible = _in_bounds
	cursor_sprite.set_tile_pos(cursor_tile_pos)
	old_in_bounds_status = _in_bounds
	

func disable_cursor():
	if not freeze_cursor:
		cursor_tile_position_changed.emit(Vector2i.ZERO, false)

func set_cursor_position(pos : Vector2i):
	if not freeze_cursor:
		cursor_tile_pos = pos
		cursor_tile_position_changed.emit(cursor_tile_pos, true)
