extends State

@export var idle_state : State
@export var jump_state : State
@export var move_state : State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5,delta)
	return null

func process_frame(_delta: float) -> State:
	if %InputReader.currentMotionInput == 5:
		return idle_state
	return null
