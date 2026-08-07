extends State

@export var landing_state : State
@export var hurt_state : State



func enter() -> void:
	super()
	

func process_physics(_delta: float) -> State:
	%MovementCode.Move_Character(5)
	if parent.is_on_floor():
		return landing_state
	return null
