extends Control

const APPENDEX := preload("uid://dnephsml5eqwn")
const CREDITS := preload("uid://6op388gnk5m")
const CHAR_SELECT := preload("uid://ds85en0dsintp")

var appendex : SkillAppendex
var credits : Control
var char_select : Control

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_appendex_pressed() -> void:
	if not appendex:
		appendex = APPENDEX.instantiate()
		add_sibling(appendex)
	appendex.previous_scene = self
	appendex.visible = true
	visible = false


func _on_credits_pressed() -> void:
	if not credits:
		credits = CREDITS.instantiate()
		credits.main_menu = self
		add_sibling(credits)
	credits.visible = true
	visible = false


func _on_new_game_pressed() -> void:
	if not char_select:
		char_select = CHAR_SELECT.instantiate()
		char_select.main_menu = self
		add_sibling(char_select)
	char_select.visible = true
	visible = false
