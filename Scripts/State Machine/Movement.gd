class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int

@export var parent : CharacterBody2D

func Move_Character(input : int, delta : float, override : int = 0) -> void:
	if input == 5:
			parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
	if input == 8 or input == 7 or input == 9:
		parent.velocity.y = -PxPerSECJump * delta if override == 0 else -override * delta
	if input == 4 or input == 7:
		parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
	if input == 6 or input == 9:
		parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
	parent.move_and_slide()
