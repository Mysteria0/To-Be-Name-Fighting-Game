extends State

@export var fall_state : State
@export var jump_state : State
@export var move_state : State
@export var crouching_state : State



func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_up') or Input.is_action_just_pressed("move_leftup") or Input.is_action_just_pressed("move_rightup"):
		if parent.is_on_floor():
			StateMachine.Old_input = StateMachine.Current_Motion
			return jump_state
	if Input.is_action_pressed('move_down') and parent.is_on_floor():
		return crouching_state
	if Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right') and parent.is_on_floor():
		return move_state
	return null


func process_physics(delta: float) -> State:
	%MovementCode.Move_Character("null",delta)
	if !parent.is_on_floor():
		return fall_state
	return null
