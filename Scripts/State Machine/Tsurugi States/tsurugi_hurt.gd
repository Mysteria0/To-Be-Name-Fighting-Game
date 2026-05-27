extends State

@export var fall_state : State
@export var idle_state : State

var Hitstun : int
var hitstop : int

func enter() -> void:
	super()

func process_frame(_delta: float) -> State:
	if hitstop == 0:
		%MovementCode.Knockback()
		parent.velocityfixer = true
	elif hitstop < 0:
		%MovementCode.Move_Character(5)
		
	if Hitstun > 0:
		Hitstun -= 1
		hitstop -= 1
	else:
		parent.hurt = false
		
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	return null
	
