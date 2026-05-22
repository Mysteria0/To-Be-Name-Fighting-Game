extends State

@export var fall_state : State
@export var idle_state : State

var Hitstun : int
var timer : int

func enter() -> void:
	super()
	%MovementCode.Knockback(parent.velocity*-1.5)
	parent.velocity *= 0
	timer = 1

func process_frame(_delta: float) -> State:
	if Hitstun > 0:
		Hitstun -= 1
		timer -= 1
	else:
		parent.hurt = false
	
	if timer == 0:
		%MovementCode.Knockback()
	elif timer > 0:
		parent.velocity *= 0
	
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	return null
	
