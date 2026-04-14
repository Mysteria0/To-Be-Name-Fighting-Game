extends State

@export var fall_state : State
@export var idle_state : State

func enter() -> void:
	super()
	$Timer.start()
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 980*delta
	if parent.velocity.y > 0:
		return fall_state
	parent.move_and_slide()
	
	return null


func _on_timer_timeout() -> void:
	parent.velocity.y -= 400
