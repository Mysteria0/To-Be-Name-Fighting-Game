extends Node2D

var Recentinputs = {}
var currentinput : InputEvent
var holdtime : int
var validinputs = "WASD"

func _process(delta: float) -> void:
	if currentinput:
		if Input.is_action_pressed(currentinput.to_string()):
			holdtime += 1
			Recentinputs.set(currentinput,holdtime)
			pass
		currentinput = null
		

func process_input(event: InputEvent) -> void:
	currentinput = event
	Recentinputs.append(currentinput)
	holdtime = 0
