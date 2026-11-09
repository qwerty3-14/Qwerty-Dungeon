extends Node

signal object_moved( _tile_pos : Vector2i, _combat_object : CombatObject)

func _ready():
	if not MetaCombat.combat_objet_entered_combat.is_connected(_on_combat_objet_entered_combat):
		MetaCombat.combat_objet_entered_combat.connect(_on_combat_objet_entered_combat)
	MetaCombat.combat_started.connect(_on_combat_started)
	if Globals.combat_main and Globals.combat_main.actor_combat_object_list and Globals.combat_main.actor_combat_object_list.size() > 0:
		for combat_object : CombatObject in Globals.combat_main.actor_combat_object_list:
			if !combat_object.moved.is_connected(_on_combat_object_moved.bind(combat_object)):
				combat_object.moved.connect(_on_combat_object_moved.bind(combat_object))

func _on_combat_started():
	pass

func _on_combat_object_moved(tile_pos : Vector2i, combat_object : CombatObject):
	object_moved.emit(tile_pos, combat_object)

func _on_combat_objet_entered_combat(combat_object : CombatObject):
	#print(combat_object.name + ", " + get_parent().name)
	if !combat_object.moved.is_connected(_on_combat_object_moved.bind(combat_object)):
		combat_object.moved.connect(_on_combat_object_moved.bind(combat_object))
