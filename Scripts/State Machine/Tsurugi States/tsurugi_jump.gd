extends State

@export var fall_state : State
@export var hurt_state : State

var whydoihavetouseaboolean : bool

func enter() -> void:
	super()
	whydoihavetouseaboolean = false
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	if whydoihavetouseaboolean:
		%MovementCode.Move_Character(StateMachine.Old_input,delta)
		StateMachine.Old_input = 5
		return fall_state
	return null


func _on_sprites_animation_finished() -> void:
	whydoihavetouseaboolean = true
