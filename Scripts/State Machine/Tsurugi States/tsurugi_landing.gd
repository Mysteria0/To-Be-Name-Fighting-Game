extends State

@export var idle_state : State
@export var move_state : State
var timer : int

func enter() -> void:
	super()
	parent.velocity.x = 0
	timer = 0


func process_frame(_delta: float) -> State:
	if timer < 40:
		timer += 1
	if timer >= 40:
		if Input.is_action_pressed('ui_left') or Input.is_action_pressed('ui_right') and parent.is_on_floor():
			return move_state
		else:
			return idle_state
	return null
