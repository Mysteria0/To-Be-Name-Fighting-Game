class_name Player
extends CharacterBody2D


@onready var movement_code: MovementCode = %MovementCode

@onready var animations = $Sprites

@onready var state_machine = $state_machine

@export_group('Character Variables')
@export var Max_health : int

@export_group('Character command list')
@export var Characterinputs : Array[StringName];

var health : int


func _ready() -> void:
	state_machine.init(self)
	health = Max_health


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta : float) -> void:
	state_machine.process_physics(delta)

func _process(delta : float) -> void:
	state_machine.process_frame(delta)
