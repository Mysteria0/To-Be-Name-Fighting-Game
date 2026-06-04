extends State

@export var fall_state : State
@export var idle_state : State
@export var Soft_knockdown_state : State
@export var Hard_knockdown_state : State

var Hitstun : int
var hitstop : int
var knockdown : int

func enter() -> void:
	super()
	parent.velocity *= 0

func process_frame(_delta: float) -> State:
	if hitstop == 0:
		%MovementCode.Knockback()
		%Hitbox.set_deferred("disabled",false)
	if hitstop < 0:
		%MovementCode.Move_Character(5)
	parent.move_and_slide()
		
	if Hitstun > 0:
		Hitstun -= 1
		hitstop -= 1
	elif hitstop <= 0:
		parent.hurt = false
		
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	elif parent.is_on_floor() and hitstop < -1:
		if knockdown == 1:
				return null
		elif knockdown == 2:
			return Soft_knockdown_state
		elif knockdown == 3:
			return Hard_knockdown_state
	return null
	
