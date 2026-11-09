extends Control

const STORY_WRITER := preload("uid://d0f0igjng4sy3")

@export var character_select_buttons : Array[CharacterSelectButton] = []

var chars_selected : Array[String] = ["empty", "empty", "empty", "empty"]
var main_menu : Control

func _ready() -> void:
	for character_button : CharacterSelectButton in character_select_buttons:
		character_button.toggled.connect(on_character_select_toggled.bind(character_button.library_key))

func on_character_select_toggled(_toggled_on: bool, name_key : String):
	if _toggled_on:
		var index : int = chars_selected.find("empty")
		%CharacterTitleContainer.get_children()[index].load_actor_info(CharacterLibrary.actor_info_dict[name_key])
		chars_selected[index] = name_key
	else:
		var index : int = chars_selected.find(name_key)
		%CharacterTitleContainer.get_children()[index].wipe_actor()
		chars_selected[index] = "empty"
	var empty_count : int = chars_selected.count("empty")
	if empty_count > 0:
		%Begin.disabled = true
		if empty_count > 1:
			%BeginHelp.text = "Select " + str(empty_count) + " more characters before you begin."
		else:
			%BeginHelp.text = "Select 1 more character before you begin."
	else:
		%Begin.disabled = false
		%BeginHelp.text = "You may begin your adventure!"


func _on_return_pressed() -> void:
	if main_menu:
		main_menu.visible = true
		visible = false


func _on_begin_pressed() -> void:
	PlayerStorage.players.clear()
	for key : String in chars_selected:
		var new_player : CombatObject = CharacterLibrary.packed_scene_dict[key].instantiate()
		new_player.visible = true
		PlayerStorage.players.append(new_player)
		PlayerStorage.add_child(new_player)
	visible = false
	var story_writer : Control = STORY_WRITER.instantiate()
	add_sibling(story_writer)
	story_writer.visible = true
	#MetaCombat.load_first_stage()
