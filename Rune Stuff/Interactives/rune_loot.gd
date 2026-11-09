extends Node2D

@export var rune_key : RuneLibrary.all_runes
const HOP_CURVE : Curve = preload("uid://wsyql6q0a3h1")
const SCALE_CURVE : Curve = preload("uid://bqn1scgho2ahl")

var shape : Array = []
var frame : int = 0

func _ready() -> void:
	#var scene_state : SceneState = rune_scene.get_state()
	#print(scene_state.get_node_property_name(0, 1))
	#print("Shape: " + str(scene_state.get_node_property_value(0, 1)))
	#print("Frame: " + str(scene_state.get_node_property_value(0, 2)))
	shape = RuneLibrary.rune_info_dict[rune_key].shape
	frame = RuneLibrary.rune_info_dict[rune_key].frame.y
	%MiniRuneDrawer.queue_redraw()
	if get_parent() is CombatObject:
		var co : CombatObject = get_parent()
		co.killed.connect(activate)
	%MiniRuneDrawer.queue_redraw()
	
func _process(_delta: float) -> void:
	var progress : float = 1 - (%Timer.time_left / %Timer.wait_time)
	%MiniRuneDrawer.position = Vector2(0, HOP_CURVE.sample(progress) * -16)
	%MiniRuneDrawer.scale = Vector2.ONE * (1 + 2 * SCALE_CURVE.sample(progress))
	%MiniRuneDrawer.modulate = Color(Color.WHITE, 1 - SCALE_CURVE.sample(progress))

func activate():
	reparent(get_parent().get_parent())
	RuneLibrary.generate_rune(rune_key)
	%Timer.start()
	%MiniRuneDrawer.visible = true

func _on_timer_timeout() -> void:
	queue_free()
