extends PanelContainer
class_name SkillInfoPanel

func _process(_delta: float) -> void:
	#position = Vector2.ZERO
	%Contents.position = Vector2.ZERO
	custom_minimum_size = %Contents.get_minimum_size()
	%APCost.set_anchors_preset(Control.PRESET_CENTER)
	%APCost.custom_minimum_size = %APCost.size
	size = custom_minimum_size

func load_skill(skill : Skill, actor : Actor = null):
	%SkillTypeLabel.visible = true
	%APCost.max_value = 0
	%APCost.value = 0
	%APCost.visible = false
	%SkillTypeLabel.text = "Passive"
	if skill.display_name:
		%"Skill Name".text = skill.display_name
	else:
		%"Skill Name".text = skill.name
	if actor:
		%Description.text = skill._actor_description(actor)
	else:
		%Description.text = skill.description
	for tag : String in skill.tags:
		var new_label = Label.new()
		new_label.text = tag
		new_label.add_theme_color_override("font_color", Color.BLACK)
		%Tags.add_child(new_label)
	skill.hover_hint_setup(self)

func load_status(status : StatusEffect):
	%SkillTypeLabel.visible = false
	%APCost.max_value = 0
	%APCost.value = 0
	%APCost.visible = false
	%"Skill Name".text = status.display_name
	%Description.text = status.description
	if status.time_based:
		var new_label = Label.new()
		if status.duration == 1:
			new_label.text = "Lasts 1 more phase"
		else:
			new_label.text = "Lasts " + str(status.duration) + " more phases"
		new_label.add_theme_color_override("font_color", Color.BLACK)
		%Tags.add_child(new_label)

func clear_tags():
	for node in %Tags.get_children():
		if not (node == %SkillTypeLabel):
			node.queue_free()

func set_action(ap_spender : APSpender):
	%APCost.set_max_value(ap_spender.ap_cost)
	%APCost.set_value(ap_spender.ap_cost)
	%APCost.visible = true
	%SkillTypeLabel.text = "Action"
	if ap_spender is Reaction:
		%SkillTypeLabel.text = "Reaction"
	elif ap_spender.phase_cooldown != 0:
		var new_label = Label.new()
		if ap_spender.phase_cooldown > 0:
			new_label.text = str(ap_spender.phase_cooldown) + " phase cooldown"
		else:
			new_label.text = "Can be used once per combat"
		new_label.add_theme_color_override("font_color", Color.BLACK)
		%SkillTypeLabel.add_sibling(new_label)


func _on_sort_children() -> void:
	position = Vector2.ZERO
