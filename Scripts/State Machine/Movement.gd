class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int

@export var parent : CharacterBody2D

func Move_Character(input : String, delta : float, override : int = 0) -> void:
	if input == 'move_up' or input == 'move_leftup' or input == 'move_rightup':
		parent.velocity.y = -PxPerSECJump * delta if override == 0 else override * delta
	if input == 'move_left' or input == 'move_leftup':
		parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
	if input == 'move_right' or input == 'move_rightup':
		parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
	if input == 'null':
		parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
	parent.move_and_slide()
