extends State

@export var idle_state : State
@export var move_state : State
@export var jump_state : State
@export var crouching_state : State
@export var hurt_state : State

var hopethisworks : bool

func enter() -> void:
	super()
	hopethisworks = false
	parent.velocity.x = 0

func process_physics(delta: float) -> State:
	%MovementCode.Move_Character(5,delta)
	if hopethisworks:
		return idle_state
	return null

func _on_sprites_animation_finished() -> void:
	hopethisworks = true
