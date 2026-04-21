extends State

@export var idle_state : State
@export var move_state : State
@export var jump_state : State
@export var crouching_state : State

var hopethisworks : bool

func enter() -> void:
	super()
	parent.velocity.x = 0
	hopethisworks = false
	
func process_physics(delta: float) -> State:
	parent.velocity.y += 980*delta
	parent.move_and_slide()
	if hopethisworks:
		if !Input.is_action_pressed("move_up") and !Input.is_action_pressed("move_down"):
			if Input.is_action_pressed('move_left') or Input.is_action_pressed('move_right'):
				return move_state
			else:
				return idle_state
		elif Input.is_action_pressed("move_up"):
			return jump_state
		elif Input.is_action_pressed("move_down"):
			return crouching_state
		else:
			return idle_state
	return null

func _on_sprites_animation_finished() -> void:
	hopethisworks = true
