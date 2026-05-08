extends State

@export var idle_state : State
@export var jump_state : State
@export var move_state : State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	if StateMachine.Current_Motion != 8 and StateMachine.Current_Motion != 9 and StateMachine.Current_Motion != 7:
		%MovementCode.Move_Character(StateMachine.Current_Motion,delta)
	return null

func process_frame(delta: float) -> State:
	if StateMachine.Current_Motion == 5:
		return idle_state
	return null
