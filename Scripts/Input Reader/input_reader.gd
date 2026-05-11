extends Node2D


@export_category('Specials And Normals')
@export var NormalsList : Array[Array]
@export var SpecialsList : Array[Array]


var validMotionInputs = {'Neutral' : 5,'move_left' : 4,'move_right' : 6,'move_down' : 2,'move_up' : 8,'move_leftdown' : 1,'move_leftup' : 7,'move_rightdown' : 3,'move_rightup' : 9}
var validAttackInputs = {'action_a' : 'a','action_b' : 'b','action_c' : 'c','action_d' : 'd'}
var RecentMotionInputs = []

var currentMotionInput : int = 5
var currentAttackInput : String = 'Nothing'

var holdtime : int
var memorybuffer : int

var specials : Array
var normals : Array

var parent
func _ready() -> void:
	for i in SpecialsList:
		specials.append(i)
	for i in NormalsList:
		normals.append(i)
	if get_parent():
		parent = get_parent()

func _process(_delta: float) -> void:
	handle_MotionInputs()
	handle_AttackInputs()
	$Control/Recent_input.text = str(RecentMotionInputs)## + ' ' + str(holdtime)
	if currentAttackInput != 'Nothing':
		$Control/Recent_input.text += ' ' + str(currentAttackInput)

	remove_OldMotionInputs()

func handle_MotionInputs() -> void:
		if Input.is_action_just_released(ConvertNumToaction(currentMotionInput)):
				holdtime = 1
				currentMotionInput = 5
		if currentMotionInput != 5:
			if Input.is_action_pressed(ConvertNumToaction(currentMotionInput)):
				holdtime += 1
				holdtime = clamp(holdtime,1,999)
				RecentMotionInputs[-1][1] = holdtime
		else:
			holdtime += 1

func handle_AttackInputs() -> void:
	if Input.is_action_just_released(currentAttackInput):
		currentAttackInput = 'Nothing'

func remove_OldMotionInputs() -> void:
	if !RecentMotionInputs.is_empty() and !Input.is_action_pressed(ConvertNumToaction(currentMotionInput)):
		if memorybuffer >= 30:
			RecentMotionInputs.pop_front()
			memorybuffer = 0
		else:
			memorybuffer += 1

# V = vertical num (2 or 8)
# H = horizontal num (4 ir 6)
# V-1-(4-H)
# this is used to calculate the diagonal when two inputs are pressed at the same time
# now to figure out how to implement it....

func _input(event: InputEvent) -> void:
	# the _input function handles only 1 input at a time
	# how do we make it understand 2 inputs at the same time?
	if event and !event.is_action(ConvertNumToaction(currentMotionInput),true):
		for i in validMotionInputs:
			if event.is_action(i,true):
				currentMotionInput = validMotionInputs[i]
				RecentMotionInputs.append([currentMotionInput,1])
				if str(event) != ConvertNumToaction(currentMotionInput):
					holdtime = 1
				break

		for b in validAttackInputs:
			if event.is_action(b,true):
				currentAttackInput = validAttackInputs[b]
				break

func ConvertNumToaction(Num_to_convert : int) -> String:
	match Num_to_convert:
		1:
			return 'move_leftdown'
		2:
			return 'move_down'
		3:
			return 'move_rightdown'
		4:
			return 'move_left'
		5:
			return 'Neutral'
		6:
			return 'move_right'
		7:
			return 'move_leftup'
		8:
			return 'move_up'
		9:
			return 'move_rightup'
	return 'Neutral'
