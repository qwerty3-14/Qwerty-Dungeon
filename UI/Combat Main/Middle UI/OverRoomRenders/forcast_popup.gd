extends Node2D

@export var lines : Array[ForecastLine]


func _ready() -> void:
	set_lines()

func set_lines():
	%PopupLabel.text = ""
	for line : ForecastLine in lines:
		%PopupLabel.text = "[p]" +  line.print() + "[/p]"
