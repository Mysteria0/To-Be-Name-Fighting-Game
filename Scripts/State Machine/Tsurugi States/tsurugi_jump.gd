extends State

@export var fall_state : State
@export var idle_state : State
var whydoihavetouseaboolean : bool

func enter() -> void:
	super()
	whydoihavetouseaboolean = false
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if whydoihavetouseaboolean:
		%MovementCode.Move_Character(StateMachine.Current_Motion,delta)
		%MovementCode.Move_Character('move_up',delta)
		return fall_state
	return null


func _on_sprites_animation_finished() -> void:
	whydoihavetouseaboolean = true
