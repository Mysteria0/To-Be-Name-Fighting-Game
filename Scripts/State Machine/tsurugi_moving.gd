extends State

@export var fall_state : State
@export var jump_state : State
@export var idle_state : State

func enter() -> void:
	super()
	parent.velocity.x += 10
	
func process_input(event: InputEvent) -> State:
	if parent.is_on_floor() and !event:
		return idle_state
	if Input.is_action_just_pressed('ui_up') and parent.is_on_floor():
		return jump_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 980*delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
