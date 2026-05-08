extends State

@export var fall_state : State
@export var jump_state : State
@export var move_state : State
@export var crouching_state : State



func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if %InputReader.currentMotionInput == 8 or %InputReader.currentMotionInput == 7 or %InputReader.currentMotionInput == 9:
		StateMachine.Old_input = %InputReader.currentMotionInput
		return jump_state
	if %InputReader.currentMotionInput == 2:
		return crouching_state
	if %InputReader.currentMotionInput == 4 or  %InputReader.currentMotionInput == 6:
		return move_state
	return null


func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5,delta)
	if !parent.is_on_floor():
		return fall_state
	return null
