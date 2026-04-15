extends State

@export var idle_state : State
@export var jump_state : State
@export var move_state : State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity.x = 0

func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed('ui_up') and !Input.is_action_pressed('ui_down') and parent.is_on_floor():
		return jump_state
	if !Input.is_action_pressed('ui_down') and parent.is_on_floor():
		if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right'):
			return move_state
		else:
			return idle_state
	return null
