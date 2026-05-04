class_name MovementCode extends Node

@export var PerPXGravity : int
@export var PerPXForwardSpeed : int
@export var PerPXBackwardSpeed : int

@export var parent : CharacterBody2D

func Move_Character(input : String, delta : float, override : int = 0) -> void:
	if input == 'move_up':
		parent.velocity.y = -700 * delta if override == 0 else override * delta
	elif input == 'move_left':
		parent.velocity.x = -PerPXBackwardSpeed * delta if override == 0 else -override * delta
	elif input == 'move_right':
		parent.velocity.x = PerPXForwardSpeed * delta if override == 0 else override * delta
	else:
		parent.velocity.y += PerPXGravity * delta if override == 0 else override * delta
	parent.move_and_slide()
