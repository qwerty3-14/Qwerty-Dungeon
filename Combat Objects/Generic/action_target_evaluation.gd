class_name ActionTargetEvaluation
extends RefCounted

var action : Action
var settings : Array
var score : float

func debug_text():
	if action:
		print(action.debug_evalutation(self))
	else:
		print("Action score: " + str(score))
