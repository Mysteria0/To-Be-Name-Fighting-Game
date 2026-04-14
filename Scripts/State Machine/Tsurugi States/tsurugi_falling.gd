extends State

@export var landing_state : State
@export var jump_state : State

func enter() -> void:
	super()
	if Input.is_action_pressed("ui_left"):
		parent.velocity.x = -35
	elif Input.is_action_pressed("ui_right"):
		parent.velocity.x = 35
	
# Called when the node enters the scene tree for the first time.
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('ui_up'):
		return jump_state
	return null
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 980*delta
	parent.move_and_slide()
	if parent.is_on_floor():
		return landing_state
	return null
