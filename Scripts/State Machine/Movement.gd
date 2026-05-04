class_name MovementCode extends Node

@export var PerPXGravity : int
@export var PerPXForwardSpeed : int
@export var PerPXBackwardSpeed : int

@export var parent : CharacterBody2D

func Move_Character(input : String, override = 0) -> void:
	if input == 'move_up':
		parent.velocity.y -= 700 if override == 0 else override
	elif input == 'move_left':
		parent.velocity.x = -PerPXBackwardSpeed if override == 0 else -override 
	elif input == 'move_right':
		parent.velocity.x = PerPXForwardSpeed if override == 0 else override
	else:
		parent.velocity.y += PerPXGravity if override == 0 else override
	parent.move_and_slide()
