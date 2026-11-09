extends Node

const RUNE_GRABBER := preload("uid://cpdpj3120f68f")

var dragged_rune : Rune
var drag_container : Node2D
var flow_container : HFlowContainer
var can_grab_from_inventory : bool = false


func set_rune_drag_container(node : Node2D):
	drag_container = node
	
func set_rune_flow_container(node : HFlowContainer):
	flow_container = node

func register_rune(rune : Rune):
	rune.picked_up.connect(_on_rune_picked_up.bind(rune))
	rune.dropped.connect(_on_rune_dropped.bind(rune))

func grab_rune(rune : Rune):
	if flow_container and not rune.has_grabber:
		var grabber : RuneGrabber = RUNE_GRABBER.instantiate()
		flow_container.add_child(grabber)
		grabber.attach_rune(rune)

func _on_rune_picked_up(rune : Rune):
	if drag_container:
		rune.reparent(drag_container)


func _on_rune_dropped(rune : Rune):
	grab_rune(rune)
