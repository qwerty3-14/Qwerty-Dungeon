extends Control
class_name SkillTreeSlot

signal just_aquired()
signal mouse_over(_skill_info : SkillInfo)

@export var library_key : String
@export var availible : bool = false
@export var aquired : bool = false
@export var locked : bool = false
@export var prerequisites : Array[SkillTreeSlot]
@export var mutually_exlusives : Array[SkillTreeSlot]
@export var prerequisites_required : int = -1

var skill_info : SkillInfo
var tree_parent : SkillTree

func _ready() -> void:
	if library_key:
		skill_info = SkillLibrary.info_dict[library_key]
		%SkillIcon.texture = skill_info.icon
		#add_child(skill)
	update_button_status()
	if prerequisites.size() > 0:
		for slot : SkillTreeSlot in prerequisites:
			slot.just_aquired.connect(check_prerequisites)
		for slot : SkillTreeSlot in mutually_exlusives:
			slot.just_aquired.connect(lock)
	if get_parent() is SkillTree:
		tree_parent = get_parent()
		just_aquired.connect(tree_parent._on_skill_aquired.bind(library_key))

func update_button_status():
	if locked:
		%Button.disabled = true
		%InCycleHighlight.visible = false
	elif aquired:
		%Button.visible = false
	elif availible:
		%InCycleHighlight.visible = true
		%Button.disabled = false
	else:
		%Button.disabled = true

func lock():
	locked = true
	availible = false
	%LockTexture.visible = true
	update_button_status()

func make_availible():
	availible = true
	%InCycleHighlight.visible = true
	%Button.disabled = false


func _on_button_pressed() -> void:
	if tree_parent and tree_parent.points <= 0:
		pass
	elif availible:
		aquired = true
		availible = false
		%InCycleHighlight.visible = false
		update_button_status()
		just_aquired.emit()

func check_prerequisites():
	if locked:
		return
	#print(prerequisites.filter(func(slot : SkillTreeSlot): return slot.aquired))
	if prerequisites_required == -1:
		if prerequisites.find_custom(func(slot : SkillTreeSlot): return not slot.aquired) == -1:
			availible = true
			update_button_status()
	elif prerequisites.filter(func(slot : SkillTreeSlot): return slot.aquired).size() >= prerequisites_required:
		availible = true
		update_button_status()






func _on_mouse_entered() -> void:
	if skill_info:
		mouse_over.emit(skill_info)
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	pass # Replace with function body.
