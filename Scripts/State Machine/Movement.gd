class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int

@export var parent : CharacterBody2D

func Move_Character(input : String, delta : float, override : int = 0) -> void:
	if input == 'move_up':
		parent.velocity.y = -PxPerSECJump * delta if override == 0 else override * delta
	elif input == 'move_left':
		parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
	elif input == 'move_right':
		parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
	else:
		parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
	parent.move_and_slide()
