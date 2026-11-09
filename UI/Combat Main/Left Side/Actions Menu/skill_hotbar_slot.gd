extends Control
class_name SkillHotbarSlot

signal button_focus_entered()
signal button_focus_exit()
signal mid_action_button_clicked()

@export var current_skill : Skill

func _process(_delta: float) -> void:
	if %Higlight.visible:
		if sin(Globals.elapsed_time * 4 * PI) < 0:
			%Higlight.region_rect = Rect2(0, 0, 9, 9)
			%Higlight.patch_margin_left = 4
			%Higlight.patch_margin_top = 4
			%Higlight.patch_margin_right = 4
			%Higlight.patch_margin_bottom = 4
		else:
			%Higlight.region_rect = Rect2(1, 1, 7, 7)
			%Higlight.patch_margin_left = 3
			%Higlight.patch_margin_top = 3
			%Higlight.patch_margin_right = 3
			%Higlight.patch_margin_bottom = 3

func set_skill(skill : Skill):
	current_skill = skill
	%SkillIcon.texture = skill.icon
	%Button.disabled = false
	current_skill.attach_to_hotbar_slot(self)


func remove_skill():
	if current_skill:
		current_skill.remove_from_hotbar_slot(self)
	%Button.disabled = true
	%SkillIcon.texture = null
	current_skill = null
	%CooldownLabel.visible = false
	%Button.visible = true


func _on_button_mouse_entered() -> void:
	#if not %Button.disabled:
	if current_skill:
		current_skill.give_hover_hints()
	button_focus_entered.emit()


func _on_button_mouse_exited() -> void:
	#if not %Button.disabled:
	if current_skill:
		current_skill.remove_hover_hints()
	button_focus_exit.emit()


func _on_button_pressed() -> void:
	if Globals.combat_main.action_is_active:
		mid_action_button_clicked.emit()
	elif current_skill:
		current_skill.click()
		
		#for when action is not instant use
		if Globals.combat_main.action_is_active:
			%Higlight.visible = true
			%Button.visible = false
			Globals.over_room_renders.hide_skill_info_panel()


func disable_if_unplayable():
	if current_skill and not current_skill.check_playable():
		disable()

func disable():
	if current_skill:
		%Button.disabled = true

func enable():
	if current_skill:
		%Button.disabled = false

func set_cooldown(cooldown : int):
	if cooldown == 0:
		enable()
		%CooldownLabel.visible = false
		disable_if_unplayable()
	else:
		disable()
		%CooldownLabel.visible = true
		if cooldown < 0:
			%CooldownLabel.text = "X"
		else:
			%CooldownLabel.text = str(cooldown)

func set_cycle_visibility(on : bool):
	%InCycleHighlight.visible = on

func override_icon(texture : Texture2D):
	%SkillIcon.texture = texture

func reset_icon():
	if current_skill:
		%SkillIcon.texture = current_skill.icon
	else:
		current_skill = null

func _on_action_ended():
	%Higlight.visible = false
	%Button.visible = true
