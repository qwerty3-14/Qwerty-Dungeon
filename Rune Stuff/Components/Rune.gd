@icon("uid://ce3f0j4jsvrpw")
extends Node2D
class_name Rune

signal dropped()
signal placed()
signal picked_up()
signal equiped(actor : Actor)
signal unequiped(actor : Actor)

const RUNE_TEXTURE := preload("uid://bieveu2qqi43h")
const RUNE_SQUARE := preload("uid://cnapdvl8xouk2")
const HIGHLIGHT_TEXTURE : Texture2D = preload("uid://bpapo0fca1fbu")

@export var shape : Array[Vector2i]
@export var frame : Vector2i = Vector2i.ZERO

var hovering : bool = false
#var dragging : bool = false
var area : Area2D
var rot_timer : Timer 
var is_hovering_above : bool = false
var hovering_above : RuneBoard
var snap_coord : Vector2i
var snap_position : Vector2
var pos_rounding_adjustment : Vector2 = Vector2.ZERO
var has_grabber : bool = false
var popup : PanelContainer
var popup_label : Label
var popup_text : String = "Hello"

func _ready() -> void:
	#RuneManager.register_rune(self)
	area = Area2D.new()
	area.collision_layer = 2
	area.collision_mask = 1
	add_child(area)
	for tile : Vector2i in shape:
		var col_shape : CollisionShape2D = CollisionShape2D.new()
		col_shape.shape = RUNE_SQUARE
		area.add_child(col_shape)
		col_shape.position = tile * 8
	area.mouse_entered.connect(_on_mouse_entered)
	area.mouse_exited.connect(_on_mouse_exited)
	
	rot_timer = Timer.new()
	rot_timer.one_shot = true
	rot_timer.wait_time = 0.125
	rot_timer.timeout.connect(_on_rotation_finished)
	add_child(rot_timer)
	popup = PanelContainer.new()
	popup_label = Label.new()
	popup.z_index += 2
	popup.resized.connect(_on_popup_resized)
	popup_label.text = popup_text
	popup.add_child(popup_label)
	add_child(popup)
	popup.visible = false
	RuneManager.register_rune(self)

func _process(_delta: float) -> void:
	if not rot_timer.is_stopped():
		rotation = (1 - (rot_timer.time_left / rot_timer.wait_time)) * PI * 0.5

func _on_rotation_finished():
	rotation = 0
	for i : int in range(shape.size()):
		var old_x : int =  shape[i].x
		shape[i].x =  shape[i].y * -1
		shape[i].y = old_x
		area.get_child(i).position = shape[i] * 8
	queue_redraw()

func _draw() -> void:
	if is_hovering_above:
		draw_rune(snap_position - global_position, 0.5)
	draw_rune(Vector2.ZERO)
	if hovering or RuneManager.dragged_rune == self:
		for tile : Vector2i in shape:
			if not shape.has(tile + Vector2i.LEFT):
				draw_texture_rect_region(HIGHLIGHT_TEXTURE, Rect2(Vector2i(-5, -4) + tile * 8, Vector2i(2, 9)), Rect2(Vector2i(0, 1), Vector2i(2, 9)))
			if not shape.has(tile + Vector2i.RIGHT):
				draw_texture_rect_region(HIGHLIGHT_TEXTURE, Rect2(Vector2i(4, -4) + tile * 8, Vector2i(2, 9)), Rect2(Vector2i(9, 1), Vector2i(2, 9)))
			if not shape.has(tile + Vector2i.UP):
				draw_texture_rect_region(HIGHLIGHT_TEXTURE, Rect2(Vector2i(-4, -5) + tile * 8, Vector2i(9, 2)), Rect2(Vector2i(1, 0), Vector2i(9, 2)))
			if not shape.has(tile + Vector2i.DOWN):
				draw_texture_rect_region(HIGHLIGHT_TEXTURE, Rect2(Vector2i(-4, 4) + tile * 8, Vector2i(9, 2)), Rect2(Vector2i(1, 9), Vector2i(9, 2)))
	

func draw_rune(offset : Vector2, alpha : float = 1):
	for tile : Vector2i in shape:
		var l_frame : Vector2i = frame
		#if (hovering) or RuneManager.dragged_rune == self:
		#	l_frame.y -= 1
		draw_texture_rect_region(RUNE_TEXTURE, Rect2(offset + Vector2(-4, -4) + Vector2(tile * 8), Vector2(9, 9)), Rect2(l_frame * 9, Vector2i(9, 9)), Color(1, 1, 1, alpha))


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_released():
			if RuneManager.dragged_rune == self:
				if check_placement():
					placed.emit()
				else:
					dropped.emit()
				position = position.round()
				queue_redraw()
				RuneManager.dragged_rune = null
		elif event.is_pressed() and hovering and not RuneManager.dragged_rune:
			popup.visible = false
			RuneManager.dragged_rune = self
			#dragging = true
			picked_up.emit()
	if event is InputEventMouseMotion:
		if RuneManager.dragged_rune == self:
			var iemm : InputEventMouseMotion = event
			position -= pos_rounding_adjustment
			position += iemm.relative
			var round_off : Vector2 = position.round()
			pos_rounding_adjustment = round_off - position
			position = round_off
			#position = position.round()
			if is_hovering_above:
				snap_coord = ((global_position - (hovering_above.global_position + Vector2(6.5, 6.5))) * 0.125).round()
				snap_position = Vector2(snap_coord) * 8 + hovering_above.global_position + Vector2(6, 6)
				#print(snap_position)
				queue_redraw()
	if event is InputEventMouseButton and event.button_index == 2:
		if event.is_released() and (RuneManager.dragged_rune == self):
			rot_timer.start()

func check_placement() -> bool:
	if is_hovering_above:
		for tile : Vector2i in shape:
			if not hovering_above.tile_availible(snap_coord + tile):
				return false
		return true
	return false


func _on_mouse_entered():
	if RuneManager.dragged_rune != self:
		popup.visible = true
	queue_redraw()
	if RuneManager.can_grab_from_inventory or not has_grabber:
		hovering = true

func _on_mouse_exited():
	popup.visible = false
	queue_redraw()
	hovering = false


func equip(actor : Actor):
	equiped.emit(actor)


func unequip(actor : Actor):
	unequiped.emit(actor)

func _on_popup_resized():
	popup.position = Vector2(popup.size.x * -0.5, popup.size.y * -0.5 - 16)
