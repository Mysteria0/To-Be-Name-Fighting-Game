extends State

@export var landing_state : State

func enter() -> void:
	super()
	if Input.is_action_pressed("ui_left"):
		parent.velocity.x = -80
	elif Input.is_action_pressed("ui_right"):
		parent.velocity.x = 80
	
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 980*delta
	parent.move_and_slide()
	if parent.is_on_floor():
		return landing_state
	return null
