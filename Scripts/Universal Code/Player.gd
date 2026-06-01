class_name Player
extends CharacterBody2D


@onready var movement_code: MovementCode = %MovementCode

@onready var animations = $Sprites

@onready var state_machine = $state_machine

@export_group('Character Variables')
@export var Max_health : int

@export_group('Referals')
@export var Hurt_State : State;

var health : int
var hurt : bool
var direction : int # value 1 means facing right, value -1 means facing left
var velocityfixer : bool

func _ready() -> void:
	state_machine.init(self)
	health = Max_health
	direction = 1


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta : float) -> void:
	state_machine.process_physics(delta)

	#if velocityfixer:
		#if velocity.x != 0:
			#velocity.x *= 0.95
		#if velocity.y != 0:
			#velocity.y *= 0.99
		#if velocity.length() == 0:
			#velocityfixer = false
		

func _process(delta : float) -> void:
	state_machine.process_frame(delta)

## Function for handling communication between attack and the hurt state
func Player_hit(Damage : int, Hitstop : int, hitstunGround : int, hitstunAir, On_groundedhit : Vector2, On_airhit : Vector2) -> void:
	hurt = true
	health -= Damage
	if !is_on_floor():
		Hurt_State.Hitstun = hitstunAir
		%MovementCode.knockbackvector = Vector2(On_airhit.x*direction,On_airhit.y)
	else:
		Hurt_State.Hitstun = hitstunGround
		%MovementCode.knockbackvector = Vector2(On_groundedhit.x*direction,On_groundedhit.y)
	Hurt_State.hitstop = Hitstop
	state_machine.change_state(Hurt_State)
