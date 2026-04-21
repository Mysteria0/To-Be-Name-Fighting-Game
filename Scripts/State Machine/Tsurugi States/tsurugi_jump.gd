extends State

@export var fall_state : State
@export var idle_state : State
var whydoihavetouseaboolean : bool

func enter() -> void:
	super()
	whydoihavetouseaboolean = false
	parent.velocity.x = 0
	
func process_physics(_delta: float) -> State:
	parent.move_and_slide()
	if whydoihavetouseaboolean:
		if Input.is_action_pressed("move_left"):
			parent.velocity.x = -80
		elif Input.is_action_pressed("move_right"):
			parent.velocity.x = 80
		parent.velocity.y = -600
		parent.move_and_slide()
		return fall_state
	return null


func _on_sprites_animation_finished() -> void:
	whydoihavetouseaboolean = true
