class_name Skill
extends Node

signal help_text_update(text : String)
signal attached_to_hotbar_slot(slot : SkillHotbarSlot)
signal removed_from_hotbar_slot(slot : SkillHotbarSlot)
signal need_info_panel_extras(info_panel : InfoPanel)
signal hover_hints_given()
signal hover_hints_removed()
signal skill_clicked()
signal checking_playable()
signal aquired_by_actor(_actor : Actor)

@export var skill_info : SkillInfo
var icon : Texture2D
var display_name : String
var description : String

var actor_parent : Actor
var combat_object_grandparent : CombatObject
var show_playable : bool = true

func _ready() -> void:
	help_text_update.connect(MetaCombat.give_help_text)
	if get_parent() is Actor:
		#print(display_name)
		setup_actor()
		Globals.global_singletons_redied.connect(emit_aquired_by_actor)
		Globals.global_singletons_redied.connect(_on_aquired_by_actor)
		#actor_parent.finished_ready.connect(_update_description)

func move_to_actor(_actor : Actor):
	_actor.learn_skill(self)

func setup_actor():
	if skill_info:
		icon = skill_info.icon
		display_name = skill_info.display_name
		description = skill_info.description
	actor_parent = get_parent()
	if actor_parent.get_parent() is CombatObject:
		combat_object_grandparent = actor_parent.get_parent()
	if Globals.finished_singletons_setup:
		#actor_parent.ready.connect(emit_aquired_by_actor)
		#actor_parent.ready.connect(_on_aquired_by_actor)
		if actor_parent.is_node_ready():
			aquired_by_actor.emit(actor_parent)
			_on_aquired_by_actor()
		else:
			actor_parent.ready.connect(emit_aquired_by_actor)
			actor_parent.ready.connect(_on_aquired_by_actor)
			

func emit_aquired_by_actor():
	aquired_by_actor.emit(actor_parent)

#intended to be overridden
func _on_aquired_by_actor():
	pass



func send_help_text(text : String):
	help_text_update.emit(text)

func attach_to_hotbar_slot(slot : SkillHotbarSlot):
	attached_to_hotbar_slot.emit(slot)

func remove_from_hotbar_slot(slot : SkillHotbarSlot):
	removed_from_hotbar_slot.emit(slot)

func setup_info_panel_extras(info_panel : InfoPanel):
	need_info_panel_extras.emit(info_panel)

func give_hover_hints():
	hover_hints_given.emit()
	Globals.over_room_renders.set_skill_info_panel(self)

func remove_hover_hints():
	Globals.over_room_renders.hide_skill_info_panel()
	hover_hints_removed.emit()

func click():
	skill_clicked.emit()

func check_playable() -> bool:
	show_playable = true
	#connected method can modify show_playable
	checking_playable.emit()
	return show_playable

#intended to be overwritten
func _actor_description(_actor : Actor) -> String:
	return Write.generic_actor_skill_desc(description, _actor)

#intended to be overwritten
func _on_ready():
	pass 
