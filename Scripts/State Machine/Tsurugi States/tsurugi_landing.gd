extends State

@export var idle_state : State
var timer : int

func enter() -> void:
	super()
	parent.velocity.x = 0
	timer = 0


func process_frame(_delta: float) -> State:
	if timer < 60:
		timer += 1
	if timer >= 60:
		return idle_state
	return null
