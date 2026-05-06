class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int

@export var parent : CharacterBody2D

func Move_Character(input : int, delta : float, override : int = 0) -> void:
	match input:
		5:
			parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
		8: 
			parent.velocity.y = -PxPerSECJump * delta if override == 0 else override * delta
		4:
			parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
		6:
			parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
		7:
			parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
			parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
		9:
			parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
			parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
	parent.move_and_slide()
