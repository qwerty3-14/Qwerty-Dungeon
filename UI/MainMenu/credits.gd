extends Control

var main_menu : Control

func _on_return_button_pressed() -> void:
	if main_menu:
		main_menu.visible = true
		visible = false
