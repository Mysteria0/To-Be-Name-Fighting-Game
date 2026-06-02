class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int
@export var Horizontaljump : int

@export var parent : CharacterBody2D


var knockbackvector : Vector2


func Move_Character(input : int, override : int = 0) -> void:
	if input == 5:
			parent.velocity.y += PxPerSECGravity if override == 0 else override
	if input == 8 or input == 7 or input == 9:
		parent.velocity.y = -PxPerSECJump if override == 0 else -override
	if input == 4:
		parent.velocity.x = -PxPerSECBackward if override == 0 else -override
	if input == 6:
		parent.velocity.x = PxPerSECForward if override == 0 else override
	if input == 7 or input == 9:
		parent.velocity.x =  Horizontaljump if input == 9 else -Horizontaljump
	parent.move_and_slide()

func Knockback(override := Vector2()) -> void:
	parent.velocity *= 0
	
	if override == Vector2():
		parent.velocity.y += knockbackvector.y
		parent.velocity.x += knockbackvector.x
	else:
		parent.velocity.y += override.y
		parent.velocity.x += override.x 

	parent.move_and_slide()
