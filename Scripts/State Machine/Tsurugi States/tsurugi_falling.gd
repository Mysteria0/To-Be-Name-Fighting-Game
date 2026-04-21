extends State

@export var landing_state : State

func enter() -> void:
	super()
	
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 1000*delta
	parent.move_and_slide()
	if parent.is_on_floor():
		return landing_state
	return null
