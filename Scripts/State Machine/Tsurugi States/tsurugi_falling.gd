extends State

@export var landing_state : State
@export var hurt_state : State


var timer

func enter() -> void:
	super()
	timer = 10
	

func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5)
	if parent.is_on_floor():
		return landing_state
	return null
