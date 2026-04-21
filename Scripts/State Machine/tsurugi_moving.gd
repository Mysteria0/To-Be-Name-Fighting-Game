extends State

@export var fall_state : State
@export var jump_state : State
@export var idle_state : State
@export var crouching_state : State

func enter() -> void:
	super()
	
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('move_up') and parent.is_on_floor():
		return jump_state
	if Input.is_action_pressed('move_down') and parent.is_on_floor():
		return crouching_state
	return null
	
func process_physics(delta: float) -> State:
	if Input.is_action_pressed("move_left"):
		parent.velocity.x = -50
	elif Input.is_action_pressed("move_right"):
		parent.velocity.x = 65
	elif parent.velocity.x != 0:
		parent.velocity.x -= parent.velocity.x
	parent.velocity.y += 980*delta
	parent.move_and_slide()
	if parent.is_on_floor() and parent.velocity.x == 0:
		return idle_state
	if !parent.is_on_floor():
		return fall_state
	return null
