extends State

@export var idle_state : State


func enter() -> void:
	super()

func process_physics(_delta: float) -> State:
	%MovementCode.Move_Character(5)
	
	if parent.is_on_floor():
		%Framedata.set_deferred("disabled",false)
		return idle_state
	return null
