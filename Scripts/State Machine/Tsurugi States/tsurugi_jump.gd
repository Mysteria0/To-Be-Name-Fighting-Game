extends State

@export var fall_state : State
@export var idle_state : State
var whydoihavetouseaboolean : bool

func enter() -> void:
	super()
	whydoihavetouseaboolean = false
	
func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if whydoihavetouseaboolean:
		parent.velocity.y = -400
		parent.move_and_slide()
		return fall_state
	return null


func _on_sprites_animation_finished() -> void:
	whydoihavetouseaboolean = true
