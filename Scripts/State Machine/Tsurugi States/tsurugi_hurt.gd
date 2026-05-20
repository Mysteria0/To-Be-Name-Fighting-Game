extends State

@export var fall_state : State
@export var idle_state : State

var saved_velocity : Vector2
var knockbackvector : Vector2
var Hitstun : int
var timer : int

func enter() -> void:
	super()
	saved_velocity = parent.velocity
	parent.velocity *= 0
	timer = 1

func process_frame(_delta: float) -> State:
	if Hitstun > 0:
		Hitstun -= 1
		timer -= 1
	else:
		parent.hurt = false
	
	if timer == 0:
		Knockback()
	
	if !parent.hurt:
		if parent.is_on_floor():
			return idle_state
		else:
			return fall_state
	return null
	

func Knockback() -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	if saved_velocity.y != 0:
		parent.velocity.y += knockbackvector.y
	parent.velocity.x += knockbackvector.x*parent.direction
	parent.move_and_slide()
