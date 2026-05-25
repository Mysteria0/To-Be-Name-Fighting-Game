extends State

@export var landing_state : State
@export var hurt_state : State

func enter() -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	super()
	

func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5,0)
	if parent.is_on_floor():
		return landing_state
	return null
