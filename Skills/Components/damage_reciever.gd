extends Node

signal object_damaged(_damage : Damage, _combat_object : CombatObject)
signal object_about_to_be_damaged(_damage : Damage, _combat_object : CombatObject)

func _ready():
	if not MetaCombat.combat_objet_entered_combat.is_connected(_on_combat_objet_entered_combat):
		MetaCombat.combat_objet_entered_combat.connect(_on_combat_objet_entered_combat)
	if Globals.combat_main and Globals.combat_main.actor_combat_object_list and Globals.combat_main.actor_combat_object_list.size() > 0:
		for combat_object : CombatObject in Globals.combat_main.actor_combat_object_list:
			if !combat_object.damage_recieved.is_connected(_on_combat_object_damaged.bind(combat_object)):
				combat_object.damage_recieved.connect(_on_combat_object_damaged.bind(combat_object))
			if !combat_object.about_to_take_damage.is_connected(_on_combat_object_about_to_take_damage.bind(combat_object)):
				combat_object.about_to_take_damage.connect(_on_combat_object_about_to_take_damage.bind(combat_object))

func _on_combat_object_damaged(_damage : Damage, _combat_object : CombatObject):
	object_damaged.emit(_damage, _combat_object)
	
func _on_combat_object_about_to_take_damage(_damage : Damage, _combat_object : CombatObject):
	#print(_combat_object.health.current)
	object_about_to_be_damaged.emit(_damage, _combat_object)

func _on_combat_objet_entered_combat(combat_object : CombatObject):
	#print(combat_object.name + ", " + get_parent().name)
	if !combat_object.damage_recieved.is_connected(_on_combat_object_damaged.bind(combat_object)):
		combat_object.damage_recieved.connect(_on_combat_object_damaged.bind(combat_object))
	if !combat_object.about_to_take_damage.is_connected(_on_combat_object_about_to_take_damage.bind(combat_object)):
		combat_object.about_to_take_damage.connect(_on_combat_object_about_to_take_damage.bind(combat_object))
