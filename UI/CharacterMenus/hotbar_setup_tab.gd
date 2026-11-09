extends VBoxContainer
class_name HotbarSetupTab

const AVAIL_SLOT := preload("uid://dt0eoav2f0mpc")
const SETUP_SLOT := preload("uid://n5cgjw2mb7uc")

var setup_slots : Array[SetupSkillSlot] = []
var cur_avail_slot : AvailibleSkillSlot
var cur_setup_slot : SetupSkillSlot
var dragged_skill : Skill

func _ready() -> void:
	for j in range(0, ActionsMenu.HOTBAR_DIMENSIONS.y):
		for i in range(0, ActionsMenu.HOTBAR_DIMENSIONS.x):
			var new_slot : SetupSkillSlot = SETUP_SLOT.instantiate()
			setup_slots.append(new_slot)
			%SkillHotbarRegion.add_child(new_slot)
			new_slot.position = Vector2(i * 22, j * 22)
			new_slot.moused_over.connect(_on_slot_hovered)
			new_slot.mouse_entered.connect(_on_setup_slot_mouse_entered.bind(new_slot))
			new_slot.mouse_exited.connect(_on_setup_slot_mouse_exited.bind(new_slot))

func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event is InputEventMouseButton and event.button_index == 1:
			if event.is_pressed() and cur_avail_slot:
				dragged_skill = cur_avail_slot.skill
				%FollowIcon.texture = cur_avail_slot.skill.icon
				%CursorFollow.visible = true
				%CursorFollow.global_position = get_global_mouse_position()
			elif event.is_released():
				if cur_setup_slot and dragged_skill:
					cur_setup_slot.load_skill(dragged_skill)
					cur_setup_slot.update_hotbar(setup_slots.find(cur_setup_slot))
				%CursorFollow.visible = false
				dragged_skill = null
		if %CursorFollow.visible and event is InputEventMouseMotion:
			var iemm : InputEventMouseMotion = event
			if iemm.button_mask == 1:
				%CursorFollow.global_position = iemm.global_position

func load_actor(_actor : Actor):
	%CharacterTitle.load_actor_info(_actor.actor_info)
	_actor.learned_skill.connect(_on_actor_learned_skill)
	for skill : Skill in _actor.get_children():
		add_to_all_skills(skill)
	for key : int in _actor.hotbar_skills.keys():
		setup_slots[key].load_skill(_actor.hotbar_skills[key])

func _on_actor_learned_skill(_skill : Skill):
	add_to_all_skills(_skill)
	setup_slots[_skill.actor_parent.hotbar_skills.find_key(_skill)].load_skill(_skill)

func add_to_all_skills(_skill : Skill):
	var new_slot : AvailibleSkillSlot = AVAIL_SLOT.instantiate()
	new_slot.load_skill(_skill)
	new_slot.moused_over.connect(_on_slot_hovered)
	new_slot.mouse_entered.connect(_on_avail_slot_mouse_entered.bind(new_slot))
	new_slot.mouse_exited.connect(_on_avail_slot_mouse_exited.bind(new_slot))
	%SkillFlowContainer.add_child(new_slot)

func _on_slot_hovered(_skill : Skill):
	%InfoPanel.visible = true
	%InfoPanel.load_skill(_skill, _skill.actor_parent)

func _on_avail_slot_mouse_entered(_slot : AvailibleSkillSlot):
	cur_avail_slot = _slot
	
func _on_avail_slot_mouse_exited(_slot : AvailibleSkillSlot):
	cur_avail_slot = null
	
func _on_setup_slot_mouse_entered(_slot : SetupSkillSlot):
	cur_setup_slot = _slot
	
func _on_setup_slot_mouse_exited(_slot : SetupSkillSlot):
	cur_setup_slot = null
