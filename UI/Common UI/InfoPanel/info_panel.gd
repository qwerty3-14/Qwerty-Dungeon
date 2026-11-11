extends PanelContainer
class_name InfoPanel

func load_skill_info(_skill_info : SkillInfo, _actor : Actor = null):
	clear_data()
	%Icon.texture = _skill_info.icon
	%SkillNameLabel.text = _skill_info.display_name
	if _actor:
		%Description.text = convert_description(Write.generic_actor_skill_desc(_skill_info.description, _actor))
		if _skill_info.target_range == -1:
			load_range(_actor.default_weapon_attack.target_range)
	else:
		%Description.text = convert_description(_skill_info.description)
	
	match _skill_info.skill_type:
		SkillInfo.skill_types.ACTION:
			%TypeLabel.text = "Action"
		SkillInfo.skill_types.REACTION:
			%TypeLabel.text = "Reaction"
		
	
	if _skill_info.ap_cost > 0:
		%APCost.set_max_value(_skill_info.ap_cost)
		%APCost.set_value(_skill_info.ap_cost)
		%APCost.visible = true
	
	if _skill_info.target_range > 0:
		set_range(_skill_info.target_range, _skill_info.min_target_range)
	elif _skill_info.target_range == -1 and not _actor:
		set_range(-1)
		
	if _skill_info.aoe > 0:
		load_radius(_skill_info.aoe)
	
	if _skill_info.action_cooldown > 0:
		%Hourglass.visible = true
		%Wrench.visible = false
		%DurationContainer.visible = true
		%DurationLabel.text = ":" + str(_skill_info.action_cooldown)
		%DurationContainer.tooltip_text = str(_skill_info.action_cooldown) + " Phase cooldown"
	elif _skill_info.action_cooldown < 0:
		%Hourglass.visible = false
		%Wrench.visible = true
		%DurationContainer.visible = true
		%DurationLabel.text = ":" + str(_skill_info.action_cooldown * -1)
		%DurationContainer.tooltip_text = str(_skill_info.action_cooldown * -1) + " uses this combat"
		
	
	if _skill_info.action_type != Action.types.UNLABELED:
		load_action_type(_skill_info.action_type)

func load_skill(_skill : Skill, _actor : Actor = null):
	clear_data()
	%Icon.texture = _skill.icon
	%SkillNameLabel.text = _skill.display_name
	if _actor:
		%Description.text = convert_description(_skill._actor_description(_actor))
	else:
		%Description.text = convert_description(_skill.description)
	_skill.setup_info_panel_extras(self)

func load_status(status : StatusEffect):
	clear_data()
	%Icon.texture = status.icon
	%TypeLabel.text = "Status"
	%SkillNameLabel.text = status.display_name
	if status.duration > 0:
		if status.time_based:
			%Hourglass.visible = true
			%Wrench.visible = false
			%DurationContainer.visible = true
			%DurationLabel.text = ":" + str(status.duration)
			%DurationContainer.tooltip_text = str(status.duration) + " Phases left"
		else:
			%Hourglass.visible = false
			%Wrench.visible = true
			%DurationContainer.visible = true
			%DurationLabel.text = ":" + str(status.duration)
			%DurationContainer.tooltip_text = str(status.duration) + " Charges"
			
	%Description.text = status.description

func load_desc(title : String, contents : String):
	clear_data()
	%IconBorder.visible = false
	%TypeLabel.text = "Attribute"
	%SkillNameLabel.text = title
	%Description.text = contents
	

func clear_data():
	%IconBorder.visible = true
	%APCost.max_value = 0
	%APCost.value = 0
	%APCost.visible = false
	%TypeLabel.text = "Passive"
	%DurationContainer.visible = false
	%RangeContainer.visible = false
	%ActionTypeContainer.visible = false
	%RadiusContainer.visible = false
	

func convert_description(description : String) -> String:
	description = description.replace("<PD>",  "[color=" + Damage.color_code[Damage.Type.PIERCING] + "]piercing damage[/color]")
	description = description.replace("<PD-2>",  "[color=" + Damage.color_code[Damage.Type.PIERCING] + "]piercing damage[/color]")
	description = description.replace("<CD>",  "[color=" + Damage.color_code[Damage.Type.CRUSHING] + "]crushing damage[/color]")
	description = description.replace("<SD>",  "[color=" + Damage.color_code[Damage.Type.SLASHING] + "]slashing damage[/color]")
	description = description.replace("<VD>",  "damage")
	description = description.replace("<ED>",  "[color=" + Damage.color_code[Damage.Type.ELDER] + "]elder damage[/color]")
	description = description.replace("<ED-6>",  "[color=" + Damage.color_code[Damage.Type.ELDER] + "]elder damage[/color]")
	description = description.replace("<FD>",  "[color=" + Damage.color_code[Damage.Type.FIRE] + "]fire damage[/color]")
	description = description.replace("<LD>",  "[color=" + Damage.color_code[Damage.Type.ELECTRIC] + "]electric damage[/color]")
	
	description = description.replace("<L>",  "Chance")
	description = description.replace("<L2>",  "Chance")
	description = description.replace("<L3>",  "Chance")
	
	description = description.format({"P>R" : "Your potency must be greater than the target's resiliance", "M>R" : "Your might must be greater than the target's resiliance"})
	description = description.format({"DM" : "Damage=mgt", "DP" : "Damage=pot", "Actor" : "you", "CL" : "Chance = Luck", "DB" : "Damage is based on your basic attack"})
	return description

func load_ap(ap_spender : APSpender):
	%TypeLabel.text = "Reaction"
	if ap_spender is Action:
		%TypeLabel.text = "Action"
		load_action_type(ap_spender.type)
		if ap_spender.phase_cooldown > 0:
			%DurationContainer.visible = true
			%DurationLabel.text = ":" + str(ap_spender.phase_cooldown)
			%DurationContainer.tooltip_text = str(ap_spender.phase_cooldown) + " Phase cooldown"
	if ap_spender.ap_cost > 0:
		%APCost.set_max_value(ap_spender.ap_cost)
		%APCost.set_value(ap_spender.ap_cost)
		%APCost.visible = true


func load_range(target_range : TargetRange):
	if target_range:
		set_range(target_range.attack_range, target_range.min_range)
	else:
		set_range(-1)

func set_range(_max : float, _min : float = 0):
	%RangeContainer.visible = true
	if _max == -1:
		%RangeLabel.text = ":?"
		%RangeContainer.tooltip_text = "Range is dependent on actor's basic attack"
	else:
		if _min > 0:
			%RangeLabel.text = ":" + str(_min) + "-" + str(_max)
			%RangeContainer.tooltip_text = str(_min) + "-" + str(_max) + " Tile range"
		else:
			%RangeLabel.text = ":" + str(_max)
			%RangeContainer.tooltip_text = str(_max) + " Tile range"

func load_radius(radius : float):
	%RadiusContainer.visible = true
	%RadiusLabel.text = ":" + str(radius)
	%RadiusContainer.tooltip_text = str(radius) + " Tile radius"
	

func load_action_type(type : Action.types):
	if type != Action.types.UNLABELED:
		%ActionTypeContainer.visible = true
		%BasicAttackIcon.visible = false
		%SpecialAttackIcon.visible = false
		%FireSpellIcon.visible = false
		%ElderSpellIcon.visible = false
		%AlchemyIcon.visible = false
		%ArtIcon.visible = false
		%MetIcon.visible = false
		match type:
			Action.types.BASIC_WEAPON_ATTACK:
				%ActionTypeContainer.tooltip_text = "Basic weapon attack"
				%BasicAttackIcon.visible = true
			Action.types.MODIFIED_WEAPON_ATTACK:
				%ActionTypeContainer.tooltip_text = "Inherits properties from the actor's basic weapon attack"
				%SpecialAttackIcon.visible = true
			Action.types.FIRE_MAGIC:
				%ActionTypeContainer.tooltip_text = "Fire Spell"
				%FireSpellIcon.visible = true
			Action.types.ELDER_MAGIC:
				%ActionTypeContainer.tooltip_text = "Elder Magic"
				%ElderSpellIcon.visible = true
			Action.types.ALCHEMY:
				%ActionTypeContainer.tooltip_text = "Alchemy"
				%AlchemyIcon.visible = true
			Action.types.MARTIAL_ART:
				%ActionTypeContainer.tooltip_text = "Martial Art"
				%ArtIcon.visible = true
			Action.types.METEOROLOGY:
				%ActionTypeContainer.tooltip_text = "Meteorology"
				%MetIcon.visible = true
			
		
