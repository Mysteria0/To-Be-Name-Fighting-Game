extends State

@export var landing_state : State
@export var hurt_state : State

var booleanforanimfinish : bool

func enter() -> void:
	super()
	booleanforanimfinish = false

func process_physics(_delta: float) -> State:
	%MovementCode.Move_Character(5)
	if parent.is_on_floor():
		parent.velocity.x = 0
		if booleanforanimfinish:
			booleanforanimfinish = false
			return landing_state
	return null


func _on_sprites_animation_finished() -> void:
	if StateMachine.current_state == self:
		booleanforanimfinish = true
		%MovementCode.Knockback(Vector2(-300*parent.direction,-150))
