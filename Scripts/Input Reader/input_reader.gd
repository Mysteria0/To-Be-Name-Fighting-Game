extends Node2D


@export_category('Specials And Normals')
@export var NormalsList : Array[Array]
@export var SpecialsList : Array[Array]

signal MovementInput(Input_key : String)

var validMotionInputs = {'Neutral' : 5,'move_left' : 4,'move_right' : 6,'move_down' : 2,'move_up' : 8,'move_leftdown' : 1,'move_leftup' : 7,'move_rightdown' : 3,'move_rightup' : 9}
var validAttackInputs = {'action_a' : 'a','action_b' : 'b','action_c' : 'c','action_d' : 'd'}
var RecentMotionInputs = []

var currentMotionInput = 5
var currentAttackInput = 'Nothing'

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
	if currentMotionInput == 'Neutral':
		$Control/Recent_input.text = str(RecentMotionInputs)##'Neutral ' + str(holdtime)
	else:
		$Control/Recent_input.text = str(currentMotionInput) + ' ' + str(holdtime)
	if currentAttackInput != 'Nothing':
		$Control/Recent_input.text += ' ' + str(currentAttackInput)

	remove_OldMotionInputs()

func handle_MotionInputs() -> void:
	if currentMotionInput != 5:
		holdtime += 1
		RecentMotionInputs[-1][1] = clamp(holdtime,1,999)
		MovementInput.emit(str(currentMotionInput))
	holdtime = clamp(holdtime,1,999)

func handle_AttackInputs() -> void:
	if Input.is_action_just_released(currentAttackInput):
		currentAttackInput = 'Nothing'

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
				currentMotionInput = validMotionInputs[i]
				RecentMotionInputs.append([currentMotionInput,1])
				if str(event) != currentMotionInput:
					holdtime = 1
				break

		for b in validAttackInputs:
			if event.is_action(b,true):
				currentAttackInput = validAttackInputs[b]
				break
