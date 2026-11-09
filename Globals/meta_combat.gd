extends Node

const COMBAT_MAIN := preload("uid://boqeoal66gfli")

var combat_main : CombatMain

signal combat_objet_entered_combat(combat_object : CombatObject)
signal first_stage_loaded()
signal combat_started()

func send_combat_started_signal():
	combat_started.emit()

func send_entered_combat_signal(combat_object : CombatObject):
	#print(combat_object.name)
	combat_objet_entered_combat.emit(combat_object)

func send_first_stage_loaded_signal(_combat_main : CombatMain):
	first_stage_loaded.emit()

func load_first_stage():
	combat_main = COMBAT_MAIN.instantiate()
	add_sibling(combat_main)

func give_help_text(text : String):
	if combat_main:
		combat_main.give_help_text(text)
