extends State

@export var fall_state : State
@export var idle_state : State

var Hitstun : int
var timer : int

func enter() -> void:
	super()
	timer = 1

func process_frame(delta: float) -> State:
	if timer == 0:
		%MovementCode.Knockback(delta)
	elif timer == 1:
		parent.velocity *= 0
		%MovementCode.Knockback(delta,parent.velocity*-10000)
	elif timer < 0:
		%MovementCode.Move_Character(5,delta)
		
	if Hitstun > 0:
		Hitstun -= 1
		timer -= 1
	else:
		parent.hurt = false
		
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	return null
	
