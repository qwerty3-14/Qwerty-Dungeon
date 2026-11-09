extends Node
class_name StatusEffect

signal ticked()
signal expired()
signal phase_started()

@export var icon : Texture2D
@export var display_name : String
@export var duration : int = 0
##If true this status with reduces its duration at the end of the phase
@export var time_based : bool = true
##if true when reapplying this status the duration will be added together instead of the higher duration one overriding
@export var stack_duration : bool = false

var description : String
var parent : CombatObject
var actor : Actor

func _ready() -> void:
	Globals.combat_main.phase_ending.connect(phase_tick)
	Globals.combat_main.phase_starting.connect(phase_start)
	if get_parent() is CombatObject:
		parent = get_parent()
		Globals.over_room_renders.icon_popup(parent.tile_position, icon)
		if parent.has_node("Actor"):
			actor = parent.get_node("Actor")
	else:
		printerr("Parent should be CombatObject")



func phase_tick():
	ticked.emit()
	if time_based:
		reduce_duration()

func phase_start():
	phase_started.emit()

func reduce_duration():
	duration -= 1
	if duration <= 0:
		expired.emit()
		queue_free()
