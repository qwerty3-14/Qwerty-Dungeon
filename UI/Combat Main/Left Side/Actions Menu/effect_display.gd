extends PanelContainer

var current_effect : StatusEffect

func load_effect(effect : StatusEffect):
	%IconRect.texture = effect.icon
	%EffectName.text = effect.display_name
	%Duration.visible = effect.duration > 0
	%Duration.text = str(effect.duration)
	current_effect = effect


func _on_mouse_entered() -> void:
	Globals.over_room_renders.set_status_info_panel(current_effect)


func _on_mouse_exited() -> void:
	Globals.over_room_renders.hide_skill_info_panel()
