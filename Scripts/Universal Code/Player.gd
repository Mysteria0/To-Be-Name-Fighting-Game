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
var direction : int # value 1 means facing right, value -1 means facing left


func _ready() -> void:
	state_machine.init(self)
	health = Max_health
	direction = 1


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta : float) -> void:
	state_machine.process_physics(delta)

func _process(delta : float) -> void:
	state_machine.process_frame(delta)


func Player_hit(Damage : int, hitstun : int, On_groundedhit : Vector2, On_airhit) -> void:
	health -= Damage
	Hurt_State.Hitstun = hitstun
	if !is_on_floor():
		Hurt_State.knockbackvector = On_airhit
	else:
		Hurt_State.knockbackvector = On_groundedhit
	state_machine.change_state(Hurt_State)
