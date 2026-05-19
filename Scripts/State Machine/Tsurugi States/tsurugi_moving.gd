extends State

@export var fall_state : State
@export var jump_state : State
@export var idle_state : State
@export var crouching_state : State
@export var hurt_state : State

func enter() -> void:
	super()

func process_input(_event: InputEvent) -> State:
	if %InputReader.currentMotionInput == 8 or %InputReader.currentMotionInput == 7 or %InputReader.currentMotionInput == 9:
		StateMachine.Old_input = %InputReader.currentMotionInput
		return jump_state
	if %InputReader.currentMotionInput == 2:
		return crouching_state
	return null

func process_physics(delta: float) -> State:
	if %InputReader.currentMotionInput != 8 and %InputReader.currentMotionInput != 9 and %InputReader.currentMotionInput != 7:
		%MovementCode.Move_Character(%InputReader.currentMotionInput,delta)
	return null

func process_frame(_delta: float) -> State:
	if %InputReader.currentMotionInput == 5:
		return idle_state
	if parent.hurt:
		return hurt_state
	return null
	
