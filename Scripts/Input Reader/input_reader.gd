extends Node2D

var validMotionInputs = ["move_left","move_right","move_down","move_up","move_leftdown"]
var validAttackInputs = ["action_a","action_b","action_c"]
var RecentMotionInputs = []
var currentMotionInput = "Neutral"
var currentAttackInput = "Nothing"
var holdtime : int
var memorybuffer : int


func _process(_delta: float) -> void:
	handle_MotionInputs()
	if currentMotionInput == "Neutral":
		$Recent_input.text = str(RecentMotionInputs) ##"Neutral " + str(holdtime)
	else:
		$Recent_input.text = str(currentMotionInput) + " " + str(holdtime)
		
	remove_OldMotionInputs()
	
func handle_MotionInputs() -> void:
	if currentMotionInput != "Neutral":
		if Input.is_action_pressed(currentMotionInput):
			holdtime += 1
			RecentMotionInputs[-1][1] = clamp(holdtime,1,999)
		if Input.is_action_just_released(currentMotionInput):
			currentMotionInput = "Neutral"
			holdtime = 1
	else:
		holdtime += 1
	holdtime = clamp(holdtime,1,999)
	
func remove_OldMotionInputs() -> void:
	if !RecentMotionInputs.is_empty() and !Input.is_action_pressed(currentMotionInput):
		if memorybuffer >= 30:
			RecentMotionInputs.pop_front()
			memorybuffer = 0
		else:
			memorybuffer += 1


func _input(event: InputEvent) -> void:
	if event and !event.is_action(currentMotionInput,true):
		for i in validMotionInputs:
			if event.is_action(i,true):
				currentMotionInput = i
				RecentMotionInputs.append([i,1])
				if str(event) != currentMotionInput:
					holdtime = 1
				break

		for b in validAttackInputs:
			if event.is_action(b,true):
				currentAttackInput = b
				break
