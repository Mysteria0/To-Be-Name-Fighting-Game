extends State

@export var idle_state : State
@export var jump_state : State
@export var move_state : State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	if %InputReader.currentMotionInput != 8 and %InputReader.currentMotionInput != 9 and %InputReader.currentMotionInput != 7:
		%MovementCode.Move_Character(%InputReader.currentMotionInput,delta)
	return null

func process_frame(_delta: float) -> State:
	if %InputReader.currentMotionInput == 5:
		return idle_state
	return null
