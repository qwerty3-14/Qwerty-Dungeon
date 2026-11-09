extends Node2D
class_name OverRoomRenders 

enum tile_higlihter_variant {
	RED,
	YELLOW,
	GREEN
}

const OBJECT_HIGHLIGHTER = preload("uid://dc10rfq3kd63n")
const TILE_HIGHLIGHTER = preload("uid://gebvwko13dta")
const DAMAGE_POPUP = preload("uid://yeg7fnx3bwgm")
const TEXT_POPUP = preload("uid://c0ellj02yv8w3")
const FORECAST_POPUP = preload("uid://bwl1lija18y7r")
const LINE_ARROW = preload("uid://yoc1t4mcegbj")

@onready var combat_event_effects : Node2D = %CombatEventEffects

func set_skill_info_panel(skill : Skill):
	%InfoPanel.visible = true
	%InfoPanel.load_skill(skill, skill.actor_parent)
	
func set_status_info_panel(status : StatusEffect):
	%InfoPanel.visible = true
	%InfoPanel.load_status(status)

func set_desc_info_panel(title : String, contents : String):
	%InfoPanel.visible = true
	%InfoPanel.load_desc(title, contents)

func hide_skill_info_panel():
	%InfoPanel.visible = false
	

func damage_popup(tile_pos : Vector2i, damage : Damage):
	var popup = DAMAGE_POPUP.instantiate()
	popup.damage = damage
	%DamageNumbers.add_child(popup)
	popup.position = Globals.tile_to_pix_pos(tile_pos)

func miss_popup(tile_pos : Vector2i):
	text_popup(tile_pos, "Miss!")


func text_popup(tile_pos : Vector2i, text : String):
	var popup = TEXT_POPUP.instantiate()
	popup.text = text
	%DamageNumbers.add_child(popup)
	popup.position = Globals.tile_to_pix_pos(tile_pos)

func icon_popup(tile_pos : Vector2i, icon : Texture2D):
	var popup = TEXT_POPUP.instantiate()
	popup.texture = icon
	%DamageNumbers.add_child(popup)
	popup.position = Globals.tile_to_pix_pos(tile_pos)

func highlight_tiles(tiles : Array[Vector2i], group_name : String, variant : tile_higlihter_variant = tile_higlihter_variant.RED):
	setup_group(group_name)
	var group : Node2D = get_node(group_name)
	for tile : Vector2i in tiles:
		var tile_highlighter := TILE_HIGHLIGHTER.instantiate()
		if tiles.has(tile + Vector2i(1, 0)):
			tile_highlighter.right_occupied = true
		if tiles.has(tile + Vector2i(-1, 0)):
			tile_highlighter.left_occupied = true
		if tiles.has(tile + Vector2i(0, -1)):
			tile_highlighter.top_occupied = true
		if tiles.has(tile + Vector2i(0, 1)):
			tile_highlighter.bottom_occupied = true
		tile_highlighter.variant = variant
		group.add_child(tile_highlighter)
		tile_highlighter.position = Globals.tile_to_pix_pos(tile)

func line_arrow(start : Vector2i, end : Vector2i, group_name : String):
	setup_group(group_name)
	var group : Node2D = get_node(group_name)
	var arrow := LINE_ARROW.instantiate()
	arrow.start = start
	arrow.end = end
	group.add_child(arrow)
	

func highlight_movement_range(actor : Actor):
	clear_movement()
	var ap_tiles : Array[Vector2i] = Globals.a_star_manager.tiles_in_reach(actor.co_parent, actor.cur_mp + actor.cur_ap)
	var mp_tiles : Array[Vector2i] = Globals.a_star_manager.tiles_in_reach(actor.co_parent, actor.cur_mp)
	#print_rich(
	#	"[p]"+ str(actor.co_parent) +"[/p]" +
	#	"[p]AP Tiles: "+ str(ap_tiles) +"[/p]" +
	#	"[p]MP Tiles: "+ str(mp_tiles) +"[/p]" +
	#	"[p]------[/p]")
	highlight_tiles(ap_tiles, "ap_movement", tile_higlihter_variant.GREEN)
	highlight_tiles(mp_tiles, "mp_movement", tile_higlihter_variant.YELLOW)

func clear_movement():
	clear_group("ap_movement")
	clear_group("mp_movement")

func higlight_object(tile_pos : Vector2i, group_name : String):
	setup_group(group_name)
	var group : Node2D = get_node(group_name)
	var object_highlighter := OBJECT_HIGHLIGHTER.instantiate()
	group.add_child(object_highlighter)
	object_highlighter.position = Globals.tile_to_pix_pos(tile_pos)

func create_or_move_action_forecast(tile_pos : Vector2i, lines : Array[ForecastLine]):
	if %DamageForecasts.get_child_count() > 0:
		%DamageForecasts.get_child(0).lines = lines
		%DamageForecasts.get_child(0).position = Globals.tile_to_pix_pos(tile_pos)
	else:
		action_forecast(tile_pos, lines)

func action_forecast(tile_pos : Vector2i, lines : Array[ForecastLine]):
	var forecast := FORECAST_POPUP.instantiate()
	forecast.lines = lines
	%DamageForecasts.add_child(forecast)
	forecast.position = Globals.tile_to_pix_pos(tile_pos)

func clear_forecast():
	%DamageForecasts.get_children().map(func(child : Node): child.queue_free())

func has_forecast_at(loc : Vector2i):
	return %DamageForecasts.get_children().find_custom(func(node2d : Node2D): return Globals.pix_to_tile_pos(node2d.position) == loc) > -1

func filter_forecast(tiles : Array[Vector2i]):
	for child : Node2D in %DamageForecasts.get_children():
		if not tiles.has(Globals.pix_to_tile_pos(child.position)):
			child.queue_free()

func remove_group(group_name : String):
	if has_node(group_name):
		get_node(group_name).queue_free()
	else:
		pass
		#push_warning("The group '" + group_name + "' doesn't exist")

func clear_group(group_name : String):
	if has_node(group_name):
		get_node(group_name).get_children().map(func(node : Node): node.queue_free())
	else:
		pass

func setup_group(group_name : String):
	if not has_node(group_name):
		var new_node : Node2D = Node2D.new()
		new_node.name = group_name
		%mp_movement.add_sibling(new_node)
		#add_child(new_node)
