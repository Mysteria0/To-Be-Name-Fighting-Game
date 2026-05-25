class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int

@export var parent : CharacterBody2D


var knockbackvector : Vector2i

var Horizontaljump : int = 133
var PxPerSECJump : int = 825

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

func Knockback(Override : Vector2i = Vector2i(0,0)) -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	parent.velocity = Vector2i()
	if Override == Vector2i():
		parent.velocity.y += knockbackvector.y
		parent.velocity.x += knockbackvector.x*parent.direction
	else:
		parent.velocity.y += Override.y
		parent.velocity.x += Override.x*parent.direction
	parent.move_and_slide()
