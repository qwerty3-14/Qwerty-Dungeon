extends Control
class_name CharacterSelectButton

signal toggled(_toggled_on: bool)

@export var library_key : String


func _ready() -> void:
	if CharacterLibrary.actor_info_dict.has(library_key):
		%Icon.texture = CharacterLibrary.actor_info_dict[library_key].icon


func _on_button_toggled(toggled_on: bool) -> void:
	toggled.emit(toggled_on)
