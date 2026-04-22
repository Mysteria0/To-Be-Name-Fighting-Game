extends Node2D

var validactions = ["move_left","move_right","move_down","move_up","move_leftdown"]
var Recentinputs = []
var currentinput : StringName
var holdtime : float
var memorybuffer : int

func _process(_delta: float) -> void:
	if currentinput:
		if Input.is_action_pressed(currentinput):
			holdtime += 1
		else:
			currentinput = ""
			holdtime = 0
	else:
		holdtime += 1
	if currentinput == "":
		$Recent_input.text = "Neutral " + str(holdtime)
	else:
		$Recent_input.text = str(currentinput) + " " + str(holdtime)
	if Recentinputs.size() > 1 and memorybuffer == 30:
		Recentinputs.pop_front()
		memorybuffer = 0
	else:
		memorybuffer += 1
		
		
func _input(event: InputEvent) -> void:
	for i in validactions:
		if event.is_action(i,true):
			currentinput = i
			Recentinputs.append(currentinput)
			if str(event) != currentinput:
				holdtime = 0
			break
