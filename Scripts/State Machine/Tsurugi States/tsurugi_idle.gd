extends State

@export var fall_state : State
@export var jump_state : State
@export var move_state : State
@export var crouching_state : State



func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_pressed('move_up'):
		StateMachine.Old_input = 'move_up'
		return jump_state
	elif Input.is_action_pressed('move_leftup'):
		StateMachine.Old_input = 'move_leftup'
		return jump_state
	elif Input.is_action_pressed('move_rightup'):
		StateMachine.Old_input = 'move_rightup'
		return jump_state
	if StateMachine.Current_Motion == 2:
		return crouching_state
	if StateMachine.Current_Motion == 4 or  StateMachine.Current_Motion == 6:
		return move_state
	return null


func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5,delta)
	if !parent.is_on_floor():
		return fall_state
	return null
