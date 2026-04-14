extends State

@export var fall_state : State
@export var idle_state : State
@export var landing_state : State


func enter() -> void:
	super()
	parent.velocity.y = -9000
		
func process_physics(delta: float) -> State:
	parent.velocity.y += 980 * delta

	if parent.velocity.y > 0:
		return fall_state
		
	
	if parent.is_on_floor():
		return landing_state
	return null
