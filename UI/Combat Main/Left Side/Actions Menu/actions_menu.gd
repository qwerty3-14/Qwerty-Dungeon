extends ColorRect
class_name ActionsMenu

const SKILL_HOTBAR_SLOT = preload("uid://ctgrr528jgm2k")
const EFFECT_DISPLAY_SLOT = preload("uid://xtfy7od3h6s8")
const HOTBAR_DIMENSIONS : Vector2i = Vector2i(3, 8)
const MAX_HP_MAX_VALUE : int = 59
const MAX_AP_MAX_VALUE : int = 20

var actor : Actor
var hotbar_slots : Array[SkillHotbarSlot] = []
#var action_hotbar_slots : Array[SkillHotbarSlot] = []

func _ready() -> void:
	for j in range(0, HOTBAR_DIMENSIONS.y):
		for i in range(0, HOTBAR_DIMENSIONS.x):
			var new_slot : SkillHotbarSlot = SKILL_HOTBAR_SLOT.instantiate()
			hotbar_slots.append(new_slot)
			%SkillHotbarRegion.add_child(new_slot)
			new_slot.position = Vector2(i * 22, j * 22)

func load_actor(new_actor : Actor):
	%AttributesList.load_actor(new_actor)
	%DefAndWard.load_defenses(new_actor.get_parent().defense, new_actor.get_parent().warding)
	#clear old data
	#for slot : SkillHotbarSlot in action_hotbar_slots:
	#	if slot.action_started.is_connected(action_started_with.bind(slot)):
	#		slot.action_started.disconnect(action_started_with.bind(slot))
	#	if slot.action_ended.is_connected(action_ended_with.bind(slot)):
	#		slot.action_ended.disconnect(action_ended_with.bind(slot))
	for slot : SkillHotbarSlot in hotbar_slots:
		if slot.button_focus_entered.is_connected(set_ap_cost):
			slot.button_focus_entered.disconnect(set_ap_cost)
		if slot.button_focus_exit.is_connected(set_ap_cost.bind(0)):
			slot.button_focus_exit.disconnect(set_ap_cost.bind(0))
	hotbar_slots.map(func(slot : SkillHotbarSlot) : slot.remove_skill())
	#action_hotbar_slots.clear()
	if actor:
		actor.health.health_changed.disconnect(set_hp)
		actor.ap_changed.disconnect(set_ap)
		actor.mp_changed.disconnect(set_mp)
	
	actor = new_actor
	if not actor:
		%Contents.visible = false
		return
	%Contents.visible = true
	#Resource Bars
	var max_hp_ratio =  (float)(actor.health.maximum) / Actor.MAX_MAX_HP
	%HPBar.set_max_value(round(max_hp_ratio * MAX_HP_MAX_VALUE))
	set_hp(actor.health.current)
	actor.health.health_changed.connect(set_hp)
	%APBar.set_max_value(actor.max_ap)
	set_ap(actor.cur_ap)
	actor.ap_changed.connect(set_ap)
	%MPBar.set_max_value(actor.max_mp)
	set_mp(actor.cur_mp)
	actor.mp_changed.connect(set_mp)
	
	#portrait and name
	%Portrait.texture = actor.portrait
	%"Name Label".text = actor.character_name
	%"Class Label".text = actor.combat_class
	
	
	#hotbar
	for index : int in actor.hotbar_skills:
		if index < hotbar_slots.size() and index >= 0:
			hotbar_slots[index].set_skill(actor.hotbar_skills[index])
			#hotbar_slots[index].button_focus_entered.connect(set_ap_cost)
			#hotbar_slots[index].button_focus_exit.connect(set_ap_cost.bind(0))
			#if actor.hotbar_skills[index] is Action:
			#	action_hotbar_slots.append(hotbar_slots[index])
			#	hotbar_slots[index].action_started.connect(action_started_with.bind(hotbar_slots[index]))
			#	hotbar_slots[index].action_ended.connect(action_ended_with.bind(hotbar_slots[index]))
	greyout_unplayable_actions()
	
	reload_status()

func reload_status():
	%Effects.get_children().map(func(child : Node) : child.queue_free())
	var co_parent : CombatObject = actor.get_parent()
	for child : Node in co_parent.get_children():
		if child is StatusEffect and not child.is_queued_for_deletion():
			var new_status_slot := EFFECT_DISPLAY_SLOT.instantiate()
			new_status_slot.load_effect(child)
			%Effects.add_child(new_status_slot)

func greyout_unplayable_actions():
	for slot : SkillHotbarSlot in hotbar_slots:
		slot.disable_if_unplayable()

func disable_all_skills():
	hotbar_slots.map(func(slot : SkillHotbarSlot): slot.disable())


func reinable_all_skills():
	hotbar_slots.map(func(slot : SkillHotbarSlot): slot.enable())
	greyout_unplayable_actions()

func set_hp(value : int):
	var hp_ratio =  (float)(value) / Actor.MAX_MAX_HP
	%HPBar.set_value(round(hp_ratio * MAX_HP_MAX_VALUE))
	%HPAmount.text = str(value)

func set_ap(value : int):
	%APBar.set_value(value)
	greyout_unplayable_actions()

func set_mp(value : int):
	%MPBar.set_value(value)

func set_ap_cost(value : int):
	%APBar.set_preview(value)

func set_move_cost(value : int):
	%MPBar.set_preview(value)
