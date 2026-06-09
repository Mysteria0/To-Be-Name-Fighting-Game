extends State

@export var rise_state : State

var knockdowntimer

func enter() -> void:
	super()
	knockdowntimer = 45
	%Framedata.set_deferred('disabled',true)
	
func process_frame(_delta: float) -> State:
	if knockdowntimer > 0:
		knockdowntimer -= 1
	elif knockdowntimer == 0:
		%MovementCode.Knockback(Vector2(-200,-150))
		return rise_state
	return null
