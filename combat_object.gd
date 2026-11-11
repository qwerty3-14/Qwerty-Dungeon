class_name CombatObject
extends Node2D


##emitted when the combat object moves to a new tile
signal moved(pos : Vector2i)

##emitted when calculating damage received from damage
signal modifying_damage_recieved(damage : Damage)
##emitted before damage is taken
signal about_to_take_damage(damage : Damage)
##emitted after damage is takenZ
signal damage_recieved(damage : Damage)

##emitted when a status is applied
signal gained_status(_status : StatusEffect)

signal queued_weapon_attack(event : WeaponAttackEvent)
signal scorring_damage(damage : Damage)
signal killed()

@export var blocks_friendlies : bool = false
@export var blocks_enemies : bool = false
@export var flyer : bool = false
@export var health : Health

var defense : Attribute = Attribute.new(0)
var warding : Attribute = Attribute.new(0)
var weight : int = 0
var tile_position : Vector2i
var negate_damage : bool = false
var scorring_damage_sr : float
var modifying_damage_receieved_flat_SR : int = 0
var modifying_damage_receieved_multiplier_SR : float = 1

func _ready() -> void:
	if(get_parent() is Node2D):
		tile_position = Globals.pix_to_tile_pos(position)

func _process(_delta: float) -> void:
	if flyer:
		var sprite_offset : int = roundi(2 * sin(2 * PI * float(Time.get_ticks_msec() % 1000) / 1000))
		for sprite : Sprite2D in get_children().filter(func(node : Node): return node is Sprite2D):
			sprite.position.y = sprite_offset

func position_on_tile():
	position = Globals.tile_to_pix_pos(tile_position)
	if not flyer:
		var data : TileData = Globals.combat_main.room.tilemap.get_cell_tile_data(tile_position)
		if data and data.get_custom_data("Type") == Globals.tile_types.WATER:
			drown_me()

func move_to(here : Vector2i):
	if not Globals.combat_main.tile_occupied(here):
		tile_position = here
		moved.emit(here)
	else:
		tile_position = here
	Globals.a_star_manager.astar_update_tiles()

func extra_damage_modification(damage : Damage):
	modifying_damage_receieved_flat_SR = 0
	modifying_damage_receieved_multiplier_SR = 1
	modifying_damage_recieved.emit(damage)
	damage.amount += modifying_damage_receieved_flat_SR
	damage.amount = int(damage.amount * modifying_damage_receieved_multiplier_SR)

func receive_damage(damage : Damage):
	if health:
		if not damage.mitigated:
			damage.modify_against(self)
		#print(health.current)
		#if damage.actor_source:
		#	print(damage.actor_source.character_name + " -> " + name)
		#else:
		#	print("(unknown) -> " + name)
		about_to_take_damage.emit(damage)
		#functions connected to about_to_take_damage, set negate_damage
		if not negate_damage:
			health.take_damage(max(0, damage.amount))
			if damage.amount <= 0:
				Globals.over_room_renders.text_popup(tile_position, "No Damage!")
			else:
				Globals.over_room_renders.damage_popup(tile_position, damage)
			if damage.amount > 0:
				damage_recieved.emit(damage)
		negate_damage = false

func remove_me():
	Globals.combat_main.combat_objects.erase(self)
	var killed_event := KilledEvent.new(self)
	CombatEventManager.add_and_start_combat_event(killed_event, true)
	

func drown_me():
	Globals.combat_main.combat_objects.erase(self)
	CombatEventManager.add_and_start_combat_event(DrowmedEvemt.new(self))
	

func emit_queued_weapon_attack(event : WeaponAttackEvent):
	queued_weapon_attack.emit(event)

func apply_status_effect_resistable(effect : StatusEffect, afflicters_potency : int):
	if has_node("Actor"):
		var actor : Actor = get_node("Actor")
		if actor.resilience.value < afflicters_potency:
			apply_status_effect(effect)
		else:
			Globals.over_room_renders.text_popup(tile_position, "Resisted " + effect.display_name)
	else:
		apply_status_effect(effect)

func apply_status_effect(effect : StatusEffect):
	var new_status_name : String = effect.name
	print(new_status_name)
	if has_node(new_status_name):
		var curr_status_effect : StatusEffect = get_node(new_status_name)
		if effect.stack_duration:
			curr_status_effect.duration += effect.duration
		elif curr_status_effect.duration < effect.duration:
			curr_status_effect.name += "deletequeued"
			curr_status_effect.queue_free()
			add_child(effect)
			gained_status.emit(effect)
	else:
		add_child(effect)
		gained_status.emit(effect)
	Globals.actions_menu.reload_status()

func wipe_status_effects():
	for child : Node in get_children():
		if child is StatusEffect:
			child.queue_free()

func score_damage(damage : Damage) -> float:
	scorring_damage_sr = float(damage.amount)
	scorring_damage.emit(damage)
	return scorring_damage_sr

func emit_killed():
	killed.emit()
