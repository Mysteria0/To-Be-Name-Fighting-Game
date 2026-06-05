extends State

@export var idle_state : State
@export var jump_state : State
@export var move_state : State
@export var hurt_state : State

# Called when the node enters the scene tree for the first time.
func enter() -> void:
	super()
	parent.velocity.x = 0
	%Framedata.Change_Hitbox(Vector2(24,32),Vector2(0,17))
	

func process_physics(_delta: float) -> State:
	%MovementCode.Move_Character(5)
	return null

func process_frame(_delta: float) -> State:
	if %InputReader.currentMotionInput == 5:
		%Framedata.Change_Hitbox(Vector2(24,52),Vector2(0,6))
		return idle_state
	return null
