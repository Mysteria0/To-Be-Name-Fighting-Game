class_name MovementCode extends Node

@export var PxPerSECGravity : int
@export var PxPerSECForward : int
@export var PxPerSECBackward : int
@export var PxPerSECJump : int

@export var parent : CharacterBody2D

var knockbackvector : Vector2i


func Move_Character(input : int, delta : float, override : int = 0) -> void:
	if input == 5:
			parent.velocity.y += PxPerSECGravity * delta if override == 0 else override * delta
	if input == 8 or input == 7 or input == 9:
		parent.velocity.y = -PxPerSECJump * delta if override == 0 else -override * delta
	if input == 4 or input == 7:
		parent.velocity.x = -PxPerSECBackward * delta if override == 0 else -override * delta
		if input == 7:
			parent.velocity.x = -PxPerSECBackward * delta * 2 if override == 0 else -override * delta * 2
	if input == 6 or input == 9:
		parent.velocity.x = PxPerSECForward * delta if override == 0 else override * delta
		if input == 9:
			parent.velocity.x = PxPerSECForward * delta * 2 if override == 0 else override * delta * 2
	parent.move_and_slide()

func Knockback(Override : Vector2i = Vector2i(0,0)) -> void:
	%CollisionShape2D.set_deferred("disabled", false)
	if Override == Vector2i():
		parent.velocity.y += knockbackvector.y
		parent.velocity.x += knockbackvector.x*parent.direction
	else:
		parent.velocity.y += Override.y
		parent.velocity.x += Override.x*parent.direction
	parent.move_and_slide()
