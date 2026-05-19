extends State

@export var fall_state : State
@export var idle_state : State

var saved_velocity : Vector2


func enter() -> void:
	super()
	saved_velocity = parent.velocity
	parent.velocity *= 0

func process_frame(_delta: float) -> State:
	if parent.hitstun > 0:
		parent.hitstun -= 1
	else:
		parent.hurt = false
		
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	return null
	

func Knockback() -> void:
	if saved_velocity.y != 0:
		parent.velocity.y += parent.knockbackvector.y
	parent.velocity.x += parent.knockbackvector.x*parent.direction
	parent.move_and_slide()
