extends HBoxContainer
class_name SkillTreeTab

var dragging_camera : bool = false
var tree : SkillTree

func load_skill_tree(_tree : SkillTree):
	tree = _tree
	%SkillTreeCamera.limit_left = tree.position.x
	%SkillTreeCamera.limit_top = tree.position.y
	%SkillTreeCamera.limit_right = tree.size.x
	%SkillTreeCamera.limit_bottom = tree.size.y
	%CharacterTitle.load_actor_info(tree.actor.actor_info)
	tree.points_changed.connect(_on_points_changed)
	_on_points_changed(tree.points)
	%SubViewport.add_child(tree)
	for node : Node in tree.get_children():
		if node is SkillTreeSlot:
			var slot : SkillTreeSlot = node
			slot.mouse_over.connect(_on_slot_mouse_over.bind(tree.actor))

func give_point():
	tree.give_point()

func _on_slot_mouse_over(_skill_info : SkillInfo, _actor : Actor):
	%InfoPanel.visible = true
	%InfoPanel.load_skill_info(_skill_info, _actor)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 2:
		if event.is_released():
			dragging_camera = false
			%SkillTreeCamera.position.x = roundi(%SkillTreeCamera.get_target_position().x)
			%SkillTreeCamera.position.y = roundi(%SkillTreeCamera.get_target_position().y)
		elif event.is_pressed():
			dragging_camera = true
	if event is InputEventMouseMotion:
		if dragging_camera:
			var iemm : InputEventMouseMotion = event
			%SkillTreeCamera.position = %SkillTreeCamera.get_target_position() - iemm.relative

func _on_points_changed(_points : int):
	%PointsLabel.text = "Points: " + str(_points)
