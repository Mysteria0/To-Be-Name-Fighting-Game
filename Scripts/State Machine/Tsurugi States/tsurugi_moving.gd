extends State

@export var fall_state : State
@export var jump_state : State
@export var idle_state : State
@export var crouching_state : State

func enter() -> void:
	super()

func process_input(_event: InputEvent) -> State:
	if StateMachine.Current_Motion == 8 or StateMachine.Current_Motion == 7 or StateMachine.Current_Motion == 9:
		StateMachine.Old_input = StateMachine.Current_Motion
		return jump_state
	if StateMachine.Current_Motion == 2:
		return crouching_state
	if StateMachine.Current_Motion == 5:
		return idle_state
	return null

func process_physics(delta: float) -> State:
	if StateMachine.Current_Motion != 8 and StateMachine.Current_Motion != 9 and StateMachine.Current_Motion != 7:
		%MovementCode.Move_Character(StateMachine.Current_Motion,delta)
	return null
